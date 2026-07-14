//
//  LogFormatter.swift
//  NetworkKit
//
//  Created by Marwa Attef on 08/07/2026.
//

import Foundation

/// A formatter that converts network log events into human-readable text.
///
/// `LogFormatter` extends ``NetworkLogEventVisitor`` to provide a textual
/// representation of each type of ``NetworkLogEvent``.
///
/// Different formatter implementations can generate different output styles
/// without changing the logging infrastructure. For example, a formatter may
/// produce readable console logs, executable cURL commands, or structured
/// JSON output.
///
/// Typical implementations include:
///
/// - ``PrettyLogFormatter``
/// - ``CurlFormatter``
///
/// Since `LogFormatter` inherits from ``NetworkLogEventVisitor``, each
/// formatter provides a formatting implementation for every supported
/// network log event.
///
/// The visitor's result type is constrained to `String`, making every
/// formatter responsible for returning a textual representation of the event.
public protocol LogFormatter: NetworkLogEventVisitor, Sendable
where Result == String {

}
