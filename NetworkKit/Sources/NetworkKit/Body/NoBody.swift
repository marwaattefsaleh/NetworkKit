//
//  NoBody.swift
//  NetworkKit
//
//  Created by Marwa Attef on 08/07/2026.
//

import Foundation

/// Represents the absence of an HTTP request body.
///
/// Use `NoBody` when an endpoint should not include
/// an `httpBody`, such as most GET requests.
public struct NoBody: RequestBody {

    /// Creates an empty body representation.
    public init() {}

    public var contentType: String? {
        nil
    }

    public func apply(
        to request: inout URLRequest
    ) throws {
        request.httpBody = nil
    }
}
