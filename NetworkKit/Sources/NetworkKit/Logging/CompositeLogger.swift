//
//  CompositeLogger.swift
//  NetworkKit
//
//  Created by Marwa Attef on 08/07/2026.
//

import Foundation

/// A logger that forwards log events to multiple loggers.
///
/// `CompositeLogger` implements the Composite design pattern, allowing
/// multiple `NetworkLogger` implementations to be treated as a single logger.
///
/// This is useful when log events need to be sent to multiple destinations,
/// such as the Xcode console, a file, and a remote logging service,
/// without requiring the networking layer to know about each destination.
///
/// All registered loggers receive every log event.
///
/// Example:
///
/// ```swift
/// let logger = CompositeLogger([
///     ConsoleLogger(),
///     FileLogger(),
///     AnalyticsLogger()
/// ])
/// ```
public struct CompositeLogger: NetworkLogger {
    /// The collection of loggers that receive forwarded log events.

    private let loggers: [any NetworkLogger]

    /// The minimum log level supported by the composite logger.
    ///
    /// Since filtering is delegated to each child logger,
    /// the composite logger always accepts every event.
    public let minimumLevel: LoggerLevel = .verbose

    /// Creates a composite logger.
    ///
    /// - Parameter loggers: The collection of loggers that should receive
    ///   forwarded log events.
    public init(
        _ loggers: [any NetworkLogger]
    ) {
        self.loggers = loggers
    }

    /// Forwards a log event to all registered loggers.
    ///
    /// Each logger is responsible for deciding whether to process
    /// or ignore the event based on its own logging configuration.
    ///
    /// - Parameter event: The network event to log.
    public func log(
        _ event: any NetworkLogEvent
    ) {

        for logger in loggers {
            logger.log(event)
        }
    }
}
