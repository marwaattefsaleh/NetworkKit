//
//  EmptyResponse.swift
//  NetworkKit
//
//  Created by Marwa Attef on 08/07/2026.
//
import Foundation

/// Represents an empty response body.
///
/// `EmptyResponse` is used when an endpoint returns no response content,
/// but the request is still considered successful.
///
/// Typical examples include:
///
/// - HTTP `204 No Content`
/// - DELETE operations
/// - Endpoints that acknowledge a request without returning data
///
/// Example:
///
/// ```swift
/// let _: EmptyResponse = try await client.execute(endpoint)
/// ```
public struct EmptyResponse: Decodable, Sendable {

    /// Creates an empty response.
    public init() {}
}
