//
//  UserAgentInterceptor.swift
//  NetworkKit
//
//  Created by Marwa Attef on 08/07/2026.
//
import Foundation

/// A request interceptor that adds a `User-Agent` header to outgoing requests.
///
/// `UserAgentInterceptor` identifies the client application to the server
/// by setting the `User-Agent` HTTP header.
///
/// Supplying a custom user agent can help servers distinguish between
/// different application versions, platforms, or client implementations.
///
/// Typical use cases include:
///
/// - Identifying the application version
/// - Providing device or platform information
/// - API analytics and monitoring
/// - Backend request tracing
public struct UserAgentInterceptor: RequestInterceptor {

    /// The value to set for the `User-Agent` header.
    private let userAgent: String

    /// Creates a user agent interceptor.
    ///
    /// - Parameter userAgent: The value to include in the
    ///   `User-Agent` HTTP header.
    public init(_ userAgent: String) {
        self.userAgent = userAgent
    }

    /// Adds the `User-Agent` header to the request.
    ///
    /// If the request already contains a `User-Agent` header,
    /// its value is replaced with the configured user agent.
    ///
    /// - Parameters:
    ///   - request: The request to intercept.
    ///   - endpoint: The endpoint associated with the request.
    ///
    /// - Returns: The modified request containing the `User-Agent` header.
    ///
    /// - Throws: This implementation does not throw.
    public func intercept(
        _ request: URLRequest,
        endpoint: any Endpoint
    ) async throws -> URLRequest {

        var request = request

        request.setValue(
            userAgent,
            forHTTPHeaderField: "User-Agent"
        )

        return request
    }
}
