//
//  AuthenticationInterceptor.swift
//  NetworkKit
//
//  Created by Marwa Attef on 08/07/2026.
//

import Foundation

/// A request interceptor that adds an authentication token to outgoing requests.
///
/// `AuthenticationInterceptor` automatically injects an authorization header
/// for endpoints that require authentication.
///
/// Before sending a request, the interceptor obtains a valid access token
/// from the configured ``AuthenticationManager`` and adds it to the request
/// using the Bearer authentication scheme.
///
/// Endpoints that do not require authentication are passed through unchanged.
public struct AuthenticationInterceptor: RequestInterceptor {

    /// The authentication manager responsible for providing valid access tokens.
    private let authenticationManager: AuthenticationManager

    /// The name of the HTTP header used for authentication.
    ///
    /// Defaults to `"Authorization"`.
    private let headerName: String

    /// Creates an authentication interceptor.
    ///
    /// - Parameters:
    ///   - authenticationManager: The authentication manager used to obtain
    ///     valid access tokens.
    ///   - headerName: The HTTP header used to send the access token.
    ///     Defaults to `"Authorization"`.
    public init(
        authenticationManager: AuthenticationManager,
        headerName: String = "Authorization"
    ) {
        self.authenticationManager = authenticationManager
        self.headerName = headerName
    }

    /// Adds an authorization header to the request when authentication
    /// is required.
    ///
    /// If the endpoint's `requiresAuthentication` property is `true`,
    /// the interceptor retrieves a valid access token and adds it as
    /// a Bearer token.
    ///
    /// Endpoints that do not require authentication are returned
    /// unchanged.
    ///
    /// - Parameters:
    ///   - request: The request to intercept.
    ///   - endpoint: The endpoint associated with the request.
    ///
    /// - Returns: The intercepted request.
    ///
    /// - Throws: Any error thrown while obtaining a valid access token.
    public func intercept(
        _ request: URLRequest,
        endpoint: any Endpoint
    ) async throws -> URLRequest {

        guard endpoint.requiresAuthentication else {
            return request
        }

        let token = try await authenticationManager.validToken()

        var request = request

        request.setValue(
            "Bearer \(token.accessToken)",
            forHTTPHeaderField: headerName
        )

        return request
    }
}
