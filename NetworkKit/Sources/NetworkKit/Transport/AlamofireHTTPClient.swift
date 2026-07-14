//
//  AlamofireHTTPClient.swift
//  NetworkKit
//
//  Created by Marwa Attef on 08/07/2026.
//
import Foundation
import Alamofire

/// An `HTTPClient` implementation backed by Alamofire.
///
/// `AlamofireHTTPClient` delegates request execution to an Alamofire
/// `Session`, adapting its asynchronous response handling to
/// `async/await`.
///
/// Successful responses are converted into ``NetworkResponse``
/// instances, while transport failures are mapped to
/// ``NetworkError/transport(_:)``.
public final class AlamofireHTTPClient:
    HTTPClient,
    @unchecked Sendable {

    /// The Alamofire session used to execute requests.
    private let session: Session

    /// Creates an HTTP client using the specified Alamofire session.
    ///
    /// - Parameter session: The Alamofire session used to execute
    ///   requests. Defaults to `Session.default`.
    public init(
        session: Session = .default
    ) {

        self.session = session
    }

    /// Executes an HTTP request using Alamofire.
    ///
    /// The request is executed asynchronously and the result is converted
    /// into a ``NetworkResponse``.
    ///
    /// - Parameter request: The request to execute.
    ///
    /// - Returns: The received ``NetworkResponse``.
    ///
    /// - Throws:
    ///   - ``NetworkError/invalidResponse`` if no HTTP response is received.
    ///   - ``NetworkError/transport(_:)`` if the underlying transport
    ///     operation fails.
    public func execute(
        _ request: URLRequest
    ) async throws -> NetworkResponse {

        try await withCheckedThrowingContinuation {
            continuation in

            session
                .request(request)
                .response { response in

                    switch response.result {

                    case .success:

                        guard let httpResponse =
                                response.response
                        else {

                            continuation.resume(
                                throwing:
                                    NetworkError.invalidResponse
                            )

                            return
                        }

                        continuation.resume(
                            returning:
                                NetworkResponse(
                                    data: response.data,
                                    response: httpResponse
                                )
                        )

                    case .failure(let error):

                        continuation.resume(
                            throwing:
                                NetworkError.transport(error)
                        )
                    }
                }
        }
    }
}
