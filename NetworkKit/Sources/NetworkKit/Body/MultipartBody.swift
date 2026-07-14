//
//  MultipartBody.swift
//  NetworkKit
//
//  Created by Marwa Attef on 08/07/2026.
//

import Foundation


/// Represents a multipart/form-data request body.
///
/// Multipart encoding is delegated to the underlying
/// transport implementation.
///
/// This keeps `NetworkKit` transport-agnostic while allowing
/// each HTTP engine to build multipart requests using
/// its preferred implementation.
///
/// Examples:
///
/// - Alamofire uses `MultipartFormData`.
/// - URLSession builds the multipart payload manually.
public struct MultipartBody: RequestBody {

    /// Multipart payload description.
    public let request: MultipartRequest
    /// Creates a multipart request body.
    ///
    /// - Parameter request:
    ///   Multipart payload.
    public init(_ request: MultipartRequest) {
        self.request = request
    }

    public var contentType: String? {
        "multipart/form-data"
    }

    /// Intentionally does nothing.
    ///
    /// Multipart encoding is handled by the transport layer.
    public func apply(to request: inout URLRequest) throws {
        // Intentionally left empty.
        //
        // Multipart encoding is transport-specific.
        // Alamofire will build MultipartFormData.
        // URLSession implementation can build the body manually.
    }
}
