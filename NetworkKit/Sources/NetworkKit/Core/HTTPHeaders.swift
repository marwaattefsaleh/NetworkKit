//
//  HTTPHeaders.swift
//  NetworkKit
//
//  Created by Marwa Attef on 08/07/2026.
//


import Foundation
/// Represents a collection of HTTP header fields.
///
/// Header names are treated as case-sensitive by this type,
/// although HTTP itself defines header names as case-insensitive.
public struct HTTPHeaders: Sendable, Sequence {
    
    private var storage: [String: String]
    
    public init(_ headers: [String: String] = [:]) {
        self.storage = headers
    }
    
    public func makeIterator()
    -> Dictionary<String, String>.Iterator {
        
        storage.makeIterator()
    }
    
    public subscript(key: String) -> String? {
        get { storage[key] }
        set { storage[key] = newValue }
    }
    
    public mutating func add(name: String, value: String) {
        storage[name] = value
    }
    
    public mutating func remove(name: String) {
        storage.removeValue(forKey: name)
    }
    
    public var dictionary: [String: String] {
        storage
    }
    
    public static let json = HTTPHeaders([
        "Content-Type": "application/json",
        "Accept": "application/json"
    ])
    
    public static let empty = HTTPHeaders()
}
