//
//  RequestInterceptorChain.swift
//  NetworkKit
//
//  Created by Marwa Attef on 08/07/2026.
//

import Foundation

/// Executes a sequence of request interceptors.
///
/// `RequestInterceptorChain` applies multiple `RequestInterceptor`
/// instances in the order they were provided. Each interceptor receives
/// the output of the previous interceptor, allowing request
/// transformations to be composed into a processing pipeline.
///
/// This type is implemented as an `actor` to ensure safe execution
/// when accessed concurrently from multiple tasks.
public actor RequestInterceptorChain {

    /// The interceptors to execute.
    private let interceptors: [any RequestInterceptor]

    /// Creates a request interceptor chain.
    ///
    /// - Parameter interceptors: The interceptors to execute in order.
    ///   Defaults to an empty collection.
    public init(
        interceptors: [any RequestInterceptor] = []
    ) {
        self.interceptors = interceptors
    }

    /// Executes all configured request interceptors.
    ///
    /// Each interceptor receives the request returned by the previous
    /// interceptor. The final transformed request is returned to the caller.
    ///
    /// - Parameters:
    ///   - request: The initial request.
    ///   - endpoint: The endpoint associated with the request.
    ///
    /// - Returns: The request after all interceptors have been applied.
    ///
    /// - Throws: Any error thrown by an interceptor in the chain.
    public func execute(
        request: URLRequest,
        endpoint: any Endpoint
    ) async throws -> URLRequest {

        var request = request

        for interceptor in interceptors {
            request = try await interceptor.intercept(
                request,
                endpoint: endpoint
            )
        }

        return request
    }
}
