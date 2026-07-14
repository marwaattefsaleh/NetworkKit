//
//  DefaultTokenProvider.swift
//  NetworkKit
//
//  Created by Marwa Attef on 08/07/2026.
//

import Foundation
/// A simple in-memory implementation of ``TokenProvider``.
///
/// This provider stores credentials only for the lifetime of the
/// process and is primarily intended for testing or applications
/// that manage secure persistence elsewhere.
///
/// For production applications, consider implementing a provider
/// backed by the Keychain.
public actor DefaultTokenProvider: TokenProvider {

    private var token: Token?

    /// Creates a token provider.
    ///
    /// - Parameter token: An optional initial token.
    public init(
        token: Token? = nil
    ) {
        self.token = token
    }

    /// Returns the currently stored token.
    public func getToken() async -> Token? {
        token
    }

    /// Persists the supplied token.
    ///
    /// - Parameter token: The token to store.
    public func save(
        token: Token
    ) async {
        self.token = token
    }

    /// Removes the currently stored token.
    public func clear() async {
        token = nil
    }
}
