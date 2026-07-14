//
//  ErrorMapper.swift
//  NetworkKit
//
//  Created by Marwa Attef on 08/07/2026.
//


import Foundation

#if canImport(Alamofire)
import Alamofire
#endif

// MARK: - Protocol
/// Maps arbitrary errors into `NetworkError`.
///
/// Implementations can translate errors originating from:
///
/// - URLSession
/// - Alamofire
/// - Authentication
/// - JSON decoding
/// - Custom networking engines
public protocol ErrorMapper: Sendable {

    func map(
        _ error: Error
    ) -> NetworkError
}

// MARK: - Default Implementation
/// Default implementation of `ErrorMapper`.
///
/// Supports:
///
/// - NetworkError
/// - AuthenticationError
/// - DecodingError
/// /// - EncodingError
/// - URLError
/// - Alamofire AFError
public struct DefaultErrorMapper: ErrorMapper {

    public init() {}

    public func map(
        _ error: Error
    ) -> NetworkError {

        if let networkError = error as? NetworkError {
            return networkError
        }

        if let authenticationError = error as? AuthenticationError {
            return .authentication(authenticationError)
        }

        if let decodingError = error as? DecodingError {
            return .decoding(decodingError)
        }
        if let encoding = error as? EncodingError {
            return .encoding(encoding)
        }
        if let urlError = error as? URLError {
            return map(urlError)
        }

        #if canImport(Alamofire)
        if let afError = error as? AFError {
            return map(afError)
        }
        #endif

        return .unknown(error)
    }
}

// MARK: - Private Helpers

private extension DefaultErrorMapper {

    func map(
        _ error: URLError
    ) -> NetworkError {

        switch error.code {

        case .timedOut:
            return .timeout

        case .notConnectedToInternet:
            return .noInternetConnection

        case .cancelled:
            return .cancelled

        default:
            return .transport(error)
        }
    }

    #if canImport(Alamofire)

    func map(
        _ error: AFError
    ) -> NetworkError {

        if let underlying = error.underlyingError {
            return map(underlying)
        }

        return .transport(error)
    }

    #endif
}
