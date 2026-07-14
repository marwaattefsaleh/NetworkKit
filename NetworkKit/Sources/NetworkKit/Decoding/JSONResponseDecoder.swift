//
//  JSONResponseDecoder.swift
//  NetworkKit
//
//  Created by Marwa Attef on 08/07/2026.
//

import Foundation


/// A `ResponseDecoder` implementation that decodes JSON responses
/// using `JSONDecoder`.
///
/// This is the default decoder used by `NetworkClient`.
public struct JSONResponseDecoder:
    ResponseDecoder {

    /// The underlying Foundation JSON decoder.

    private let decoder: JSONDecoder


    /// Creates a JSON decoder.
    ///
    /// - Parameter decoder:
    ///   The underlying `JSONDecoder`.
    ///
    /// Supplying your own decoder allows customization of:
    ///
    /// - Date decoding strategy
    /// - Key decoding strategy
    /// - Data decoding strategy
    /// - Non-conforming float decoding
    public init(
        decoder: JSONDecoder = JSONDecoder()
    ) {

        self.decoder = decoder
    }


    /// Decodes JSON data into the requested type.
    ///
    /// - Parameters:
    ///   - type: Expected model type.
    ///   - data: JSON payload.
    ///
    /// - Returns: A decoded model.
    ///
    /// - Throws: `DecodingError` if decoding fails.
    public func decode<T: Decodable>(
        _ type: T.Type,
        from data: Data
    ) throws -> T {


        try decoder.decode(
            type,
            from: data
        )
    }
}
