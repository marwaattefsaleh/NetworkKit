//
//  NetworkClient+Execute.swift
//  NetworkKit
//
//  Created by Marwa Attef on 08/07/2026.
//

import Foundation

/// Provides the public request execution API for `NetworkClient`.
///
/// These methods coordinate the complete networking pipeline, including:
///
/// - Building requests.
/// - Applying request interceptors.
/// - Logging outgoing requests.
/// - Executing requests through the configured HTTP client.
/// - Applying retry policies.
/// - Processing response interceptors.
/// - Validating responses.
/// - Logging completed responses.
/// - Mapping errors into `NetworkError`.
public extension NetworkClient {

    /// Executes the specified endpoint and returns its response.
    ///
    /// The request lifecycle consists of the following steps:
    ///
    /// 1. Build the `URLRequest`.
    /// 2. Apply request interceptors.
    /// 3. Log the outgoing request.
    /// 4. Execute the request using the configured `HTTPClient`.
    /// 5. Apply the configured retry policy.
    /// 6. Apply response interceptors.
    /// 7. Validate the response.
    /// 8. Log the completed response.
    /// 9. Return the resulting ``NetworkResponse``.
    ///
    /// Any error encountered during execution is mapped using the configured
    /// ``ErrorMapper`` before being propagated to the caller.
    ///
    /// - Parameter endpoint: The endpoint to execute.
    ///
    /// - Returns: The resulting ``NetworkResponse``.
    ///
    /// - Throws: A mapped `NetworkError` if request execution fails.
    func execute(
        _ endpoint: any Endpoint
    ) async throws -> NetworkResponse {

        do {

            var request = try builder.build(
                endpoint: endpoint
            )

            request = try await applyRequestInterceptors(
                request,
                endpoint: endpoint
            )

            logger.log(
                RequestLogEvent(
                    request: request
                )
            )

            let start = Date()
            let finalRequest = request

            let response = try await retryExecutor.execute(
                request: request
            ) {
                try await self.httpClient.execute(finalRequest)
            }

            let processedResponse = try await applyResponseInterceptors(
                response,
                request: request,
                endpoint: endpoint
            )

            try responseValidator.validate(
                processedResponse
            )

            let duration = Date().timeIntervalSince(start)

            logger.log(
                ResponseLogEvent(
                    request: request,
                    response: processedResponse,
                    duration: duration
                )
            )

            return processedResponse

        } catch {

            throw errorMapper.map(error)
        }
    }

    /// Executes an endpoint without returning its response.
    ///
    /// This convenience method is intended for endpoints whose success
    /// does not depend on a response body, such as:
    ///
    /// - DELETE requests
    /// - Logout endpoints
    /// - HTTP `204 No Content` responses
    ///
    /// Internally, this method delegates to ``execute(_:)`` and discards
    /// the returned response.
    ///
    /// - Parameter endpoint: The endpoint to execute.
    ///
    /// - Throws: A mapped `NetworkError` if request execution fails.
    func executeWithoutResponse(
        _ endpoint: any Endpoint
    ) async throws {

        _ = try await execute(endpoint)
    }
}
