//
//  AuthenticationError.swift
//  NetworkKit
//
//  Created by Marwa Attef on 08/07/2026.
//


import Foundation

/// Errors that can occur during authentication.
///
/// These errors are produced by the authentication layer and may later
/// be wrapped by `NetworkError.authentication` before being returned
/// to consumers of the networking client.
public enum AuthenticationError: Error, Sendable {

    /// No access token is currently available.
    case missingToken

    /// A refresh operation was requested but no refresh token exists.
    case missingRefreshToken

    /// Refreshing the access token failed.
    case refreshFailed

    /// Credential refreshing was requested but no refresher was configured.
    case credentialRefresherNotConfigured}
