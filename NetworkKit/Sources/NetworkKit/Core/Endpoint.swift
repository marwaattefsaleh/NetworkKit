//
//  Endpoint.swift
//  NetworkKit
//
//  Created by Marwa Attef on 08/07/2026.
//
import Foundation
/// Describes an HTTP endpoint.
///
/// An endpoint contains all information required to build
/// a `URLRequest`.
///
/// It is intentionally transport-independent and contains no
/// knowledge of request execution.
///
/// Responsibilities include:
///
/// - Request path
/// - HTTP method
/// - Headers
/// - Query parameters
/// - Request body
/// - Authentication requirement
/// - Optional timeout
public protocol Endpoint: Sendable {
    /// Relative path appended to the environment's base URL.
    ///
    /// Example:
    ///
    /// "users/123"
    var path: String { get }
    /// HTTP method used by the request.
    var method: HTTPMethod { get }
    /// Headers applied only to this endpoint.
    ///
    /// Endpoint headers override environment headers.
    var headers: HTTPHeaders { get }

    var queryItems: [URLQueryItem]? { get }

    var body: any RequestBody { get }

    var requiresAuthentication: Bool { get }

    var timeout: TimeInterval? { get }
    
}

public extension Endpoint {

    var headers: HTTPHeaders {
        .json
    }

    var queryItems: [URLQueryItem]? {
        nil
    }

    var body: any RequestBody {
        NoBody()
    }

    var requiresAuthentication: Bool {
        true
    }

    var timeout: TimeInterval? {
        nil
    }
}
