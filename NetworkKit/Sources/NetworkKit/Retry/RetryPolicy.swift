//
//  RetryPolicy.swift
//  NetworkKit
//
//  Created by Marwa Attef on 08/07/2026.
//

import Foundation

/// Defines the strategy for retrying failed network requests.
///
/// `RetryPolicy` determines whether a failed network operation should
/// be retried based on the original request, received response,
/// encountered error, and the current retry attempt.
///
/// By separating retry logic from the networking engine, different
/// retry strategies can be implemented without modifying request
/// execution.
///
/// Typical implementations include:
///
/// - ``ExponentialBackoffRetry``
/// - Immediate retry policies
/// - Fixed-delay retry policies
/// - Custom application-specific retry policies
public protocol RetryPolicy: Sendable {

    /// The maximum number of retry attempts supported by the policy.
    ///
    /// Implementations should return the maximum number of retries
    /// they are willing to perform before giving up.
    var maxRetries: Int { get }

    /// Determines whether a failed request should be retried.
    ///
    /// The decision may consider factors such as:
    ///
    /// - The HTTP status code.
    /// - The underlying network error.
    /// - The request being executed.
    /// - The current retry attempt.
    ///
    /// - Parameters:
    ///   - request: The original request.
    ///   - response: The received response, if available.
    ///   - error: The encountered error, if any.
    ///   - retryCount: The number of retry attempts already performed.
    ///
    /// - Returns: A ``RetryDecision`` describing how the networking
    ///   layer should proceed.
    func shouldRetry(
        request: URLRequest,
        response: NetworkResponse?,
        error: Error?,
        retryCount: Int
    ) async -> RetryDecision
}
