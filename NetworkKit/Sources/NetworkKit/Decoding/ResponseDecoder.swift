//
//  ResponseDecoder.swift
//  NetworkKit
//
//  Created by Marwa Attef on 08/07/2026.
//


import Foundation


/// Decodes raw response data into strongly typed models.
///
/// `ResponseDecoder` abstracts the serialization mechanism used by
/// `NetworkClient`, allowing different decoding strategies to be
/// plugged in without changing the networking layer.
///
/// Typical implementations include:
///
/// - `JSONResponseDecoder`
/// - `XMLResponseDecoder`
/// - `PropertyListResponseDecoder`
///
/// Custom implementations may support any serialization format.
public protocol ResponseDecoder: Sendable {

    /// Decodes raw data into the requested type.
    ///
    /// - Parameters:
    ///   - type: The expected model type.
    ///   - data: Raw response data.
    ///
    /// - Returns: The decoded model.
    ///
    /// - Throws: An error if decoding fails.
    func decode<T: Decodable>(
        _ type: T.Type,
        from data: Data
    ) throws -> T
}
