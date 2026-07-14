//
//  CurlFormatter.swift
//  NetworkKit
//
//  Created by Marwa Attef on 08/07/2026.
//

import Foundation

/// A log formatter that converts network requests into executable
/// cURL commands.
///
/// `CurlFormatter` is useful for debugging and reproducing network
/// requests outside the application. The generated command can be
/// copied directly into a terminal or imported into tools such as
/// Postman for testing.
///
/// Only request events are formatted. Response and error events
/// return an empty string.
///
/// Example output:
///
/// ```text
/// curl -X POST \
/// -H 'Content-Type: application/json' \
/// -H 'Authorization: Bearer <token>' \
/// -d '{"email":"john@example.com"}' \
/// 'https://api.example.com/login'
/// ```
public struct CurlFormatter: LogFormatter {

    /// Creates a formatter that generates cURL commands.
    public init() {}

    /// Formats a request event as an executable cURL command.
    ///
    /// The generated command includes the HTTP method, request headers,
    /// request body (when available), and request URL.
    ///
    /// - Parameter event: The request event to format.
    ///
    /// - Returns: A cURL command representing the request, or an empty
    ///   string if the request URL is unavailable.
    public func visit(
        _ event: RequestLogEvent
    ) -> String {

        guard let url = event.request.url else {
            return ""
        }

        var components: [String] = [
            "curl"
        ]

        if let method = event.request.httpMethod {
            components.append("-X \(method)")
        }

        event.request.allHTTPHeaderFields?
            .forEach { key, value in
                components.append(
                    "-H '\(key): \(value)'"
                )
            }

        if let body = event.request.httpBody,
           let bodyString = String(
                data: body,
                encoding: .utf8
           ) {

            components.append(
                "-d '\(bodyString)'"
            )
        }

        components.append(
            "'\(url.absoluteString)'"
        )

        return components.joined(separator: " ")
    }

    /// Formats a response event.
    ///
    /// `CurlFormatter` does not format response events.
    ///
    /// - Parameter event: The response event.
    ///
    /// - Returns: An empty string.
    public func visit(
        _ event: ResponseLogEvent
    ) -> String {

        ""
    }

    /// Formats an error event.
    ///
    /// `CurlFormatter` does not format error events.
    ///
    /// - Parameter event: The error event.
    ///
    /// - Returns: An empty string.
    public func visit(
        _ event: ErrorLogEvent
    ) -> String {

        ""
    }
}
