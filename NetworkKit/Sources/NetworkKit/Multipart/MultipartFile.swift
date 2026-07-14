//
//  MultipartFile.swift
//  NetworkKit
//
//  Created by Marwa Attef on 08/07/2026.
//
import Foundation

/// Represents a file included in a multipart/form-data request.
///
/// `MultipartFile` encapsulates the metadata and content required to upload
/// a single file using the `multipart/form-data` content type.
///
/// Each file includes the form field name, file name, MIME type, and the
/// underlying file source.
///
/// Example:
///
/// ```swift
/// let image = MultipartFile(
///     name: "image",
///     fileName: "avatar.jpg",
///     mimeType: "image/jpeg",
///     data: imageData,
///     source: .data(imageData)
/// )
/// ```
public struct MultipartFile: Sendable {

    /// The name of the multipart form field.
    public let name: String

    /// The name of the uploaded file.
    public let fileName: String

    /// The MIME type describing the file content.
    ///
    /// Example values include:
    ///
    /// - `image/jpeg`
    /// - `image/png`
    /// - `application/pdf`
    /// - `video/mp4`
    public let mimeType: String

    /// The binary contents of the file.
    public let data: Data

    /// The source from which the file data originated.
    public let source: MultipartSource

    /// Creates a multipart file.
    ///
    /// - Parameters:
    ///   - name: The multipart form field name.
    ///   - fileName: The name of the uploaded file.
    ///   - mimeType: The MIME type of the file.
    ///   - data: The binary file contents.
    ///   - source: The source of the file.
    public init(
        name: String,
        fileName: String,
        mimeType: String,
        data: Data,
        source: MultipartSource
    ) {
        self.name = name
        self.fileName = fileName
        self.mimeType = mimeType
        self.data = data
        self.source = source
    }
}
