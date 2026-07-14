# Interceptors

## Overview

The `Interceptors` module provides a flexible mechanism for inspecting and modifying requests and responses as they pass through the networking pipeline.

Interceptors allow cross-cutting concerns—such as authentication, localization, custom headers, analytics, and response processing—to be implemented independently of the networking engine.

By separating these concerns from `NetworkClient`, the networking layer remains clean, modular, and easy to extend.

---

# Architecture

```text
                  NetworkClient
                        │
        ┌───────────────┴───────────────┐
        │                               │
        ▼                               ▼
RequestInterceptorChain      ResponseInterceptorChain
        │                               │
        ▼                               ▼
Request Interceptors         Response Interceptors
        │                               │
        ▼                               ▼
     HTTPClient                Response Validation
```

---

# Request Lifecycle

Request interceptors are executed before the request is sent.

```text
Endpoint
    │
    ▼
Build URLRequest
    │
    ▼
AuthenticationInterceptor
    │
    ▼
HeadersInterceptor
    │
    ▼
LocaleInterceptor
    │
    ▼
UserAgentInterceptor
    │
    ▼
HTTPClient
```

Each interceptor receives the request returned by the previous interceptor, allowing multiple request transformations to be composed.

---

# Response Lifecycle

Response interceptors are executed after a response has been received.

```text
HTTPClient
    │
    ▼
NetworkResponse
    │
    ▼
ResponseInterceptorChain
    │
    ▼
Processed Response
    │
    ▼
ResponseValidator
    │
    ▼
ResponseDecoder
```

By default, response interceptors are executed in **reverse order of registration**, allowing response processing to mirror the request pipeline.

---

# Components

## RequestInterceptor

Defines the contract for modifying outgoing requests before they are executed.

Typical responsibilities include:

- Authentication
- Adding HTTP headers
- Localization
- User-Agent configuration
- Request metadata

---

## ResponseInterceptor

Defines the contract for inspecting or modifying received responses before validation and decoding.

Typical responsibilities include:

- Response transformation
- Authentication handling
- Analytics
- Metadata extraction
- Custom response processing

---

## RequestInterceptorChain

Executes all registered request interceptors sequentially.

Each interceptor receives the output of the previous interceptor, producing a processing pipeline that incrementally transforms the request.

---

## ResponseInterceptorChain

Executes all registered response interceptors.

Each interceptor processes the output of the previous interceptor before the response continues through the networking pipeline.

---

# Built-in Request Interceptors

## AuthenticationInterceptor

Automatically injects a Bearer access token into requests that require authentication.

The interceptor retrieves a valid token from `AuthenticationManager` before the request is sent.

---

## HeadersInterceptor

Adds a predefined collection of HTTP headers to every outgoing request.

Useful for:

- API version headers
- Static application headers
- Custom metadata

---

## LocaleInterceptor

Adds the `Accept-Language` header using either the device's current locale or a custom locale identifier.

This allows servers to return localized content.

---

## UserAgentInterceptor

Adds a `User-Agent` header that identifies the client application.

Typical information includes:

- Application name
- Version
- Platform
- Device information

---

# Creating a Custom Request Interceptor

```swift
struct RequestIDInterceptor: RequestInterceptor {

    func intercept(
        _ request: URLRequest,
        endpoint: any Endpoint
    ) async throws -> URLRequest {

        var request = request

        request.setValue(
            UUID().uuidString,
            forHTTPHeaderField: "X-Request-ID"
        )

        return request
    }
}
```

---

# Creating a Custom Response Interceptor

```swift
struct AnalyticsInterceptor: ResponseInterceptor {

    func intercept(
        _ response: NetworkResponse,
        request: URLRequest,
        endpoint: any Endpoint
    ) async throws -> NetworkResponse {

        // Record analytics...

        return response
    }
}
```

---

# Registering Interceptors

Interceptors are configured through `NetworkConfiguration`.

```swift
let configuration = NetworkConfiguration(
    requestInterceptors: [
        AuthenticationInterceptor(...),
        HeadersInterceptor(...),
        LocaleInterceptor(),
        UserAgentInterceptor("NetworkKit/1.0")
    ],
    responseInterceptors: [
        AnalyticsInterceptor()
    ]
)
```

The order of registration determines the execution order of the interceptor chains.

---

# Design Principles

The `Interceptors` module follows several SOLID principles:

- **Single Responsibility Principle** — Each interceptor encapsulates one specific concern, such as authentication or localization.
- **Open/Closed Principle** — New interceptor behaviors can be introduced by conforming to `RequestInterceptor` or `ResponseInterceptor` without modifying existing networking code.
- **Dependency Inversion Principle** — `NetworkClient` depends on interceptor abstractions rather than concrete implementations.
- **Composition over Inheritance** — Request and response behavior is composed by registering multiple interceptors instead of subclassing networking components.
- **Thread Safety** — Interceptor protocols conform to `Sendable`, and interceptor chains are implemented as actors to support Swift Concurrency safely.

---

# Summary

The `Interceptors` module enables customizable request and response processing throughout the networking pipeline. By composing small, focused interceptors, applications can implement authentication, localization, custom headers, analytics, and other cross-cutting concerns without coupling them to the networking engine.
