//
//  HeadersInterceptor.swift
//  NetworkKit
//
//  Created by Marwa Attef on 08/07/2026.
//
import Foundation

/// A request interceptor that adds HTTP headers to outgoing requests.
///
/// `HeadersInterceptor` injects a predefined collection of HTTP headers
/// into every intercepted request.
///
/// If a header already exists on the request, its value is replaced by
/// the value provided by the interceptor.
///
/// Typical use cases include:
///
/// - API version headers
/// - Application identifiers
/// - Custom client metadata
/// - Static authorization headers
public struct HeadersInterceptor: RequestInterceptor {

    /// The headers to be added to each request.
    private let headers: HTTPHeaders

    /// Creates a headers interceptor.
    ///
    /// - Parameter headers: The collection of headers to apply.
    public init(headers: HTTPHeaders) {
        self.headers = headers
    }

    /// Applies the configured headers to the request.
    ///
    /// Each configured header is added to the request. Existing header
    /// values with the same field name are overwritten.
    ///
    /// - Parameters:
    ///   - request: The request to intercept.
    ///   - endpoint: The endpoint associated with the request.
    ///
    /// - Returns: The modified request containing the configured headers.
    ///
    /// - Throws: This implementation does not throw.
    public func intercept(
        _ request: URLRequest,
        endpoint: any Endpoint
    ) async throws -> URLRequest {

        var request = request

        for (field, value) in headers.dictionary {
            request.setValue(value, forHTTPHeaderField: field)
        }

        return request
    }
}
