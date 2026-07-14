//
//  LocaleInterceptor.swift
//  NetworkKit
//
//  Created by Marwa Attef on 08/07/2026.
//
import Foundation

/// A request interceptor that adds the preferred locale to outgoing requests.
///
/// `LocaleInterceptor` sets the `Accept-Language` HTTP header, allowing
/// servers to localize responses based on the client's preferred language.
///
/// By default, the interceptor uses the current device locale, but a custom
/// locale identifier may also be provided.
///
/// Typical use cases include:
///
/// - Localized API responses
/// - Multi-language applications
/// - Region-specific content delivery
public struct LocaleInterceptor: RequestInterceptor {

    /// The locale identifier sent in the `Accept-Language` header.
    private let locale: String

    /// Creates a locale interceptor.
    ///
    /// - Parameter locale: The locale identifier to include in outgoing
    ///   requests. Defaults to the current device locale.
    public init(locale: String = Locale.current.identifier) {
        self.locale = locale
    }

    /// Adds the `Accept-Language` header to the request.
    ///
    /// If the request already contains an `Accept-Language` header,
    /// its value is replaced with the configured locale.
    ///
    /// - Parameters:
    ///   - request: The request to intercept.
    ///   - endpoint: The endpoint associated with the request.
    ///
    /// - Returns: The modified request containing the locale header.
    ///
    /// - Throws: This implementation does not throw.
    public func intercept(
        _ request: URLRequest,
        endpoint: any Endpoint
    ) async throws -> URLRequest {

        var request = request

        request.setValue(
            locale,
            forHTTPHeaderField: "Accept-Language"
        )

        return request
    }
}
