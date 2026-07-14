//
//  EmptyBody.swift
//  NetworkKit
//
//  Created by Marwa Attef on 08/07/2026.
//

import Foundation

/// Represents an explicitly empty HTTP request body.
///
/// Unlike ``NoBody``, this body sets
/// `request.httpBody` to an empty `Data` instance.
///
/// This is useful for APIs that expect
/// `Content-Length: 0`.
public struct EmptyBody: RequestBody {

    /// Creates an explicitly empty body.
    public init() {}

    public var contentType: String? {
        nil
    }

    public func apply(
        to request: inout URLRequest
    ) throws {
        request.httpBody = Data()
    }
}
