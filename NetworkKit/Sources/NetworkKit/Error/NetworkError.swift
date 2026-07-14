//
//  NetworkError.swift
//  NetworkKit
//
//  Created by Marwa Attef on 08/07/2026.
//

import Foundation

/// Represents all errors that can occur while executing a network request.
///
/// `NetworkError` provides a transport-independent error model used
/// throughout NetworkKit.
///
/// Errors are grouped into:
///
/// - Request construction
/// - HTTP status codes
/// - Network connectivity
/// - Serialization
/// - Authentication
/// - Transport failures
/// - Unknown errors
public enum NetworkError: Error, Sendable {

    // MARK: - Request
    /// The request URL could not be constructed.
    case invalidURL
    /// The request configuration was invalid.
    case invalidRequest

    // MARK: - Response
    /// The received response was not an HTTP response.
    case invalidResponse
    /// A response was expected but no data was returned.
    case emptyResponse

    // MARK: - HTTP
    /// HTTP 401.
    case unauthorized
    /// HTTP 403.
    case forbidden
    /// HTTP 404.
    case notFound
    /// HTTP 429.
    case tooManyRequests
    /// HTTP 5xx.
    case serverError(statusCode: Int)
    /// Any other HTTP error.
    case httpError(statusCode: Int)

    // MARK: - Network

    case timeout
    case noInternetConnection
    case cancelled
    case transport(Error)

    // MARK: - Serialization

    case decoding(Error)
    case encoding(Error)

    // MARK: - Authentication

    case authentication(AuthenticationError)

    // MARK: - Unknown

    case unknown(Error)
    
    case maximumRetryAttemptsReached
}
extension NetworkError: LocalizedError {

    public var errorDescription: String? {

        switch self {

        case .timeout:
            return "The request timed out."

        case .noInternetConnection:
            return "No internet connection."

        case .invalidURL:
            return "invalidURL"
        case .invalidRequest:
            return "invalidRequest"
        case .invalidResponse:
            return "invalidResponse"
        case .emptyResponse:
            return "emptyResponse"
        case .unauthorized:
            return "unauthorized"
        case .tooManyRequests:
            return "tooManyRequests"
        case .notFound:
            return "notFound"
        case .httpError(statusCode: let statusCode):
            return "httpError \(statusCode)"
        case .authentication(_):
            return "authentication"
        case .serverError(statusCode: let statusCode):
            return "serverError \(statusCode)"
        case .cancelled:
            return "cancelled"
        case .transport(_):
            return "transport"
        case .decoding(_):
            return "decoding"
        case .encoding(_):
            return "encoding"
        case .unknown(_):
            return "unknown"
        case .maximumRetryAttemptsReached:
            return "maximumRetryAttemptsReached"
        case .forbidden:
            return "httpforbiddenError"
        }
    }
}
