//
//  ConsoleLogger.swift
//  NetworkKit
//
//  Created by Marwa Attef on 08/07/2026.
//

import Foundation

/// A logger that writes formatted network events to the console.
///
/// `ConsoleLogger` formats network log events using a `LogFormatter`
/// and prints the resulting output to the standard console.
///
/// Events are filtered based on the configured ``minimumLevel``.
/// Events with a lower priority than the minimum level are ignored.
///
/// The formatter is responsible for converting each event into a
/// human-readable string, allowing different output styles such as
/// pretty-printed logs or cURL commands.
///
/// Example:
///
/// ```swift
/// let logger = ConsoleLogger(
///     minimumLevel: .debug,
///     formatter: PrettyLogFormatter()
/// )
/// ```
public struct ConsoleLogger: NetworkLogger {

    /// The minimum log level that will be printed.
    ///
    /// Events with a lower priority than this level are ignored.
    public let minimumLevel: LoggerLevel

    /// The formatter used to convert log events into printable text.
    private let formatter: any LogFormatter

    /// Creates a console logger.
    ///
    /// - Parameters:
    ///   - minimumLevel: The minimum log level that should be logged.
    ///     Defaults to `.debug`.
    ///   - formatter: The formatter used to generate the console output.
    ///     Defaults to ``PrettyLogFormatter``.
    public init(
        minimumLevel: LoggerLevel = .debug,
        formatter: any LogFormatter = PrettyLogFormatter()
    ) {
        self.minimumLevel = minimumLevel
        self.formatter = formatter
    }

    /// Logs a network event to the console.
    ///
    /// The event is ignored if its log level is lower than the configured
    /// ``minimumLevel``. Otherwise, the event is formatted and printed.
    ///
    /// Empty formatted messages are ignored.
    ///
    /// - Parameter event: The network event to log.
    public func log(
        _ event: any NetworkLogEvent
    ) {

        guard event.level <= minimumLevel else {
            return
        }

        let message = event.accept(formatter)

        guard !message.isEmpty else {
            return
        }

        print(message)
    }
}
