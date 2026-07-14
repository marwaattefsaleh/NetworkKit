//
//  NetworkClient.swift
//  NetworkKit
//
//  Created by Marwa Attef on 08/07/2026.
import Foundation

/// Coordinates the execution of network requests.
///
/// `NetworkClient` serves as the central entry point of the networking
/// layer. It composes the various networking components responsible for
/// building requests, executing them, handling retries, validating
/// responses, decoding models, logging network activity, and mapping
/// errors.
///
/// Rather than implementing networking behavior directly, the client
/// delegates responsibilities to specialized components, promoting
/// modularity and testability.
public final class NetworkClient: Sendable {

    // MARK: - Dependencies

    /// Builds `URLRequest` instances from endpoints.
    let builder: URLRequestBuilder

    /// Executes HTTP requests.
    let httpClient: any HTTPClient

    /// Coordinates retry behavior for failed requests.
    let retryExecutor: RetryExecutor

    /// Records network activity.
    let logger: any NetworkLogger

    /// Decodes response data into application models.
    let decoder: any ResponseDecoder

    /// Validates HTTP responses before decoding.
    let responseValidator: any ResponseValidator

    /// Maps underlying errors into `NetworkError`.
    let errorMapper: any ErrorMapper

    /// Interceptors executed before sending requests.
    let requestInterceptors: [any RequestInterceptor]

    /// Interceptors executed after receiving responses.
    let responseInterceptors: [any ResponseInterceptor]

    // MARK: - Initialization

    /// Creates a network client using the provided configuration.
    ///
    /// The supplied configuration determines the behavior of the client,
    /// including request building, retry policy, response validation,
    /// decoding, logging, interceptors, and error mapping.
    ///
    /// - Parameters:
    ///   - configuration: The networking configuration.
    ///   - httpClient: The transport implementation responsible for
    ///     executing HTTP requests.
    public init(
        configuration: NetworkConfiguration,
        httpClient: any HTTPClient
    ) {

        self.builder = URLRequestBuilder(
            environment: configuration.environment,
            timeoutInterval: configuration.timeoutInterval
        )

        self.httpClient = httpClient

        self.retryExecutor = RetryExecutor(
            policy: configuration.retryPolicy,
            credentialRefresher: configuration.credentialRefresher
        )

        self.logger = configuration.logger
        self.decoder = configuration.decoder
        self.responseValidator = configuration.responseValidator
        self.errorMapper = configuration.errorMapper

        self.requestInterceptors = configuration.requestInterceptors
        self.responseInterceptors = configuration.responseInterceptors
    }
}
