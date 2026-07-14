# NetworkKit

> A modern, protocol-oriented, concurrency-safe networking framework for Swift.

NetworkKit is a modular networking library designed for iOS, macOS, watchOS, and tvOS applications. It provides a clean abstraction over HTTP networking while remaining independent of any specific networking framework.

Built with **Swift Concurrency**, **Protocol-Oriented Programming**, and **SOLID principles**, NetworkKit makes networking easy to extend, test, and maintain.

---

# Features

- ✅ Native Swift Concurrency (`async/await`)
- ✅ Protocol-Oriented Architecture
- ✅ Modular design
- ✅ URLSession and Alamofire support
- ✅ Automatic request building
- ✅ Authentication management
- ✅ Automatic token refresh
- ✅ Request & Response interceptors
- ✅ Retry policies
- ✅ Exponential backoff retry
- ✅ Multipart uploads
- ✅ Flexible response decoding
- ✅ Response validation
- ✅ Centralized error mapping
- ✅ Configurable logging
- ✅ Dependency Injection friendly
- ✅ Fully testable
- ✅ Sendable-compatible APIs

---

# Architecture

```text
                          App
                           │
                           ▼
                    NetworkClient
                           │
        ┌──────────────────┼──────────────────┐
        │                  │                  │
        ▼                  ▼                  ▼
 URLRequestBuilder     RetryExecutor      Logger
        │                  │
        ▼                  ▼
 RequestInterceptors   RetryPolicy
        │
        ▼
      HTTPClient
   ┌───────────────┐
   │               │
   ▼               ▼
URLSession     Alamofire
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
 Decodable Model
```

---

# Package Structure

```text
NetworkKit
│
├── Authentication
├── Body
├── Builder
├── Configuration
├── Core
├── Decoding
├── Engine
├── Error
├── Interceptors
├── Logging
├── Multipart
├── Response
└── Retry
```

Each module has a single responsibility and can evolve independently.

---

# Modules

## Authentication

Handles authentication and credential management.

Includes:

- AuthenticationManager
- TokenProvider
- CredentialRefresher
- AuthenticationInterceptor

Features:

- Access token retrieval
- Automatic refresh
- Token expiration handling

---

## Builder

Responsible for converting an `Endpoint` into a `URLRequest`.

Handles:

- Base URLs
- Paths
- HTTP methods
- Query parameters
- Headers
- Request bodies
- Multipart requests

---

## Body

Provides strongly typed request body implementations.

Includes:

- JSONBody
- FormURLEncodedBody
- RawBody
- MultipartBody
- EmptyBody
- NoBody

---

## Transport

Executes HTTP requests.

Supports multiple transport implementations:

- URLSessionHTTPClient
- AlamofireHTTPClient

The transport layer is completely replaceable.

---

## Retry

Provides configurable retry strategies.

Includes:

- RetryPolicy
- RetryExecutor
- RetryDecision
- ExponentialBackoffRetry

Supports:

- Retry on network failures
- Retry on server errors
- Retry on rate limiting
- Credential refresh

---

## Interceptors

Allows requests and responses to be modified before and after execution.

Built-in interceptors include:

- AuthenticationInterceptor
- HeadersInterceptor
- LocaleInterceptor
- UserAgentInterceptor

Custom interceptors are easy to implement.

---

## Response

Responsible for validating HTTP responses.

Includes:

- ResponseValidator
- DefaultResponseValidator
- EmptyResponse

---

## Decoding

Decodes response data into models.

Includes:

- ResponseDecoder
- JSONResponseDecoder

Supports custom serialization strategies.

---

## Logging

Provides configurable network logging.

Includes:

- ConsoleLogger
- CompositeLogger
- CurlFormatter
- PrettyLogFormatter
- RequestLogEvent
- ResponseLogEvent
- ErrorLogEvent

Supports:

- Console logging
- cURL generation
- Custom loggers

---

## Multipart

Supports multipart/form-data uploads.

Includes:

- MultipartRequest
- MultipartFile
- MultipartSource

Supports:

- File uploads
- Data uploads
- Form fields

---

## Error

Centralizes networking errors.

Includes:

- NetworkError
- ErrorMapper
- DefaultErrorMapper

Provides consistent error handling across the framework.

---

# Request Lifecycle

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
HTTPClient
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

# Getting Started

## Create a Configuration

```swift
let configuration = NetworkConfiguration(
    environment: .production
)
```

---

## Choose a Transport

Using URLSession:

```swift
let client = NetworkClient(
    configuration: configuration,
    httpClient: URLSessionHTTPClient()
)
```

Using Alamofire:

```swift
let client = NetworkClient(
    configuration: configuration,
    httpClient: AlamofireHTTPClient()
)
```

---

## Define an Endpoint

```swift
struct UsersEndpoint: Endpoint {

    let path = "/users"

    let method: HTTPMethod = .get
}
```

---

## Execute a Request

```swift
let users: [User] = try await client.request(
    UsersEndpoint()
)
```

Or

```swift
let users: [User] = try await client.get(
    UsersEndpoint()
)
```

---

# Customization

Almost every component in NetworkKit can be replaced.

Examples include:

- Custom HTTP clients
- Custom retry policies
- Custom loggers
- Custom decoders
- Custom validators
- Custom interceptors
- Custom authentication providers
- Custom error mappers

The framework is designed around protocols, making customization straightforward.

---

# Dependency Injection

NetworkKit is designed for dependency injection.

```swift
let client = NetworkClient(
    configuration: configuration,
    httpClient: URLSessionHTTPClient()
)
```

Applications can swap implementations without changing business logic.

---

# Testing

Every major component is protocol-based, making unit testing simple.

Examples:

- Mock HTTPClient
- Mock ResponseDecoder
- Mock RetryPolicy
- Mock Logger
- Mock AuthenticationManager

No real network requests are required for testing.

---

# Swift Concurrency

NetworkKit embraces modern Swift concurrency.

Features include:

- async/await APIs
- Sendable-compatible protocols
- Actor-based synchronization
- Thread-safe abstractions

---

# Design Principles

NetworkKit is built around several architectural principles.

### Protocol-Oriented Programming

Behavior is defined through protocols rather than inheritance.

---

### SOLID

- Single Responsibility Principle
- Open/Closed Principle
- Liskov Substitution Principle
- Interface Segregation Principle
- Dependency Inversion Principle

---

### Composition over Inheritance

Small components are composed together to build flexible networking behavior.

---

### Separation of Concerns

Each module has a dedicated responsibility.

Examples:

- Builder builds requests.
- Transport executes requests.
- Retry handles retries.
- Logging records network activity.
- Decoding converts data into models.

---

### Testability

Every dependency can be mocked independently.

---

### Extensibility

Applications can extend the framework by implementing protocols instead of modifying existing code.

---

# Why NetworkKit?

NetworkKit aims to provide a networking layer that is:

- Clean
- Modular
- Scalable
- Testable
- Framework-agnostic
- Easy to understand
- Easy to customize
- Production-ready

Instead of coupling applications to a specific networking framework, NetworkKit exposes a consistent API while allowing developers to choose the transport, logging, retry, authentication, and decoding strategies that best fit their applications.

---

## Architecture

```text
                         Application
                              │
                              ▼
                      NetworkClient
                              │
      ┌───────────────────────┼────────────────────────┐
      │                       │                        │
      ▼                       ▼                        ▼
URLRequestBuilder        RetryExecutor             NetworkLogger
      │                       │
      ▼                       ▼
RequestInterceptor     RetryPolicy
      │
      ▼
HTTPClient
      │
 ┌────┴───────────────┐
 ▼                    ▼
URLSession      Alamofire
      │
      ▼
NetworkResponse
      │
      ▼
ResponseInterceptor
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

## Request Lifecycle

```text
                Endpoint
                   │
                   ▼
        URLRequestBuilder
                   │
                   ▼
      Request Interceptor Chain
                   │
                   ▼
         Authentication
                   │
                   ▼
          Custom Headers
                   │
                   ▼
          User-Agent / Locale
                   │
                   ▼
          Request Logger
                   │
                   ▼
           Retry Executor
                   │
                   ▼
             HTTP Client
          ┌────────┴────────┐
          │                 │
          ▼                 ▼
    URLSession         Alamofire
          │
          ▼
      NetworkResponse
          │
          ▼
    Response Interceptors
          │
          ▼
   Response Validation
          │
          ▼
      Response Logger
          │
          ▼
      Response Decoder
          │
          ▼
      Decodable Model
```

## Package Structure

```text
                NetworkKit
                     │
 ┌───────────────────┼────────────────────┐
 │                   │                    │
 ▼                   ▼                    ▼
Authentication   Configuration        Logging
 │                   │                    │
 └──────────────┬────┴──────────────┐     │
                ▼                   ▼     │
             Builder            Retry     │
                │                 │       │
                └─────────┬───────┘       │
                          ▼               │
                     Transport────────────┘
                          │
              ┌───────────┼─────────────┐
              ▼           ▼             ▼
        Interceptors   Response     Decoding
              │
              ▼
          Multipart
```

## NetworkClient

```text
build()
   │
   ▼
request interceptors
   │
   ▼
request logger
   │
   ▼
retry executor
   │
   ▼
HTTP client
   │
   ▼
response interceptors
   │
   ▼
response validator
   │
   ▼
response logger
   │
   ▼
response decoder
   │
   ▼
return model
```

## Authentication

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
   │ token expired?
   │
   ├──────No────────────► Access Token
   │
   ▼
CredentialRefresher
   │
   ▼
New Token
   │
   ▼
Retry Request
```

## Retry

```text
HTTP Request
      │
      ▼
 Execute
      │
      ▼
Success?
 │           │
 │Yes        │No
 ▼           ▼
Return   RetryPolicy
              │
              ▼
      RetryDecision
              │
      ┌───────┼────────────┐
      ▼       ▼            ▼
 Retry  Retry After   Refresh Token
      │       │            │
      └───────┴────────────┘
              │
              ▼
        Execute Again
```

## Logging

```text
Request
   │
   ▼
RequestLogEvent
   │
   ▼
NetworkLogger
   │
   ▼
LogFormatter
   │
   ▼
Console / File / Custom Logger
```

