//
//  NetworkLogEvent.swift
//  NetworkKit
//
//  Created by Marwa Attef on 08/07/2026.
//

import Foundation

/// Represents a network event that can be logged.
///
/// `NetworkLogEvent` is the base protocol for all events emitted by the
/// networking layer. Each event contains common metadata, such as its
/// severity level and timestamp, and supports the Visitor pattern for
/// formatting or processing.
///
/// Conforming types include:
///
/// - ``RequestLogEvent``
/// - ``ResponseLogEvent``
/// - ``ErrorLogEvent``
///
/// Instead of exposing formatting logic, each event delegates that
/// responsibility to a ``NetworkLogEventVisitor`` by implementing
/// ``accept(_:)``.
public protocol NetworkLogEvent: Sendable {

    /// The severity level of the log event.
    ///
    /// Loggers can use this value to determine whether the event
    /// should be processed or ignored.
    var level: LoggerLevel { get }

    /// The date and time when the event occurred.
    var date: Date { get }

    /// Accepts a visitor to process this log event.
    ///
    /// This method is part of the Visitor pattern, allowing different
    /// implementations to perform operations on the event—such as
    /// formatting it for console output or generating a cURL command—
    /// without coupling those behaviors to the event itself.
    ///
    /// - Parameter visitor: The visitor responsible for processing the event.
    ///
    /// - Returns: The value produced by the visitor.
    func accept<V: NetworkLogEventVisitor>(
        _ visitor: V
    ) -> V.Result
}
