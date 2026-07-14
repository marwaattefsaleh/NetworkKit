//
//  MultipartRequest.swift
//  NetworkKit
//
//  Created by Marwa Attef on 08/07/2026.
//
import Foundation

/// Represents the payload of a multipart/form-data request.
///
/// `MultipartRequest` combines text-based form fields with one or more files,
/// allowing them to be uploaded as a single multipart request.
///
/// A multipart request may contain:
///
/// - Form parameters
/// - Uploaded files
///
/// Example:
///
/// ```swift
/// let request = MultipartRequest(
///     parameters: [
///         "username": "john"
///     ],
///     files: [image]
/// )
/// ```
public struct MultipartRequest: Sendable {

    /// Additional form fields included in the request.
    ///
    /// Each key-value pair is encoded as a separate multipart field.
    public let parameters: [String: String]

    /// The files included in the multipart request.
    public let files: [MultipartFile]

    /// Creates a multipart request.
    ///
    /// - Parameters:
    ///   - parameters: Additional form fields.
    ///   - files: Files to upload.
    public init(
        parameters: [String: String] = [:],
        files: [MultipartFile] = []
    ) {
        self.parameters = parameters
        self.files = files
    }

    /// A Boolean value indicating whether the request contains
    /// one or more files.
    public var hasFiles: Bool {
        !files.isEmpty
    }
}
