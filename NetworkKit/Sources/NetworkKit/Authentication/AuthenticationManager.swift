//
//  AuthenticationManager.swift
//  NetworkKit
//
//  Created by Marwa Attef on 08/07/2026.
//

import Foundation
/// Coordinates authentication state and token refresh operations.
///
/// `AuthenticationManager` is responsible for:
///
/// - Providing the current access token.
/// - Refreshing expired credentials.
/// - Persisting newly issued tokens.
/// - Ensuring only one refresh request executes at a time.
///
/// The manager is implemented as an actor to guarantee thread safety
/// across concurrent requests.
public actor AuthenticationManager {

    private let tokenProvider: any TokenProvider
    private let tokenRefresher: any TokenRefresher

    private var refreshTask: Task<Token, Error>?

    public init(
        tokenProvider: any TokenProvider,
        tokenRefresher: any TokenRefresher
    ) {
        self.tokenProvider = tokenProvider
        self.tokenRefresher = tokenRefresher
    }
    /// Returns the currently stored token.
    ///
    /// This method does not validate or refresh the token.
    ///
    /// - Returns: The stored token, or `nil` if no token exists.
    public func currentToken() async -> Token? {
        await tokenProvider.getToken()
    }
    /// Returns a valid access token.
    ///
    /// If the current token is close to expiration,
    /// it is refreshed automatically.
    ///
    /// - Returns: A valid access token.
    /// - Throws: `AuthenticationError` if authentication fails.
    public func validToken() async throws -> Token {

        guard let token = await tokenProvider.getToken() else {
            throw AuthenticationError.missingToken
        }

        guard !token.shouldRefresh() else {
            return try await refresh()
        }

        return token
    }
    /// Forces a credential refresh regardless of expiration.
    ///
    /// - Returns: The newly refreshed token.
    /// - Throws: `AuthenticationError` if the refresh fails.
    public func forceRefresh() async throws -> Token {
        try await refresh()
    }
    /// Performs the token refresh operation.
    ///
    /// If another refresh is already in progress,
    /// the existing refresh task is reused.
    ///
    /// - Returns: The refreshed token.
    /// - Throws: `AuthenticationError` if refreshing fails.
    private func refresh() async throws -> Token {

        if let refreshTask {
            return try await refreshTask.value
        }

        guard
            let currentToken = await tokenProvider.getToken(),
            let refreshToken = currentToken.refreshToken
        else {
            throw AuthenticationError.missingRefreshToken
        }

        let task = Task {
            try await tokenRefresher.refresh(using: refreshToken)
        }

        refreshTask = task

        defer {
            refreshTask = nil
        }

        let newToken = try await task.value

        await tokenProvider.save(token: newToken)

        return newToken
    }
}
extension AuthenticationManager: CredentialRefresher {

    public func refreshCredentials() async throws {
        _ = try await forceRefresh()
    }
}
