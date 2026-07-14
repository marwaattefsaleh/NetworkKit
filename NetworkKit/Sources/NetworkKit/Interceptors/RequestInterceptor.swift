//
//  RequestInterceptor.swift
//  NetworkKit
//
//  Created by Marwa Attef on 08/07/2026.
//


import Foundation

/// Defines an object that can inspect and modify an outgoing request.
///
/// `RequestInterceptor` provides a mechanism for intercepting requests
/// before they are executed by the underlying HTTP client.
///
/// Interceptors are executed sequentially by `NetworkClient`, allowing
/// multiple request transformations to be composed.
///
/// Typical use cases include:
///
/// - Adding authentication tokens
/// - Injecting custom HTTP headers
/// - Setting localization headers
/// - Modifying request metadata
/// - Adding request tracing information
///
/// Custom interceptors can conform to this protocol to implement
/// application-specific request processing.
public protocol RequestInterceptor: Sendable {

    /// Intercepts and optionally modifies a request before it is sent.
    ///
    /// - Parameters:
    ///   - request: The request to intercept.
    ///   - endpoint: The endpoint associated with the request.
    ///
    /// - Returns: The modified request to continue through the networking pipeline.
    ///
    /// - Throws: An error if the request cannot be prepared.
    func intercept(
        _ request: URLRequest,
        endpoint: any Endpoint
    ) async throws -> URLRequest
}

public extension RequestInterceptor {

    /// Returns the original request unchanged.
    ///
    /// This default implementation allows conforming types to implement
    /// the protocol selectively when request modification is unnecessary.
    ///
    /// - Parameters:
    ///   - request: The request to intercept.
    ///   - endpoint: The endpoint associated with the request.
    ///
    /// - Returns: The original request.
    ///
    /// - Throws: This implementation does not throw.
    func intercept(
        _ request: URLRequest,
        endpoint: any Endpoint
    ) async throws -> URLRequest {
        request
    }
}
