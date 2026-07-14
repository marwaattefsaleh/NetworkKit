//
//  HTTPClient.swift
//  NetworkKit
//
//  Created by Marwa Attef on 08/07/2026.
//
import Foundation

/// Defines the interface for executing HTTP requests.
///
/// `HTTPClient` abstracts the underlying networking implementation,
/// allowing requests to be executed without coupling the networking layer
/// to a specific transport mechanism.
///
/// Typical implementations include:
///
/// - `URLSession`-based clients
/// - Alamofire-based clients
/// - Mock clients for testing
/// - Custom networking engines
///
/// Implementations are responsible for:
///
/// - Executing the request.
/// - Receiving the HTTP response.
/// - Returning a ``NetworkResponse``.
/// - Throwing an appropriate error when the request fails.
///
/// By depending on this protocol, higher-level networking components
/// remain independent of the underlying transport implementation.
public protocol HTTPClient: Sendable {

    /// Executes an HTTP request.
    ///
    /// - Parameter request: The request to execute.
    ///
    /// - Returns: The received ``NetworkResponse``.
    ///
    /// - Throws: An error if the request fails to execute.
    func execute(
        _ request: URLRequest
    ) async throws -> NetworkResponse
}
