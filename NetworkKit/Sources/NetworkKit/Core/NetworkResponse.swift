//
//  NetworkResponse.swift
//  NetworkKit
//
//  Created by Marwa Attef on 08/07/2026.
//

import Foundation

/// Represents a successful HTTP response.
///
/// A `NetworkResponse` contains the raw response body
/// together with the associated `HTTPURLResponse`.
public struct NetworkResponse: Sendable {


    /// Raw response data
    public let data: Data?


    /// HTTP response metadata.
    public let response: HTTPURLResponse



    public init(
        data: Data?,
        response: HTTPURLResponse
    ) {

        self.data = data
        self.response = response
    }



    // MARK: - Helpers

    /// Convenience access to the HTTP status code.
    public var statusCode: Int {

        response.statusCode
    }

    /// HTTP response headers.
    public var headers: [AnyHashable: Any] {

        response.allHeaderFields
    }
}
