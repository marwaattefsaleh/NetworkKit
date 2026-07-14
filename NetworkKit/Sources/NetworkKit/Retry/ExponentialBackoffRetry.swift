//
//  ExponentialBackoffRetry.swift
//  NetworkKit
//
//  Created by Marwa Attef on 08/07/2026.
//
import Foundation

/// A retry policy that uses an exponential backoff strategy.
///
/// `ExponentialBackoffRetry` retries failed requests by increasing the
/// delay between consecutive retry attempts exponentially.
///
/// This strategy helps reduce server load and network congestion by
/// spacing out retries instead of retrying immediately.
///
/// Retries are performed for:
///
/// - Network connectivity failures
/// - HTTP `429 Too Many Requests`
/// - HTTP `5xx Server Errors`
///
/// The retry delay is calculated using the following formula:
///
/// ```text
/// delay = baseDelay × 2^retryCount
/// ```
///
/// For example, with a `baseDelay` of `0.5` seconds:
///
/// | Retry | Delay |
/// |-------|-------|
/// | 1 | 0.5s |
/// | 2 | 1.0s |
/// | 3 | 2.0s |
///
/// Once the configured maximum number of retries has been reached,
/// no additional retry attempts are made.
public struct ExponentialBackoffRetry: RetryPolicy {

    /// The maximum number of retry attempts.
    public let maxRetries: Int

    /// The initial delay used to calculate exponential backoff.
    private let baseDelay: TimeInterval

    /// Creates an exponential backoff retry policy.
    ///
    /// - Parameters:
    ///   - maxRetries: The maximum number of retry attempts.
    ///     Defaults to `3`.
    ///   - baseDelay: The initial retry delay, in seconds.
    ///     Defaults to `0.5`.
    public init(
        maxRetries: Int = 3,
        baseDelay: TimeInterval = 0.5
    ) {
        self.maxRetries = maxRetries
        self.baseDelay = baseDelay
    }

    /// Determines whether a failed request should be retried.
    ///
    /// Retries are performed when:
    ///
    /// - A network error occurs.
    /// - The server responds with HTTP `429`.
    /// - The server responds with an HTTP `5xx` status code.
    ///
    /// The retry delay increases exponentially after each attempt.
    ///
    /// - Parameters:
    ///   - request: The original request.
    ///   - response: The received response, if available.
    ///   - error: The encountered error, if any.
    ///   - retryCount: The number of retries already attempted.
    ///
    /// - Returns: A ``RetryDecision`` describing whether and when the
    ///   request should be retried.
    public func shouldRetry(
        request: URLRequest,
        response: NetworkResponse?,
        error: Error?,
        retryCount: Int
    ) async -> RetryDecision {

        guard retryCount < maxRetries else {
            return .doNotRetry
        }

        // Network error
        if error != nil {

            return .retryAfter(
                calculateDelay(
                    retryCount: retryCount
                )
            )
        }

        guard let statusCode = response?.statusCode
        else {
            return .doNotRetry
        }

        switch statusCode {

        // Server unavailable
        case 500...599:

            return .retryAfter(
                calculateDelay(
                    retryCount: retryCount
                )
            )

        // Rate limit
        case 429:

            return .retryAfter(
                calculateDelay(
                    retryCount: retryCount
                )
            )

        default:

            return .doNotRetry
        }
    }

    /// Calculates the delay before the next retry attempt.
    ///
    /// The delay is computed using exponential backoff:
    ///
    /// ```text
    /// delay = baseDelay × 2^retryCount
    /// ```
    ///
    /// - Parameter retryCount: The number of retries already attempted.
    ///
    /// - Returns: The delay, in seconds, before the next retry.
    private func calculateDelay(
        retryCount: Int
    ) -> TimeInterval {

        baseDelay * pow(
            2,
            Double(retryCount)
        )
    }
}
