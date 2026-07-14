//
//  JSONBody.swift
//  NetworkKit
//
//  Created by Marwa Attef on 08/07/2026.
//

import Foundation
/// Represents a JSON-encoded request body.
///
/// The supplied value is encoded using a `JSONEncoder`.
///
/// Example:
///
/// ```swift
/// let body = JSONBody(CreateUserRequest(...))
/// ```
public struct JSONBody<Value>: RequestBody
where Value: Encodable & Sendable {

    /// The value to encode as JSON.
    private let value: Value
    /// The encoder used to serialize the value.
    private let encoder: JSONEncoder
    /// Creates a JSON request body.
    ///
    /// - Parameters:
    ///   - value: The value to encode.
    ///   - encoder: The encoder used for serialization.
    public init(
        _ value: Value,
        encoder: JSONEncoder = .init()
    ) {
        self.value = value
        self.encoder = encoder
    }
    /// The JSON content type.
    public var contentType: String? {
        "application/json"
    }
    /// Encodes the value and assigns it to the request body.
    ///
    /// - Throws: An error if encoding fails.
    public func apply(to request: inout URLRequest) throws {
        request.httpBody = try encoder.encode(value)
    }
}
