# Retry

## Overview

The `Retry` module provides a flexible and extensible mechanism for retrying failed network requests.

Instead of embedding retry logic directly into the networking engine, the module separates **retry decisions** from **retry execution**. This allows applications to customize retry behavior while keeping request execution simple and reusable.

The retry system is designed around the following principles:

- Protocol-oriented design
- Strategy Pattern for configurable retry behavior
- Swift Concurrency compatibility
- Extensible retry policies
- Separation of retry decision-making from execution

---

# Architecture

```text
                 Network Request
                        │
                        ▼
                 Network Operation
                        │
          ┌─────────────┴─────────────┐
          │                           │
          ▼                           ▼
      Success                     Failure
          │                           │
          │                           ▼
          │                    RetryPolicy
          │                           │
          │                           ▼
          │                    RetryDecision
          │                           │
          └─────────────┬─────────────┘
                        ▼
                  RetryExecutor
                        │
         ┌──────────────┼──────────────┐
         │              │              │
         ▼              ▼              ▼
     Retry Now     Retry Later   Refresh Credentials
                        │
                        ▼
                Execute Again
```

---

# Components

## RetryPolicy

`RetryPolicy` defines the strategy for retrying failed requests.

A retry policy evaluates:

- The original request
- The received response
- The encountered error
- The current retry count

It then returns a `RetryDecision` describing how the networking layer should proceed.

---

## ExponentialBackoffRetry

`ExponentialBackoffRetry` is the default retry policy provided by NetworkKit.

It retries requests using an exponential backoff strategy.

Supported retry scenarios include:

- Network connectivity failures
- HTTP `429 Too Many Requests`
- HTTP `5xx Server Errors`

The retry delay is calculated using:

```text
delay = baseDelay × 2^retryCount
```

Example delays using a base delay of `0.5` seconds:

| Retry Attempt | Delay |
|---------------|-------|
| 1 | 0.5 s |
| 2 | 1.0 s |
| 3 | 2.0 s |
| 4 | 4.0 s |

---

## RetryDecision

`RetryDecision` represents the outcome of evaluating a failed request.

Possible decisions include:

| Decision | Description |
|----------|-------------|
| `.retry` | Retry immediately |
| `.retryAfter(TimeInterval)` | Retry after a delay |
| `.refreshCredentials` | Refresh credentials before retrying |
| `.doNotRetry` | Stop retrying |

---

## RetryExecutor

`RetryExecutor` coordinates the retry process.

It repeatedly executes a network operation while delegating retry decisions to the configured `RetryPolicy`.

Depending on the returned `RetryDecision`, the executor may:

- Retry immediately
- Wait before retrying
- Refresh authentication credentials
- Stop retrying and propagate the error

The executor does not contain retry logic itself; it simply applies the policy's decisions.

---

# Typical Flow

```text
Execute Request
       │
       ▼
Network Response
       │
       ▼
RetryPolicy
       │
       ▼
RetryDecision
       │
 ┌─────┼──────────────────────────────┐
 │     │              │               │
 ▼     ▼              ▼               ▼
Retry Retry After Refresh Credentials Stop
 │        │              │             │
 ▼        ▼              ▼             ▼
Again   Delay        Refresh Token   Throw Error
```

---

# Usage

## Configure a Retry Policy

```swift
let policy = ExponentialBackoffRetry(
    maxRetries: 3,
    baseDelay: 0.5
)
```

---

## Execute a Request with Retries

```swift
let executor = RetryExecutor(
    policy: policy,
    credentialRefresher: refresher
)

let response = try await executor.execute(
    request: request
) {
    try await httpClient.execute(request)
}
```

---

## Custom Retry Policy

Applications can implement their own retry strategies.

```swift
struct CustomRetryPolicy: RetryPolicy {

    let maxRetries = 2

    func shouldRetry(
        request: URLRequest,
        response: NetworkResponse?,
        error: Error?,
        retryCount: Int
    ) async -> RetryDecision {

        if retryCount >= maxRetries {
            return .doNotRetry
        }

        return .retry
    }
}
```

---

# Authentication Retry

When authentication credentials expire, a retry policy may request a credential refresh instead of immediately retrying.

```text
401 Unauthorized
        │
        ▼
RetryPolicy
        │
        ▼
.refreshCredentials
        │
        ▼
CredentialRefresher
        │
        ▼
Retry Original Request
```

This enables automatic token renewal without exposing authentication logic to the networking engine.

---

# Design Principles

The `Retry` module follows several SOLID principles:

- **Single Responsibility Principle** — Retry policies decide *whether* a request should be retried, while the executor is responsible for *executing* those decisions.
- **Open/Closed Principle** — New retry strategies can be introduced without modifying the retry executor.
- **Dependency Inversion Principle** — The networking layer depends on the `RetryPolicy` abstraction rather than concrete retry implementations.
- **Composition over Inheritance** — Retry behavior is composed by injecting different policy implementations.
- **Thread Safety** — All public retry abstractions conform to `Sendable`, making them safe for use with Swift Concurrency.

---

# Extending the Module

The retry module is designed to be easily extended.

Examples include:

- Fixed delay retry
- Linear backoff retry
- Exponential backoff with jitter
- Retry only idempotent requests
- API-specific retry strategies

Each strategy simply conforms to `RetryPolicy`.

---

# Summary

The `Retry` module provides a robust and extensible foundation for retrying failed network requests. By separating retry decisions from retry execution, it enables customizable retry strategies while keeping the networking layer clean, reusable, and easy to maintain.
