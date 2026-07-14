
# Transport

## Overview

The `Transport` module is responsible for executing network requests and coordinating the complete request lifecycle.

It serves as the central orchestration layer of **NetworkKit**, combining request building, request execution, retry handling, interceptors, response validation, decoding, logging, and error mapping into a single, reusable API.

Rather than performing each responsibility itself, `NetworkClient` delegates work to specialized components, resulting in a modular, testable, and extensible architecture.

---

# Architecture

```text
                   Endpoint
                      │
                      ▼
             URLRequestBuilder
                      │
                      ▼
          Request Interceptors
                      │
                      ▼
              Request Logger
                      │
                      ▼
              RetryExecutor
                      │
                      ▼
                HTTPClient
          ┌──────────┴──────────┐
          │                     │
          ▼                     ▼
URLSessionHTTPClient   AlamofireHTTPClient
          │
          ▼
           NetworkResponse
                  │
                  ▼
       Response Interceptors
                  │
                  ▼
       ResponseValidator
                  │
                  ▼
        ResponseDecoder
                  │
                  ▼
           Decoded Model
```

---

# Components

## NetworkClient

`NetworkClient` is the primary entry point for executing network requests.

It coordinates the entire networking pipeline by delegating responsibilities to the appropriate components.

Responsibilities include:

- Building requests
- Applying request interceptors
- Executing HTTP requests
- Applying retry policies
- Processing response interceptors
- Validating responses
- Logging network activity
- Decoding response models
- Mapping errors

---

## HTTPClient

`HTTPClient` defines the abstraction responsible for executing HTTP requests.

By depending on this protocol rather than a concrete implementation, the networking layer remains independent of any transport framework.

Typical implementations include:

- `URLSessionHTTPClient`
- `AlamofireHTTPClient`
- Mock clients for testing

---

## URLSessionHTTPClient

`URLSessionHTTPClient` executes requests using Apple's native `URLSession` APIs.

It provides a lightweight implementation with no external dependencies and is suitable for most applications.

---

## AlamofireHTTPClient

`AlamofireHTTPClient` executes requests using Alamofire's `Session`.

It adapts Alamofire's networking APIs to the `HTTPClient` abstraction, allowing applications to switch between transport implementations without affecting higher-level networking code.

---

# Request Lifecycle

A request executed through `NetworkClient` follows the same sequence regardless of the underlying HTTP client.

```text
Endpoint
    │
    ▼
Build URLRequest
    │
    ▼
Apply Request Interceptors
    │
    ▼
Log Request
    │
    ▼
RetryExecutor
    │
    ▼
HTTPClient
    │
    ▼
Receive NetworkResponse
    │
    ▼
Apply Response Interceptors
    │
    ▼
Validate Response
    │
    ▼
Log Response
    │
    ▼
Decode Response
    │
    ▼
Return Model
```

---

# Public API

The transport module exposes several convenience methods through `NetworkClient`.

```swift
try await client.request(endpoint)

try await client.get(endpoint)

try await client.post(endpoint)

try await client.put(endpoint)

try await client.patch(endpoint)

try await client.upload(endpoint)

try await client.delete(endpoint)
```

Each method executes the same networking pipeline while providing a more expressive API for common HTTP operations.

---

# Using URLSession

```swift
let client = NetworkClient(
    configuration: configuration,
    httpClient: URLSessionHTTPClient()
)
```

---

# Using Alamofire

```swift
let client = NetworkClient(
    configuration: configuration,
    httpClient: AlamofireHTTPClient()
)
```

Because both implementations conform to `HTTPClient`, they can be swapped without changing application code.

---

# Testing

The transport layer is easy to test by providing a mock implementation of `HTTPClient`.

```swift
struct MockHTTPClient: HTTPClient {

    func execute(
        _ request: URLRequest
    ) async throws -> NetworkResponse {

        // Return a mocked response.
    }
}
```

This allows higher-level networking behavior to be tested independently of the underlying transport implementation.

---

# Integration

The `Transport` module works closely with several other modules in NetworkKit.

```text
Configuration
        │
        ▼
Transport
        │
 ┌──────┼──────────────┐
 │      │              │
 ▼      ▼              ▼
Retry Logging Response
 │                     │
 ▼                     ▼
Interceptors      Decoding
```

---

# Design Principles

The `Transport` module follows several SOLID principles:

- **Single Responsibility Principle** — Each component has a well-defined responsibility, while `NetworkClient` coordinates the overall request lifecycle.
- **Open/Closed Principle** — New transport implementations can be added by conforming to `HTTPClient` without modifying existing networking code.
- **Liskov Substitution Principle** — Any `HTTPClient` implementation can be substituted transparently, including `URLSessionHTTPClient`, `AlamofireHTTPClient`, or custom implementations.
- **Dependency Inversion Principle** — Higher-level networking components depend on abstractions such as `HTTPClient`, `ResponseDecoder`, `ResponseValidator`, and `RetryPolicy`.
- **Composition over Inheritance** — Networking behavior is composed from independent, reusable components rather than inheritance hierarchies.
- **Thread Safety** — Public transport abstractions are designed for use with Swift Concurrency.

---

# Summary

The `Transport` module acts as the orchestration layer of NetworkKit. It coordinates request execution while delegating specialized responsibilities—such as retries, logging, validation, decoding, and interception—to dedicated components. This architecture keeps the networking layer modular, extensible, testable, and independent of any specific HTTP transport implementation.
