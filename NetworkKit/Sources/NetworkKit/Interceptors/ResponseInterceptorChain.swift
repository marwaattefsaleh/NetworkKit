//
//  ResponseInterceptorChain.swift
//  NetworkKit
//
//  Created by Marwa Attef on 08/07/2026.
//
import Foundation

/// Executes a sequence of response interceptors.
///
/// `ResponseInterceptorChain` applies multiple `ResponseInterceptor`
/// instances to a received network response.
///
/// Interceptors are executed in reverse order of registration, allowing
/// response processing to occur in the opposite direction of request
/// interception. This mirrors middleware pipelines commonly found in
/// networking frameworks.
///
/// This type is implemented as an `actor` to ensure safe execution
/// when accessed concurrently from multiple tasks.
public actor ResponseInterceptorChain {

    /// The response interceptors to execute.
    private let interceptors: [any ResponseInterceptor]

    /// Creates a response interceptor chain.
    ///
    /// - Parameter interceptors: The interceptors to execute.
    ///   Defaults to an empty collection.
    public init(
        interceptors: [any ResponseInterceptor] = []
    ) {
        self.interceptors = interceptors
    }

    /// Executes all configured response interceptors.
    ///
    /// Interceptors are executed in reverse order of registration.
    /// Each interceptor receives the response returned by the previous
    /// interceptor, allowing response transformations to be composed.
    ///
    /// - Parameters:
    ///   - response: The received network response.
    ///   - request: The original request.
    ///   - endpoint: The endpoint associated with the request.
    ///
    /// - Returns: The response after all interceptors have been applied.
    ///
    /// - Throws: Any error thrown by an interceptor in the chain.
    public func execute(
        response: NetworkResponse,
        request: URLRequest,
        endpoint: any Endpoint
    ) async throws -> NetworkResponse {

        var response = response

        for interceptor in interceptors.reversed() {
            response = try await interceptor.intercept(
                response,
                request: request,
                endpoint: endpoint
            )
        }

        return response
    }
}
