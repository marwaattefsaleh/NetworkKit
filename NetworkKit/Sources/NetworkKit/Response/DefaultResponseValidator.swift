//
//  DefaultResponseValidator.swift
//  NetworkKit
//
//  Created by Marwa Attef on 08/07/2026.
//
import Foundation

/// The default implementation of ``ResponseValidator``.
///
/// `DefaultResponseValidator` validates HTTP responses based on their
/// status codes and maps unsuccessful responses to the appropriate
/// ``NetworkError``.
///
/// The validator considers any status code in the `2xx` range successful.
/// All other status codes result in a corresponding networking error.
///
/// Default mappings include:
///
/// - `401` → ``NetworkError/unauthorized``
/// - `403` → ``NetworkError/forbidden``
/// - `404` → ``NetworkError/notFound``
/// - `429` → ``NetworkError/tooManyRequests``
/// - `5xx` → ``NetworkError/serverError(statusCode:)``
/// - Any other non-success status → ``NetworkError/httpError(statusCode:)``
public struct DefaultResponseValidator: ResponseValidator {

    /// Creates the default response validator.
    public init() {}

    /// Validates a network response.
    ///
    /// Successful responses (`200...299`) complete without error.
    /// All other status codes are mapped to an appropriate
    /// ``NetworkError``.
    ///
    /// - Parameter response: The response to validate.
    ///
    /// - Throws: A ``NetworkError`` if the response indicates a failure.
    public func validate(
        _ response: NetworkResponse
    ) throws {

        switch response.statusCode {

        case 200...299:
            return

        case 401:
            throw NetworkError.unauthorized

        case 403:
            throw NetworkError.forbidden

        case 404:
            throw NetworkError.notFound

        case 429:
            throw NetworkError.tooManyRequests

        case 500...599:
            throw NetworkError.serverError(
                statusCode: response.statusCode
            )

        default:
            throw NetworkError.httpError(
                statusCode: response.statusCode
            )
        }
    }
}
