//
//  FormURLEncodedBody.swift
//  NetworkKit
//
//  Created by Marwa Attef on 08/07/2026.
//

import Foundation
/// Represents an
/// `application/x-www-form-urlencoded`
/// request body.
///
/// Parameters are percent encoded and joined using
/// the standard query string format.
///
/// Example:
///
/// ```text
/// username=john&password=123
/// ```
public struct FormURLEncodedBody: RequestBody {
    /// Parameters to encode.
    private let parameters: [String: String]
    /// Creates a form URL encoded body.
    ///
    /// - Parameter parameters:
    ///   Key-value pairs to encode.
    public init(_ parameters: [String: String]) {
        self.parameters = parameters
    }

    public var contentType: String? {
        "application/x-www-form-urlencoded"
    }

    public func apply(to request: inout URLRequest) throws {

        let body = parameters
            .map {
                "\($0.key.percentEncoded)=\($0.value.percentEncoded)"
            }
            .joined(separator: "&")

        request.httpBody = Data(body.utf8)
    }
}

private extension String {

    var percentEncoded: String {
        addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? self
    }
}
