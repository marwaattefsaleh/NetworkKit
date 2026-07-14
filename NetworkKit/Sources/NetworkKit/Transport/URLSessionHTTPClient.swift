//
//  URLSessionHTTPClient.swift
//  NetworkKit
//
//  Created by Marwa Attef on 08/07/2026.
//
import Foundation

/// An `HTTPClient` implementation backed by `URLSession`.
///
/// `URLSessionHTTPClient` executes HTTP requests using Apple's native
/// `URLSession` API and converts the results into ``NetworkResponse``
/// instances.
///
/// It provides a lightweight transport implementation with no external
/// dependencies, making it suitable for most applications and unit tests.
///
/// - Note:
///   `URLSession` does not conform to `Sendable`. This type is marked
///   `@unchecked Sendable` because `URLSession` is designed to be safely
///   shared across concurrent tasks.
public final class URLSessionHTTPClient:
    HTTPClient,
    @unchecked Sendable {

    /// The URL session used to execute HTTP requests.
    private let session: URLSession

    /// Creates an HTTP client using the specified URL session.
    ///
    /// - Parameter session: The `URLSession` used to execute requests.
    ///   Defaults to `URLSession.shared`.
    public init(
        session: URLSession = .shared
    ) {
        self.session = session
    }

    /// Executes an HTTP request using `URLSession`.
    ///
    /// The request is performed asynchronously using Swift Concurrency.
    /// On success, the received response is converted into a
    /// ``NetworkResponse``.
    ///
    /// - Parameter request: The request to execute.
    ///
    /// - Returns: The received ``NetworkResponse``.
    ///
    /// - Throws:
    ///   - ``NetworkError/invalidResponse`` if the received response is
    ///     not an `HTTPURLResponse`.
    ///   - Any error thrown by `URLSession` while executing the request.
    public func execute(
        _ request: URLRequest
    ) async throws -> NetworkResponse {

        let (data, response) =
            try await session.data(
                for: request
            )

        guard let httpResponse =
                response as? HTTPURLResponse
        else {

            throw NetworkError.invalidResponse
        }

        return NetworkResponse(
            data: data,
            response: httpResponse
        )
    }
}
