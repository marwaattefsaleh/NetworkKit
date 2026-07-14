//
//  RawBody.swift
//  NetworkKit
//
//  Created by Marwa Attef on 08/07/2026.
//

import Foundation

/// Represents an arbitrary binary request body.
///
/// Useful when uploading binary payloads such as:
///
/// - Images
/// - PDFs
/// - ZIP archives
/// - Custom binary formats
public struct RawBody: RequestBody {
    /// Raw body data.
    private let data: Data
    /// MIME type describing the payload.
    public let contentType: String?
    /// Creates a raw request body.
    ///
    /// - Parameters:
    ///   - data: Binary payload.
    ///   - contentType: MIME type of the payload.
    public init(
        data: Data,
        contentType: String = "application/octet-stream"
    ) {
        self.data = data
        self.contentType = contentType
    }

    public func apply(to request: inout URLRequest) throws {
        request.httpBody = data
    }
}
