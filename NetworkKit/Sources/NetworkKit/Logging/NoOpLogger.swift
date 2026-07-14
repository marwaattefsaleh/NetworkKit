//
//  NoOpLogger.swift
//  NetworkKit
//
//  Created by Marwa Attef on 08/07/2026.
//
import Foundation

/// A logger that ignores all network log events.
///
/// `NoOpLogger` provides a no-operation implementation of
/// ``NetworkLogger``. It silently discards every log event without
/// performing any processing or output.
///
/// This logger is useful when logging is intentionally disabled,
/// such as in production builds, unit tests, or performance-sensitive
/// environments.
///
/// Since `NoOpLogger` performs no work, it introduces virtually
/// no runtime overhead.
public struct NoOpLogger: NetworkLogger {

    /// The minimum log level supported by this logger.
    ///
    /// This value is always `.none`, indicating that logging
    /// is effectively disabled.
    public let minimumLevel: LoggerLevel = .none

    /// Creates a logger that ignores all network log events.
    public init() {}

    /// Ignores the provided network log event.
    ///
    /// This method intentionally performs no operation.
    ///
    /// - Parameter event: The network event to ignore.
    public func log(
        _ event: any NetworkLogEvent
    ) {}
}
