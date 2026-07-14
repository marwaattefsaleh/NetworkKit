//
//  NetworkLogEventVisitor.swift
//  NetworkKit
//
//  Created by Marwa Attef on 08/07/2026.
//

import Foundation

/// A visitor that processes network log events.
///
/// `NetworkLogEventVisitor` defines operations that can be performed on
/// different types of ``NetworkLogEvent`` without modifying the event
/// types themselves.
///
/// This protocol is the foundation of the Visitor pattern used by the
/// logging system. Each concrete visitor provides a specific behavior
/// for every supported log event, such as formatting events for console
/// output, generating cURL commands, or producing structured log data.
///
/// Typical implementations include:
///
/// - ``PrettyLogFormatter``
/// - ``CurlFormatter``
public protocol NetworkLogEventVisitor {

    /// The type produced after processing a log event.
    associatedtype Result

    /// Processes a request log event.
    ///
    /// - Parameter event: The request event to process.
    ///
    /// - Returns: The value produced by the visitor.
    func visit(
        _ event: RequestLogEvent
    ) -> Result

    /// Processes a response log event.
    ///
    /// - Parameter event: The response event to process.
    ///
    /// - Returns: The value produced by the visitor.
    func visit(
        _ event: ResponseLogEvent
    ) -> Result

    /// Processes an error log event.
    ///
    /// - Parameter event: The error event to process.
    ///
    /// - Returns: The value produced by the visitor.
    func visit(
        _ event: ErrorLogEvent
    ) -> Result
}
