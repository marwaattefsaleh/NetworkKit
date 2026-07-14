//
//  NetworkEnvironment.swift
//  NetworkKit
//
//  Created by Marwa Attef on 08/07/2026.
//

import Foundation

/// Describes a networking environment.
///
/// A network environment defines the base URL and
/// default headers used when constructing requests.
///
/// Typical environments include:
///
/// - Development
/// - Staging
/// - Production
/// - Mock
public struct NetworkEnvironment: Sendable {


    // MARK: - Properties

    /// Identifies the current networking environment.
    public let name: EnvironmentName


    /// Base URL used to construct request URLs.
    public let baseURL: URL


    /// Headers automatically applied to every request
    /// created within this environment.
    public let defaultHeaders: HTTPHeaders



    // MARK: - Initialization


    public init(
        name: EnvironmentName,
        baseURL: URL,
        defaultHeaders: HTTPHeaders = .json
    ) {

        self.name = name
        self.baseURL = baseURL
        self.defaultHeaders = defaultHeaders
    }
}



// MARK: - Environment Name


public enum EnvironmentName: Sendable {

    case development

    case staging

    case production

    case mock

    case custom(String)
}



// MARK: - Factory


public extension NetworkEnvironment {


    static func development(
        _ url: URL,
        headers: HTTPHeaders = .json
    ) -> Self {

        .init(
            name: .development,
            baseURL: url,
            defaultHeaders: headers
        )
    }



    static func staging(
        _ url: URL,
        headers: HTTPHeaders = .json
    ) -> Self {

        .init(
            name: .staging,
            baseURL: url,
            defaultHeaders: headers
        )
    }



    static func production(
        _ url: URL,
        headers: HTTPHeaders = .json
    ) -> Self {

        .init(
            name: .production,
            baseURL: url,
            defaultHeaders: headers
        )
    }



    static func mock(
        _ url: URL,
        headers: HTTPHeaders = .json
    ) -> Self {

        .init(
            name: .mock,
            baseURL: url,
            defaultHeaders: headers
        )
    }



    static func custom(
        name: String,
        url: URL,
        headers: HTTPHeaders = .json
    ) -> Self {

        .init(
            name: .custom(name),
            baseURL: url,
            defaultHeaders: headers
        )
    }
}
