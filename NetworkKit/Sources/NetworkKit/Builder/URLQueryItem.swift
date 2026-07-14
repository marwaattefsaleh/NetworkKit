//
//  URLQueryItem.swift
//  NetworkKit
//
//  Created by Marwa Attef on 08/07/2026.
//

import Foundation

public extension URLQueryItem {

    static func item(
        _ name: String,
        _ value: CustomStringConvertible?
    ) -> URLQueryItem {
        URLQueryItem(
            name: name,
            value: value?.description
        )
    }
}
