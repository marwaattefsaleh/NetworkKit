//
//  LoggerLevel.swift
//  NetworkKit
//
//  Created by Marwa Attef on 08/07/2026.
//


import Foundation

/// Defines the severity of a network log event.
///
/// `LoggerLevel` is used to control which events are processed by a
/// ``NetworkLogger``. Each log event is assigned a severity level, and
/// loggers can filter events by configuring their ``NetworkLogger/minimumLevel``.
///
/// Levels are ordered from least to most verbose:
///
/// - `none`: Disables logging.
/// - `error`: Logs only errors.
/// - `info`: Logs informational messages and errors.
/// - `debug`: Logs debugging information, informational messages, and errors.
/// - `verbose`: Logs every available network event.
///
/// Since `LoggerLevel` conforms to `Comparable`, loggers can easily
/// determine whether an event should be logged.
///
/// Example:
///
/// ```swift
/// let logger = ConsoleLogger(minimumLevel: .debug)
/// ```
public enum LoggerLevel: Int, Sendable, Comparable {

    /// Disables all logging.
    case none = 0

    /// Logs only error events.
    case error

    /// Logs informational and error events.
    case info

    /// Logs debug, informational, and error events.
    case debug

    /// Logs every available network event.
    case verbose

    /// Compares two logging levels.
    ///
    /// This comparison is based on the raw integer value of each level,
    /// allowing loggers to determine whether an event should be processed.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand logging level.
    ///   - rhs: The right-hand logging level.
    ///
    /// - Returns: `true` if `lhs` has a lower severity than `rhs`;
    ///   otherwise, `false`.
    public static func < (
        lhs: LoggerLevel,
        rhs: LoggerLevel
    ) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}
