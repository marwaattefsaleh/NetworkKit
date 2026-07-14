
# Response

## Overview

The `Response` module is responsible for validating network responses before they are decoded into application models.

Rather than coupling response validation directly to the networking engine, the module defines a `ResponseValidator` abstraction that determines whether a response represents a successful request or an error.

This separation allows applications to customize validation logic while keeping the networking pipeline simple and reusable.

---

# Architecture

```text
HTTPClient
     │
     ▼
NetworkResponse
     │
     ▼
ResponseValidator
     │
     ├──────── Success ────────► ResponseDecoder
     │
     └──────── Failure ────────► NetworkError
```

---

# Components

## ResponseValidator

`ResponseValidator` defines the contract for validating network responses.

Implementations inspect a `NetworkResponse` and determine whether it should continue through the networking pipeline or fail with an error.

---

## DefaultResponseValidator

`DefaultResponseValidator` is the default implementation provided by NetworkKit.

It validates responses using standard HTTP status codes.

Supported mappings include:

| Status Code | Result |
|-------------|--------|
| 200–299 | Success |
| 401 | Unauthorized |
| 403 | Forbidden |
| 404 | Not Found |
| 429 | Too Many Requests |
| 500–599 | Server Error |
| Others | HTTP Error |

---

## EmptyResponse

`EmptyResponse` represents endpoints that intentionally return no response body.

Typical examples include:

- DELETE requests
- Logout endpoints
- 204 No Content responses

Example:

```swift
let _: EmptyResponse = try await client.execute(endpoint)
```

---

# Typical Flow

```text
HTTP Response
      │
      ▼
NetworkResponse
      │
      ▼
ResponseValidator
      │
 ┌────┴─────┐
 │          │
 ▼          ▼
Valid     Invalid
 │          │
 ▼          ▼
Decode   Throw NetworkError
```

---

# Usage

## Default Validation

```swift
let validator = DefaultResponseValidator()

try validator.validate(response)
```

---

## Custom Validator

Applications can provide their own validator.

```swift
struct CustomResponseValidator: ResponseValidator {

    func validate(
        _ response: NetworkResponse
    ) throws {

        guard response.statusCode == 200 else {
            throw MyAPIError.invalidResponse
        }
    }
}
```

---

# Design Principles

The `Response` module follows several SOLID principles:

- **Single Responsibility Principle** — Validation is separated from networking and decoding.
- **Open/Closed Principle** — Custom validation strategies can be introduced without modifying the networking engine.
- **Dependency Inversion Principle** — The networking layer depends on the `ResponseValidator` abstraction instead of concrete implementations.
- **Thread Safety** — All public types conform to `Sendable`.

---

# Summary

The `Response` module provides a lightweight, extensible mechanism for validating HTTP responses before decoding. By separating response validation from request execution, NetworkKit remains flexible, testable, and adaptable to different API requirements.
