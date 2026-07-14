//
//  Token.swift
//  NetworkKit
//
//  Created by Marwa Attef on 08/07/2026.
//

import Foundation

/// Represents authentication credentials used to authorize requests.
///
/// A token typically contains:
///
/// - An access token.
/// - An optional refresh token.
/// - An optional expiration date.
///
/// Tokens are immutable and safe to share across concurrent tasks.
public struct Token: Sendable {

    /// The bearer token sent with authenticated requests.
    public let accessToken: String

    /// Token used to obtain a new access token.
    public let refreshToken: String?

    /// The date when the access token expires.
    ///
    /// A value of `nil` indicates that the token does not expire.
    public let expirationDate: Date?

    public init(
        accessToken: String,
        refreshToken: String? = nil,
        expirationDate: Date? = nil
    ) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.expirationDate = expirationDate
    }
}

// MARK: - Helpers

public extension Token {

    /// Indicates whether the token has expired.
    var isExpired: Bool {

        guard let expirationDate else {
            return false
        }

        return Date() >= expirationDate
    }

   
    /// Indicates whether the token should be refreshed.
    ///
    /// A refresh window is applied before the actual expiration date
    /// to reduce the chance of requests failing while the token expires
    /// in transit.
    ///
    /// - Parameter interval: The refresh window in seconds.
    /// - Returns: `true` if the token should be refreshed.
    func shouldRefresh(
        within interval: TimeInterval = 60
    ) -> Bool {

        guard let expirationDate else {
            return false
        }

        return expirationDate <= Date().addingTimeInterval(interval)
    }
}
