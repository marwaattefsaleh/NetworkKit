//
//  TokenProvider.swift
//  NetworkKit
//
//  Created by Marwa Attef on 08/07/2026.
//


import Foundation

/// Defines a storage mechanism for authentication tokens.
///
/// Implementations may persist credentials in memory,
/// the Keychain, a database, or any other secure storage.
public protocol TokenProvider: Sendable {

    /// Returns the currently stored token.
    func getToken() async -> Token?

    /// Stores a token.
    ///
    /// - Parameter token: The token to persist.
    func save(
        token: Token
    ) async

    /// Removes any stored token.
    func clear() async
}
