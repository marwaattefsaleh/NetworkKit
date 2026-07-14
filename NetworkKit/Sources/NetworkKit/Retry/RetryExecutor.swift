//
//  RetryExecutor.swift
//  NetworkKit
//
//  Created by Marwa Attef on 08/07/2026.
//
import Foundation

/// Executes network operations using a configurable retry policy.
///
/// `RetryExecutor` coordinates the retry process for failed network requests.
/// It repeatedly executes a network operation and delegates retry decisions
/// to a ``RetryPolicy``.
///
/// Depending on the policy's decision, the executor may:
///
/// - Retry immediately.
/// - Retry after a delay.
/// - Refresh authentication credentials before retrying.
/// - Stop retrying and propagate the failure.
///
/// To prevent infinite retry loops, the executor enforces a configurable
/// maximum number of retry attempts.
public final class RetryExecutor: Sendable {

    // MARK: - Properties

    /// The retry policy used to determine whether a request should be retried.
    private let policy: any RetryPolicy

    /// The component responsible for refreshing authentication credentials.
    ///
    /// This refresher is used when the retry policy returns
    /// ``RetryDecision/refreshCredentials``.
    private let credentialRefresher: (any CredentialRefresher)?



    // MARK: - Initialization

    /// Creates a retry executor.
    ///
    /// - Parameters:
    ///   - policy: The retry policy that determines retry behavior.
    ///   - credentialRefresher: An optional credential refresher used when
    ///     authentication credentials need to be renewed.
    ///   - maximumRetryCount: The maximum number of retry attempts before
    ///     failing the operation. Defaults to `10`.
    public init(
        policy: any RetryPolicy,
        credentialRefresher: (any CredentialRefresher)? = nil

    ) {
        self.policy = policy
        self.credentialRefresher = credentialRefresher
    }

    // MARK: - Execute

    /// Executes a network operation using the configured retry policy.
    ///
    /// The operation is repeatedly executed until:
    ///
    /// - It succeeds without requiring another retry.
    /// - The retry policy decides not to retry.
    /// - The maximum retry count is reached.
    /// - Credential refreshing fails.
    ///
    /// - Parameters:
    ///   - request: The original request associated with the operation.
    ///   - operation: The asynchronous network operation to execute.
    ///
    /// - Returns: The successful network response.
    ///
    /// - Throws: The underlying network error, authentication error,
    ///   or ``NetworkError/maximumRetryAttemptsReached`` if the retry
    ///   limit is exceeded.
    public func execute(
        request: URLRequest,
        operation: @escaping @Sendable () async throws -> NetworkResponse
    ) async throws -> NetworkResponse {

        var retryCount = 0

        while true {

            do {

                let response = try await operation()

                let decision = await policy.shouldRetry(
                    request: request,
                    response: response,
                    error: nil,
                    retryCount: retryCount
                )

                guard try await handle(decision) else {
                    return response
                }

                retryCount += 1

            } catch {

                let decision = await policy.shouldRetry(
                    request: request,
                    response: nil,
                    error: error,
                    retryCount: retryCount
                )

                guard try await handle(decision) else {
                    throw error
                }

                retryCount += 1
            }

            guard retryCount < policy.maxRetries else {
                throw NetworkError.maximumRetryAttemptsReached
            }
        }
    }
}

// MARK: - Private

private extension RetryExecutor {

    /// Suspends execution for the specified delay.
    ///
    /// - Parameter delay: The delay, in seconds.
    ///
    /// - Throws: A cancellation error if the current task is cancelled.
    func sleep(
        for delay: TimeInterval
    ) async throws {

        try await Task.sleep(
            nanoseconds: UInt64(delay * 1_000_000_000)
        )
    }

    /// Refreshes authentication credentials.
    ///
    /// - Throws: ``AuthenticationError/credentialRefresherNotConfigured``
    ///   if no credential refresher has been configured, or any error
    ///   thrown by the refresher implementation.
    func refreshCredentials() async throws {

        guard let credentialRefresher else {
            throw AuthenticationError.credentialRefresherNotConfigured
        }

        try await credentialRefresher.refreshCredentials()
    }

    /// Handles the retry decision returned by the retry policy.
    ///
    /// Depending on the decision, this method may retry immediately,
    /// wait before retrying, refresh credentials, or stop retrying.
    ///
    /// - Parameter decision: The retry decision to process.
    ///
    /// - Returns: `true` if another retry should be attempted;
    ///   otherwise `false`.
    ///
    /// - Throws: Any error encountered while delaying or refreshing
    ///   credentials.
    private func handle(
        _ decision: RetryDecision
    ) async throws -> Bool {

        switch decision {

        case .doNotRetry:
            return false

        case .retry:
            return true

        case .retryAfter(let delay):
            try await sleep(for: delay)
            return true

        case .refreshCredentials:
            try await refreshCredentials()
            return true
        }
    }
}
