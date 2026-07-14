//
//  ErrorLogEvent.swift
//  NetworkKit
//
//  Created by Marwa Attef on 08/07/2026.
//

import Foundation

/// A log event representing a failed network operation.
///
/// `ErrorLogEvent` captures information about an error that occurred
/// while performing a network request. Depending on when the failure
/// occurred, the original request and the elapsed duration may or may
/// not be available.
///
/// This event is typically emitted for failures such as:
///
/// - Connectivity issues
/// - Request timeouts
/// - Request validation failures
/// - Response decoding errors
/// - Authentication failures
/// - Server-side errors
///
/// The event can be formatted by any type conforming to
/// ``NetworkLogEventVisitor``.
public struct ErrorLogEvent: NetworkLogEvent {

    /// The severity level of the log event.
    public let level: LoggerLevel

    /// The date and time when the error occurred.
    public let date: Date

    /// The request associated with the error, if available.
    ///
    /// This value may be `nil` if the request could not be created
    /// or the failure occurred before the request was sent.
    public let request: URLRequest?

    /// The error that occurred during the network operation.
    public let error: Error

    /// The elapsed time between sending the request and the failure.
    ///
    /// This value is `nil` when the duration cannot be determined,
    /// such as failures occurring before the request starts.
    public let duration: TimeInterval?

    /// Creates a new error log event.
    ///
    /// - Parameters:
    ///   - request: The request associated with the failure.
    ///   - error: The error that occurred.
    ///   - duration: The elapsed time before the failure occurred.
    ///     Defaults to `nil`.
    ///   - level: The severity level of the log event.
    ///     Defaults to `.error`.
    ///   - date: The timestamp of the event.
    ///     Defaults to the current date and time.
    public init(
        request: URLRequest?,
        error: Error,
        duration: TimeInterval? = nil,
        level: LoggerLevel = .error,
        date: Date = .init()
    ) {

        self.request = request
        self.error = error
        self.duration = duration
        self.level = level
        self.date = date
    }

    /// Accepts a visitor to process this log event.
    ///
    /// This method is part of the Visitor pattern, allowing different
    /// formatter implementations to produce customized representations
    /// of the event without modifying the event type itself.
    ///
    /// - Parameter visitor: The visitor responsible for handling the event.
    ///
    /// - Returns: The value produced by the visitor.
    public func accept<V>(
        _ visitor: V
    ) -> V.Result
    where V: NetworkLogEventVisitor {

        visitor.visit(self)
    }
}
