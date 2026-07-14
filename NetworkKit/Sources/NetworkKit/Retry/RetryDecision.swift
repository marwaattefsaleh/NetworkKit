//
//  RetryDecision.swift
//  NetworkKit
//
//  Created by Marwa Attef on 08/07/2026.
//

import Foundation

/// Represents the outcome of evaluating whether a failed request
/// should be retried.
///
/// `RetryDecision` is returned by a ``RetryPolicy`` after inspecting
/// the request, response, error, and retry count. It instructs the
/// networking layer how to proceed following a failed request.
///
/// Possible outcomes include:
///
/// - Retry immediately.
/// - Retry after a delay.
/// - Refresh authentication credentials before retrying.
/// - Stop retrying and propagate the failure.
public enum RetryDecision: Sendable {

    /// Retry the request immediately.
    ///
    /// Use this case when the failure is considered transient and
    /// no delay is required before the next attempt.
    case retry

    /// Retry the request after waiting for a specified delay.
    ///
    /// This is commonly used with exponential backoff strategies
    /// to reduce server load and avoid overwhelming network resources.
    ///
    /// - Parameter TimeInterval: The delay, in seconds, before retrying.
    case retryAfter(TimeInterval)

    /// Refresh authentication credentials before retrying.
    ///
    /// This decision indicates that the current credentials are no
    /// longer valid and should be refreshed before attempting the
    /// request again.
    case refreshCredentials

    /// Do not retry the request.
    ///
    /// This indicates that the failure is not recoverable or that
    /// the maximum number of retry attempts has been reached.
    case doNotRetry
}
