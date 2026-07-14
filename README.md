# NetworkKit

> A modern, protocol-oriented, concurrency-safe networking framework for Swift.

[![Swift](https://img.shields.io/badge/Swift-6.0-orange.svg)]()
[![Platform](https://img.shields.io/badge/iOS-16%2B-blue.svg)]()
[![SPM](https://img.shields.io/badge/SPM-Compatible-red.svg)]()

NetworkKit is a modular networking framework built with **Swift Concurrency**, **Protocol-Oriented Programming**, and **SOLID principles**.

It provides a clean, extensible networking layer that supports multiple transport engines, automatic authentication, retry policies, request/response interception, configurable logging, multipart uploads, and flexible response decoding.

---

# Features

- 🚀 Swift Concurrency (`async/await`)
- 📦 Swift Package Manager
- 🌐 URLSession & Alamofire support
- 🔐 Authentication & Token Refresh
- 🔁 Configurable Retry Policies
- 🧩 Request & Response Interceptors
- 📤 Multipart Uploads
- 📄 Response Validation
- 🔄 Flexible Response Decoding
- 📝 Configurable Logging
- ⚠️ Centralized Error Mapping
- 🧪 Testable Architecture
- 🛠 Dependency Injection Friendly
- ✅ Sendable Compatible

---

# Requirements

| Platform | Version |
|-----------|---------|
| iOS | 16+ |
| macOS | 13+ |
| tvOS | 16+ |
| watchOS | 9+ |
| Swift | 6.0+ |

---

# Installation

## Swift Package Manager

```swift
dependencies: [
    .package(
        url: "https://github.com/marwaattef/NetworkKit.git",
        from: "1.0.0"
    )
]
```

Add the product to your target:

```swift
.product(
    name: "NetworkKit",
    package: "NetworkKit"
)
```

---

# Quick Start

## Create a Configuration

```swift
let configuration = NetworkConfiguration(
    environment: .production
)
```

## Choose a Transport

### URLSession

```swift
let client = NetworkClient(
    configuration: configuration,
    httpClient: URLSessionHTTPClient()
)
```

### Alamofire

```swift
let client = NetworkClient(
    configuration: configuration,
    httpClient: AlamofireHTTPClient()
)
```

## Define an Endpoint

```swift
struct UsersEndpoint: Endpoint {

    let path = "/users"

    let method: HTTPMethod = .get
}
```

## Execute a Request

```swift
let users: [User] = try await client.get(
    UsersEndpoint()
)
```

---

# Architecture

## High-Level Architecture

```text
                          Application
                               │
                               ▼
                       NetworkClient
                               │
      ┌────────────────────────┼────────────────────────┐
      ▼                        ▼                        ▼
URLRequestBuilder        RetryExecutor          NetworkLogger
      │                        │
      ▼                        ▼
RequestInterceptors      RetryPolicy
      │
      ▼
HTTPClient
 ┌───────────────┐
 ▼               ▼
URLSession   Alamofire
      │
      ▼
NetworkResponse
      │
      ▼
ResponseInterceptors
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

## Request Lifecycle

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
Retry Executor
    │
    ▼
HTTP Client
    │
    ▼
NetworkResponse
    │
    ▼
Response Interceptors
    │
    ▼
Response Validator
    │
    ▼
Response Logger
    │
    ▼
Response Decoder
    │
    ▼
Decoded Model
```

---

## Authentication Flow

```text
Request
   │
   ▼
AuthenticationInterceptor
   │
   ▼
AuthenticationManager
   │
   ▼
TokenProvider
   │
Expired?
 │        │
 │No      │Yes
 ▼        ▼
Token  CredentialRefresher
            │
            ▼
        Refresh Token
            │
            ▼
      Retry Request
```

---

## Retry Flow

```text
Request
   │
   ▼
Execute
   │
Success?
│        │
│Yes     │No
▼        ▼
Return RetryPolicy
          │
          ▼
   RetryDecision
          │
 ┌────────┼─────────┐
 ▼        ▼         ▼
Retry  Delay   Refresh Token
          │
          ▼
      Execute Again
```

---

# Package Structure

```text
Sources
└── NetworkKit
    ├── Authentication
    ├── Body
    ├── Builder
    ├── Configuration
    ├── Core
    ├── Decoding
    ├── Error
    ├── Interceptors
    ├── Logging
    ├── Multipart
    ├── Response
    ├── Retry
    └── Transport
```

---

# Modules

| Module | Responsibility |
|----------|----------------|
| Authentication | Token management and authorization |
| Builder | Builds URLRequest objects |
| Body | Request body implementations |
| Transport | Executes HTTP requests |
| Retry | Retry policies and retry execution |
| Interceptors | Request & response middleware |
| Response | HTTP response validation |
| Decoding | Response decoding |
| Logging | Request/response logging |
| Multipart | Multipart uploads |
| Error | Error mapping |

---

# Customization

NetworkKit is built around protocols, making every major component replaceable.

You can provide custom implementations for:

- HTTPClient
- ResponseDecoder
- ResponseValidator
- RetryPolicy
- NetworkLogger
- ErrorMapper
- RequestInterceptor
- ResponseInterceptor
- CredentialRefresher

---

# Dependency Injection

```swift
let client = NetworkClient(
    configuration: configuration,
    httpClient: URLSessionHTTPClient()
)
```

Because NetworkKit depends on abstractions rather than concrete implementations, it integrates easily with dependency injection frameworks.

---

# Testing

Every major component is protocol-based, making unit testing straightforward.

Examples include:

- MockHTTPClient
- MockRetryPolicy
- MockResponseDecoder
- MockLogger
- MockCredentialRefresher

No real network requests are required.

---

# Design Principles

NetworkKit is built around:

- Protocol-Oriented Programming
- SOLID Principles
- Composition over Inheritance
- Separation of Concerns
- Dependency Injection
- Swift Concurrency
- Testability
- Extensibility

---

# Roadmap

- [x] URLSession Transport
- [x] Alamofire Transport
- [x] Authentication
- [x] Token Refresh
- [x] Retry Policies
- [x] Multipart Uploads
- [x] Logging
- [x] Response Validation
- [ ] WebSocket Support
- [ ] Download Manager
- [ ] Upload Progress
- [ ] Metrics Collection

---

