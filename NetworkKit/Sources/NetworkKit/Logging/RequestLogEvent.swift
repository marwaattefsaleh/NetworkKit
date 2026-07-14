//
//  RequestLogEvent.swift
//  NetworkKit
//
//  Created by Marwa Attef on 08/07/2026.
//

import Foundation

/// A log event representing an outgoing network request.
///
/// `RequestLogEvent` captures the details of a request before it is
/// executed by the networking layer. It contains the original
/// `URLRequest` along with metadata such as the logging level and
/// timestamp.
///
/// This event is typically emitted immediately before the request is
/// sent and can be formatted by any type conforming to
/// ``NetworkLogEventVisitor``.
public struct RequestLogEvent: NetworkLogEvent {

    /// The severity level of the log event.
    public let level: LoggerLevel

    /// The date and time when the request event occurred.
    public let date: Date

    /// The request being logged.
    public let request: URLRequest

    /// Creates a new request log event.
    ///
    /// - Parameters:
    ///   - request: The outgoing request.
    ///   - level: The severity level of the log event.
    ///     Defaults to `.debug`.
    ///   - date: The timestamp of the event.
    ///     Defaults to the current date and time.
    public init(
        request: URLRequest,
        level: LoggerLevel = .debug,
        date: Date = .init()
    ) {
        self.request = request
        self.level = level
        self.date = date
    }

    /// Accepts a visitor to process this log event.
    ///
    /// This method is part of the Visitor pattern, allowing different
    /// formatter implementations to generate custom representations of
    /// the request without coupling formatting logic to the event itself.
    ///
    /// - Parameter visitor: The visitor responsible for processing the event.
    ///
    /// - Returns: The value produced by the visitor.
    public func accept<V>(
        _ visitor: V
    ) -> V.Result
    where V: NetworkLogEventVisitor {

        visitor.visit(self)
    }
}
