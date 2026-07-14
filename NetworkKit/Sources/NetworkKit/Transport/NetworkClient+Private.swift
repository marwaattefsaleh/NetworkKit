//
//  NetworkClient+Private.swift
//  NetworkKit
//
//  Created by Marwa Attef on 08/07/2026.
//
import Foundation

/// Applies request and response interceptors during the network request lifecycle.
///
/// This extension encapsulates the execution of configured request and response
/// interceptors, allowing the networking pipeline to modify requests before they
/// are sent and process responses after they are received.
///
/// Interceptors are executed sequentially in the order they were registered
/// in the `NetworkConfiguration`.
extension NetworkClient {

    /// Applies all configured request interceptors.
    ///
    /// Each interceptor receives the output of the previous interceptor,
    /// allowing multiple request transformations to be composed.
    ///
    /// Typical use cases include:
    ///
    /// - Adding authentication headers.
    /// - Injecting localization headers.
    /// - Modifying request metadata.
    /// - Logging outgoing requests.
    ///
    /// - Parameters:
    ///   - request: The original request.
    ///   - endpoint: The endpoint associated with the request.
    ///
    /// - Returns: The transformed `URLRequest`.
    ///
    /// - Throws: Any error thrown by a request interceptor.
    func applyRequestInterceptors(
        _ request: URLRequest,
        endpoint: any Endpoint
    ) async throws -> URLRequest {

        var request = request

        for interceptor in requestInterceptors {

            request = try await interceptor.intercept(
                request,
                endpoint: endpoint
            )
        }

        return request
    }

    /// Applies all configured response interceptors.
    ///
    /// Each interceptor receives the output of the previous interceptor,
    /// allowing multiple response transformations to be composed.
    ///
    /// Typical use cases include:
    ///
    /// - Refreshing authentication tokens.
    /// - Extracting response metadata.
    /// - Transforming response payloads.
    /// - Logging incoming responses.
    ///
    /// - Parameters:
    ///   - response: The received network response.
    ///   - request: The original request.
    ///   - endpoint: The endpoint associated with the request.
    ///
    /// - Returns: The transformed ``NetworkResponse``.
    ///
    /// - Throws: Any error thrown by a response interceptor.
    func applyResponseInterceptors(
        _ response: NetworkResponse,
        request: URLRequest,
        endpoint: any Endpoint
    ) async throws -> NetworkResponse {

        var response = response

        for interceptor in responseInterceptors {

            response = try await interceptor.intercept(
                response,
                request: request,
                endpoint: endpoint
            )
        }

        return response
    }
}
