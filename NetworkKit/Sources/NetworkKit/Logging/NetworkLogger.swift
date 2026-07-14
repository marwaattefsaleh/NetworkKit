//
//  NetworkLogger.swift
//  NetworkKit
//
//  Created by Marwa Attef on 08/07/2026.
//


import Foundation
/// A type responsible for handling network log events.
///
/// `NetworkLogger` defines the interface for logging requests,
/// responses, and errors produced by the networking layer.
///
/// Implementations may write logs to different destinations,
/// such as:
///
/// - The Xcode console
/// - A local file
/// - A remote logging service
/// - Analytics platforms
///
/// Logging behavior can be controlled using the logger's
/// ``minimumLevel``.
public protocol NetworkLogger: Sendable {
    /// The minimum log level that should be recorded.
      ///
      /// Events whose level is less important than this value
      /// should be ignored.
    var minimumLevel: LoggerLevel { get }
    /// Logs a network event.
    ///
    /// - Parameter event: The event to log.
    func log(
        _ event: any NetworkLogEvent
    )
}
