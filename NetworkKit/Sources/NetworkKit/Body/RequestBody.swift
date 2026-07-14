//
//  HTTPBody.swift
//  NetworkKit
//
//  Created by Marwa Attef on 08/07/2026.
//
//
//  RequestBody.swift
//  NetworkKit
//

import Foundation

/// Represents the body of an HTTP request.
///
/// Types conforming to `RequestBody` are responsible for applying
/// their encoded representation to a `URLRequest`.
///
/// This protocol decouples request body encoding from the networking
/// layer, allowing new body formats to be added without modifying
/// existing infrastructure.
///
/// Built-in implementations include:
///
/// - ``NoBody``
/// - ``EmptyBody``
/// - ``JSONBody``
/// - ``FormURLEncodedBody``
/// - ``RawBody``
/// - ``MultipartBody``
public protocol RequestBody: Sendable {

    /// The value of the `Content-Type` header.
    ///
    /// Return `nil` when no content type should be added.
    var contentType: String? { get }

    /// Applies the encoded body to the supplied request.
    ///
    /// - Parameter request: The request to modify.
    /// - Throws: An error if body encoding fails.
    func apply(
        to request: inout URLRequest
    ) throws
}
