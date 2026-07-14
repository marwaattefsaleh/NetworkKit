//
//  URLRequestBuilder.swift
//  NetworkKit
//
//  Created by Marwa Attef on 08/07/2026.
//


import Foundation

/// Builds `URLRequest` instances from `Endpoint` definitions.
///
/// `URLRequestBuilder` is responsible for translating an `Endpoint`
/// into a fully configured `URLRequest`.
///
/// The builder applies:
///
/// - Base URL
/// - Path
/// - HTTP method
/// - Default environment headers
/// - Endpoint-specific headers
/// - Request body
///
/// Transport-specific concerns such as request execution,
/// retries, and logging are intentionally excluded.
public struct URLRequestBuilder: Sendable {

    /// The networking environment used to build requests.
    private let environment: NetworkEnvironment
    /// Default timeout applied to every request.
    private let timeoutInterval: TimeInterval


    /// Creates a request builder.
    ///
    /// - Parameters:
    ///   - environment: Network environment containing the base URL
    ///     and default headers.
    ///   - timeoutInterval: Timeout applied to created requests.
    public init(
        environment: NetworkEnvironment,
        timeoutInterval: TimeInterval = 30
    ) {

        self.environment = environment
        self.timeoutInterval = timeoutInterval
    }


    /// Builds a `URLRequest` from the supplied endpoint.
    ///
    /// The resulting request includes:
    ///
    /// - Fully resolved URL
    /// - HTTP method
    /// - Headers
    /// - Request body
    ///
    /// - Parameter endpoint: Endpoint describing the request.
    /// - Returns: A configured `URLRequest`.
    /// - Throws: An error if URL construction or body encoding fails.
    public func build(
        endpoint: any Endpoint
    ) throws -> URLRequest {


        // MARK: URL

        let url = try buildURL(
            endpoint: endpoint
        )


        var request = URLRequest(
            url: url,
            timeoutInterval: timeoutInterval
        )


        // MARK: Method

        request.httpMethod =
            endpoint.method.rawValue



        // MARK: Headers

        applyHeaders(
            endpoint: endpoint,
            request: &request
        )



        // MARK: Body

        try applyBody(
            endpoint: endpoint,
            request: &request
        )


        return request
    }
}



// MARK: - Private Helpers


private extension URLRequestBuilder {

    /// Builds the request URL.
    ///
    /// Combines the environment's base URL with the endpoint path.
    ///
    /// - Parameter endpoint: Endpoint describing the request.
    /// - Returns: The resolved URL.
    func buildURL(
        endpoint: any Endpoint
    ) throws -> URL {

        let baseURL = environment.baseURL
            .appendingPathComponent(endpoint.path)

        guard var components = URLComponents(
            url: baseURL,
            resolvingAgainstBaseURL: false
        ) else {
            throw NetworkError.invalidURL
        }

        if !(endpoint.queryItems?.isEmpty ?? true) {
            components.queryItems = endpoint.queryItems
        }

        guard let url = components.url else {
            throw NetworkError.invalidURL
        }

        return url
    }


    /// Applies headers to the request.
    ///
    /// Environment headers are applied first,
    /// followed by endpoint headers.
    ///
    /// Endpoint headers override environment headers
    /// when duplicate field names exist.
    func applyHeaders(
        endpoint: any Endpoint,
        request: inout URLRequest
    ) {


        // Environment headers

        environment
            .defaultHeaders
            .forEach { key, value in

                request.setValue(
                    value,
                    forHTTPHeaderField: key
                )
            }



        // Endpoint headers

        endpoint
            .headers
            .forEach { key, value in

                request.setValue(
                    value,
                    forHTTPHeaderField: key
                )
            }
    }


    /// Applies the request body.
    ///
    /// The request body is responsible for encoding itself.
    ///
    /// If the body provides a content type,
    /// the `Content-Type` header is automatically added.
    ///
    /// - Throws: An error if body encoding fails.
    private func applyBody(
        endpoint: any Endpoint,
        request: inout URLRequest
    ) throws {

       let body = endpoint.body


        try body.apply(
            to: &request
        )


        if let contentType = body.contentType {

            request.setValue(
                contentType,
                forHTTPHeaderField: "Content-Type"
            )
        }
    }
}
