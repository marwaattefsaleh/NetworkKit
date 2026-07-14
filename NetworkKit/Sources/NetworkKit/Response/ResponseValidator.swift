//
//  ResponseValidator.swift
//  NetworkKit
//
//  Created by Marwa Attef on 08/07/2026.
//
import Foundation

/// Validates network responses before they are decoded.
///
/// `ResponseValidator` determines whether a received response should be
/// considered successful or treated as an error.
///
/// Separating validation from the networking engine allows applications
/// to customize how HTTP status codes are interpreted without modifying
/// the request execution pipeline.
///
/// Typical implementations include:
///
/// - ``DefaultResponseValidator``
/// - Custom validators for application-specific APIs
public protocol ResponseValidator: Sendable {

    /// Validates a network response.
    ///
    /// - Parameter response: The response to validate.
    ///
    /// - Throws: An error if the response should be treated as a failure.
    func validate(
        _ response: NetworkResponse
    ) throws
}
