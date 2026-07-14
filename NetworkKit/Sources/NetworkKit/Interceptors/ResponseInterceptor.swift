//
//  ResponseInterceptor.swift
//  NetworkKit
//
//  Created by Marwa Attef on 08/07/2026.
//
import Foundation

/// Defines an object that can inspect and modify a received network response.
///
/// `ResponseInterceptor` provides a mechanism for intercepting responses
/// after they have been received by the underlying HTTP client and before
/// they are validated or decoded.
///
/// Response interceptors are executed sequentially by `NetworkClient`,
/// allowing multiple response transformations to be composed.
///
/// Typical use cases include:
///
/// - Refreshing expired authentication credentials
/// - Inspecting response headers
/// - Transforming response data
/// - Recording analytics
/// - Handling application-specific response metadata
///
/// Custom interceptors can conform to this protocol to implement
/// application-specific response processing.
public protocol ResponseInterceptor: Sendable {

    /// Intercepts and optionally modifies a network response.
    ///
    /// - Parameters:
    ///   - response: The received network response.
    ///   - request: The original request associated with the response.
    ///   - endpoint: The endpoint associated with the request.
    ///
    /// - Returns: The modified network response.
    ///
    /// - Throws: An error if the response cannot be processed.
    func intercept(
        _ response: NetworkResponse,
        request: URLRequest,
        endpoint: any Endpoint
    ) async throws -> NetworkResponse
}

public extension ResponseInterceptor {

    /// Returns the original response unchanged.
    ///
    /// This default implementation allows conforming types to implement
    /// the protocol selectively when response modification is unnecessary.
    ///
    /// - Parameters:
    ///   - response: The received network response.
    ///   - request: The original request associated with the response.
    ///   - endpoint: The endpoint associated with the request.
    ///
    /// - Returns: The original network response.
    ///
    /// - Throws: This implementation does not throw.
    func intercept(
        _ response: NetworkResponse,
        request: URLRequest,
        endpoint: any Endpoint
    ) async throws -> NetworkResponse {
        response
    }
}
