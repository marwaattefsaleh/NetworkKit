//
//  TokenRefresher.swift
//  NetworkKit
//
//  Created by Marwa Attef on 08/07/2026.
//

import Foundation
/// Refreshes an expired access token.
///
/// Implementations are responsible for communicating with
/// the authentication backend and returning updated credentials.
public protocol TokenRefresher: Sendable {
    /// Refreshes the access token.
    ///
    /// - Parameter refreshToken: The refresh token used to request
    ///   a new access token.
    /// - Returns: A newly issued token.
    /// - Throws: An error if refreshing fails.
    func refresh(
        using refreshToken: String
    ) async throws -> Token
}
