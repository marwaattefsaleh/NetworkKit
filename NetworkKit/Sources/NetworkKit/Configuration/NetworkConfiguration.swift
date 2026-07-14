//
//  NetworkConfiguration.swift
//  NetworkKit
//
//  Created by Marwa Attef on 08/07/2026.
//
//
//  NetworkConfiguration.swift
//  NetworkKit
//

import Foundation

/// Defines the behavior of a `NetworkClient`.
///
/// A configuration groups together all dependencies required
/// to execute network requests, including retry behavior,
/// logging, decoding, response validation, authentication,
/// and request interceptors.
///
/// Different configurations can be used for development,
/// testing, staging, or production environments.
public struct NetworkConfiguration: Sendable {


    // MARK: - Base
    /// Network environment used to build requests.
    public let environment: NetworkEnvironment

    /// Default timeout applied to all requests.
    public let timeoutInterval: TimeInterval


    // MARK: - Retry
    /// Determines whether failed requests should be retried.
    public let retryPolicy: any RetryPolicy


    // MARK: - Logging
    /// Receives request and response log events.
    public let logger: any NetworkLogger


    // MARK: - Interceptors
    /// Interceptors executed before a request is sent.
    public let requestInterceptors:
        [any RequestInterceptor]

    /// Interceptors executed after a response is received.
    public let responseInterceptors:
        [any ResponseInterceptor]
    /// Decodes successful response bodies.
    public let decoder: any ResponseDecoder
    /// Validates HTTP responses before decoding.
    public let responseValidator:
        any ResponseValidator
    /// Refreshes expired authentication credentials when required.
    public let credentialRefresher: (any CredentialRefresher)?
    /// Converts transport and system errors into `NetworkError`.
    public let errorMapper: any ErrorMapper
    public init(
        environment: NetworkEnvironment,
        timeoutInterval: TimeInterval = 30,
        retryPolicy: any RetryPolicy = ExponentialBackoffRetry(),
        logger: any NetworkLogger = NoOpLogger(),
        decoder: any ResponseDecoder = JSONResponseDecoder(),
        responseValidator: any ResponseValidator = DefaultResponseValidator(),
        requestInterceptors: [any RequestInterceptor] = [],
        responseInterceptors: [any ResponseInterceptor] = [],
        credentialRefresher: (any CredentialRefresher)? = nil,
        errorMapper: any ErrorMapper = DefaultErrorMapper(),

    ) {

        self.environment = environment
        self.timeoutInterval = timeoutInterval
        self.retryPolicy = retryPolicy
        self.logger = logger
        self.decoder = decoder
        self.requestInterceptors = requestInterceptors
        self.responseInterceptors = responseInterceptors
        self.responseValidator = responseValidator
        self.credentialRefresher = credentialRefresher
        self.errorMapper = errorMapper

    }
}
