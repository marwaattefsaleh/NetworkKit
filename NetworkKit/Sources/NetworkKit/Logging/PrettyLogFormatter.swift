//
//  PrettyFormatter.swift
//  NetworkKit
//
//  Created by Marwa Attef on 08/07/2026.
//
import Foundation

/// A log formatter that produces human-readable network logs.
///
/// `PrettyLogFormatter` formats network requests, responses, and errors
/// into a concise, developer-friendly representation suitable for console
/// output during development.
///
/// Unlike ``CurlFormatter``, which generates executable cURL commands,
/// `PrettyLogFormatter` focuses on readability by highlighting the most
/// important information for each network event.
///
/// Example request output:
///
/// ```text
/// 🌐 REQUEST
///
/// GET
/// https://api.example.com/users
/// ```
///
/// Example response output:
///
/// ```text
/// ✅ RESPONSE
///
/// Status:
/// 200
///
/// Duration:
/// 0.34s
/// ```
///
/// Example error output:
///
/// ```text
/// ❌ ERROR
///
/// The Internet connection appears to be offline.
/// ```
public struct PrettyLogFormatter: LogFormatter {

    /// Creates a formatter that generates readable network logs.
    public init() {}

    /// Formats a request log event.
    ///
    /// The generated output includes the HTTP method and request URL.
    ///
    /// - Parameter event: The request event to format.
    ///
    /// - Returns: A human-readable representation of the request.
    public func visit(
        _ event: RequestLogEvent
    ) -> String {

        """
        🌐 REQUEST

        \(event.request.httpMethod ?? "")
        \(event.request.url?.absoluteString ?? "")
        """
    }

    /// Formats a response log event.
    ///
    /// The generated output includes the HTTP status code and the
    /// request duration.
    ///
    /// - Parameter event: The response event to format.
    ///
    /// - Returns: A human-readable representation of the response.
    public func visit(
        _ event: ResponseLogEvent
    ) -> String {

        """
        ✅ RESPONSE

        Status:
        \(event.response.statusCode)

        Duration:
        \(event.duration)s
        """
    }

    /// Formats an error log event.
    ///
    /// The generated output includes the localized description of
    /// the underlying error.
    ///
    /// - Parameter event: The error event to format.
    ///
    /// - Returns: A human-readable representation of the error.
    public func visit(
        _ event: ErrorLogEvent
    ) -> String {

        """
        ❌ ERROR

        \(event.error.localizedDescription)
        """
    }
}
