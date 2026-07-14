//
//  NetworkClient+CRUD.swift
//  NetworkKit
//
//  Created by Marwa Attef on 08/07/2026.
//
import Foundation

/// Provides convenience methods for executing endpoints and decoding
/// their responses into strongly typed models.
///
/// These methods build upon the lower-level request execution pipeline,
/// automatically decoding successful responses using the configured
/// ``ResponseDecoder``.
///
/// All decoding errors are mapped through the configured
/// ``ErrorMapper`` before being propagated to the caller.
public extension NetworkClient {

    /// Executes an endpoint and decodes its response into the specified type.
    ///
    /// This method performs the complete networking pipeline and then
    /// decodes the response body into the requested model type.
    ///
    /// If the requested type is ``EmptyResponse``, decoding is skipped
    /// and an empty response instance is returned.
    ///
    /// - Parameters:
    ///   - endpoint: The endpoint to execute.
    ///   - responseType: The expected response type. Defaults to `T.self`.
    ///
    /// - Returns: The decoded response model.
    ///
    /// - Throws:
    ///   - ``NetworkError/emptyResponse`` if the response body is empty.
    ///   - Any decoding error mapped by the configured ``ErrorMapper``.
    func request<T: Decodable>(
        _ endpoint: any Endpoint,
        responseType: T.Type = T.self
    ) async throws -> T {

        let response = try await execute(endpoint)

        if T.self == EmptyResponse.self {
            return EmptyResponse() as! T
        }

        guard
            let data = response.data,
            !data.isEmpty
        else {
            throw NetworkError.emptyResponse
        }

        do {

            return try decoder.decode(
                T.self,
                from: data
            )

        } catch {

            throw errorMapper.map(error)
        }
    }

    /// Executes a GET endpoint and decodes its response.
    ///
    /// - Parameter endpoint: The endpoint to execute.
    ///
    /// - Returns: The decoded response model.
    ///
    /// - Throws: Any error encountered during request execution or decoding.
    func get<T: Decodable>(
        _ endpoint: any Endpoint
    ) async throws -> T {

        try await request(endpoint)
    }

    /// Executes a POST endpoint and decodes its response.
    ///
    /// - Parameter endpoint: The endpoint to execute.
    ///
    /// - Returns: The decoded response model.
    ///
    /// - Throws: Any error encountered during request execution or decoding.
    func post<T: Decodable>(
        _ endpoint: any Endpoint
    ) async throws -> T {

        try await request(endpoint)
    }

    /// Executes a PUT endpoint and decodes its response.
    ///
    /// - Parameter endpoint: The endpoint to execute.
    ///
    /// - Returns: The decoded response model.
    ///
    /// - Throws: Any error encountered during request execution or decoding.
    func put<T: Decodable>(
        _ endpoint: any Endpoint
    ) async throws -> T {

        try await request(endpoint)
    }

    /// Executes a PATCH endpoint and decodes its response.
    ///
    /// - Parameter endpoint: The endpoint to execute.
    ///
    /// - Returns: The decoded response model.
    ///
    /// - Throws: Any error encountered during request execution or decoding.
    func patch<T: Decodable>(
        _ endpoint: any Endpoint
    ) async throws -> T {

        try await request(endpoint)
    }

    /// Executes an upload endpoint and decodes its response.
    ///
    /// This method is typically used for multipart or file upload
    /// operations that return a response model.
    ///
    /// - Parameter endpoint: The endpoint to execute.
    ///
    /// - Returns: The decoded response model.
    ///
    /// - Throws: Any error encountered during request execution or decoding.
    func upload<T: Decodable>(
        _ endpoint: any Endpoint
    ) async throws -> T {

        try await request(endpoint)
    }

    /// Executes a DELETE endpoint.
    ///
    /// This convenience method is intended for endpoints that do not
    /// return a response body.
    ///
    /// Internally, this method delegates to
    /// ``NetworkClient/executeWithoutResponse(_:)``.
    ///
    /// - Parameter endpoint: The endpoint to execute.
    ///
    /// - Throws: Any error encountered during request execution.
    func delete(
        _ endpoint: any Endpoint
    ) async throws {

        try await executeWithoutResponse(endpoint)
    }
}
