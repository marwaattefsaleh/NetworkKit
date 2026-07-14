//
//  MultipartSource.swift
//  NetworkKit
//
//  Created by Marwa Attef on 08/07/2026.
//
import Foundation

/// Represents the source of a multipart file.
///
/// `MultipartSource` identifies where the uploaded file originated.
/// This information can be useful for logging, debugging, or future
/// upload optimizations.
///
/// A multipart file can be created from:
///
/// - In-memory data
/// - A local file URL
public enum MultipartSource: Sendable {

    /// File contents provided directly as binary data.
    ///
    /// Use this case when the file already exists in memory.
    case data(Data)

    /// File contents loaded from a local file URL.
    ///
    /// Use this case when uploading a file stored on disk.
    case fileURL(URL)
}
