//
//  ResponseLogEvent.swift
//  NetworkKit
//
//  Created by Marwa Attef on 08/07/2026.
//
import Foundation

/// A log event representing a completed network response.
///
/// `ResponseLogEvent` captures the result of a successful network request.
/// It contains the original request, the received response, the elapsed
/// request duration, and metadata such as the logging level and timestamp.
///
/// This event is typically emitted after a response has been received and
/// validated. It can be formatted by any type conforming to
/// ``NetworkLogEventVisitor``.
public struct ResponseLogEvent: NetworkLogEvent {

    /// The severity level of the log event.
    public let level: LoggerLevel

    /// The date and time when the response was received.
    public let date: Date

    /// The original request associated with the response.
    public let request: URLRequest

    /// The response returned by the networking layer.
    public let response: NetworkResponse

    /// The elapsed time, in seconds, required to complete the request.
    public let duration: TimeInterval

    /// Creates a new response log event.
    ///
    /// - Parameters:
    ///   - request: The original request.
    ///   - response: The received network response.
    ///   - duration: The elapsed time, in seconds, between sending the
    ///     request and receiving the response.
    ///   - level: The severity level of the log event.
    ///     Defaults to `.debug`.
    ///   - date: The timestamp of the event.
    ///     Defaults to the current date and time.
    public init(
        request: URLRequest,
        response: NetworkResponse,
        duration: TimeInterval,
        level: LoggerLevel = .debug,
        date: Date = .init()
    ) {

        self.request = request
        self.response = response
        self.duration = duration
        self.level = level
        self.date = date
    }

    /// Accepts a visitor to process this log event.
    ///
    /// This method is part of the Visitor pattern, allowing different
    /// formatter implementations to generate custom representations of
    /// the response without coupling formatting logic to the event itself.
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
