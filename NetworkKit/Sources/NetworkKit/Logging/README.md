
# Logging

## Overview

The `Logging` module provides a flexible and extensible logging system for monitoring network activity throughout the request lifecycle.

Rather than coupling logging directly to the networking engine, the module models logging as a collection of **events**, **loggers**, and **formatters**. This separation of concerns allows applications to customize how network activity is recorded without modifying the networking layer itself.

The module is designed around the following principles:

- **Protocol-oriented design**
- **Strategy Pattern** for interchangeable loggers and formatters
- **Visitor Pattern** for formatting different log event types
- **Swift Concurrency** compatibility through `Sendable`
- **Extensibility** for custom loggers and output formats

---

## Architecture

```text
                     Network Engine
                            │
                            ▼
                   NetworkLogEvent
                            │
        ┌───────────────────┼───────────────────┐
        │                   │                   │
        ▼                   ▼                   ▼
RequestLogEvent     ResponseLogEvent     ErrorLogEvent
        │                   │                   │
        └───────────────────┼───────────────────┘
                            ▼
                    NetworkLogger
                            │
        ┌───────────────────┼───────────────────┐
        │                   │                   │
        ▼                   ▼                   ▼
 ConsoleLogger     CompositeLogger        NoOpLogger
                            │
                            ▼
                     LogFormatter
                            │
              ┌─────────────┴─────────────┐
              ▼                           ▼
     PrettyLogFormatter          CurlFormatter
```

---

# Components

## NetworkLogger

`NetworkLogger` defines the interface for all logging implementations.

A logger receives `NetworkLogEvent` instances and determines how they should be handled.

Possible implementations include:

- Console logging
- File logging
- Remote logging
- Analytics platforms
- Crash reporting

---

## LoggerLevel

`LoggerLevel` controls the verbosity of logging.

Available levels:

| Level | Description |
|-------|-------------|
| `.none` | Disable logging |
| `.error` | Log only errors |
| `.info` | Log informational events and errors |
| `.debug` | Log requests, responses and errors |
| `.verbose` | Log every available event |

Each logger filters events according to its configured `minimumLevel`.

---

## NetworkLogEvent

Represents a network event emitted by the networking layer.

Every event includes:

- Log level
- Timestamp
- Visitor support

Concrete implementations:

- `RequestLogEvent`
- `ResponseLogEvent`
- `ErrorLogEvent`

---

## RequestLogEvent

Represents an outgoing HTTP request.

Contains:

- `URLRequest`
- Timestamp
- Log level

Typically emitted immediately before the request is sent.

---

## ResponseLogEvent

Represents a completed network request.

Contains:

- Original request
- Network response
- Request duration
- Timestamp
- Log level

Typically emitted after a successful response.

---

## ErrorLogEvent

Represents a failed network operation.

Contains:

- Original request (optional)
- Error
- Duration (optional)
- Timestamp
- Log level

Used for logging failures such as:

- Connectivity issues
- Timeouts
- Authentication failures
- Decoding failures
- Server errors

---

## LogFormatter

A `LogFormatter` converts network events into human-readable text.

Instead of embedding formatting logic inside the logger, formatting is delegated to formatter implementations.

This makes it easy to support multiple output styles.

Included formatters:

- `PrettyLogFormatter`
- `CurlFormatter`

---

## PrettyLogFormatter

Produces concise, readable logs intended for development.

Example:

```text
🌐 REQUEST

GET
https://api.example.com/users
```

```text
✅ RESPONSE

Status:
200

Duration:
0.24s
```

```text
❌ ERROR

The Internet connection appears to be offline.
```

---

## CurlFormatter

Formats outgoing requests as executable cURL commands.

Example:

```bash
curl -X POST \
-H 'Content-Type: application/json' \
-H 'Authorization: Bearer <token>' \
-d '{"email":"john@example.com"}' \
'https://api.example.com/login'
```

This is useful for:

- Backend debugging
- Reproducing requests
- Sharing API calls with teammates
- Importing requests into Postman

Only request events are formatted.

---

## ConsoleLogger

`ConsoleLogger` prints formatted network events to the Xcode console.

It:

1. Filters events by log level.
2. Delegates formatting to a `LogFormatter`.
3. Prints the formatted output.

Example:

```swift
let logger = ConsoleLogger(
    minimumLevel: .debug,
    formatter: PrettyLogFormatter()
)
```

---

## CompositeLogger

`CompositeLogger` forwards every log event to multiple loggers.

Example:

```swift
let logger = CompositeLogger([
    ConsoleLogger(),
    FileLogger(),
    AnalyticsLogger()
])
```

This allows multiple logging destinations without changing the networking layer.

---

## NoOpLogger

`NoOpLogger` ignores all log events.

Useful for:

- Production builds
- Unit tests
- Performance-sensitive environments
- Disabling logging

---

# Visitor Pattern

The logging module uses the Visitor Pattern to separate log events from formatting logic.

Instead of performing runtime type checks, each event delegates formatting to a visitor.

```text
RequestLogEvent
        │
        ▼
accept(visitor)
        │
        ▼
PrettyLogFormatter
```

Benefits include:

- Strong type safety
- Better extensibility
- No runtime casting
- Cleaner separation of responsibilities

---

# Typical Logging Flow

```text
Network Request
        │
        ▼
RequestLogEvent
        │
        ▼
ConsoleLogger
        │
        ▼
PrettyLogFormatter
        │
        ▼
Console Output

        │

HTTP Response
        │
        ▼
ResponseLogEvent
        │
        ▼
Console Output

        │

Network Error
        │
        ▼
ErrorLogEvent
        │
        ▼
Console Output
```

---

# Usage

### Console Logging

```swift
let logger = ConsoleLogger(
    minimumLevel: .debug
)
```

### cURL Logging

```swift
let logger = ConsoleLogger(
    minimumLevel: .debug,
    formatter: CurlFormatter()
)
```

### Multiple Loggers

```swift
let logger = CompositeLogger([
    ConsoleLogger(),
    FileLogger()
])
```

### Disable Logging

```swift
let logger = NoOpLogger()
```

---

# Extending the Module

The logging module is designed to be easily extended.

### Custom Logger

```swift
struct FileLogger: NetworkLogger {
    ...
}
```

### Custom Formatter

```swift
struct JSONFormatter: LogFormatter {
    ...
}
```

No existing code needs to change when adding new implementations.

---

# Design Principles

The `Logging` module follows several SOLID principles:

- **Single Responsibility Principle** — Events represent data, loggers handle output, and formatters define presentation.
- **Open/Closed Principle** — New loggers and formatters can be added without modifying existing implementations.
- **Dependency Inversion Principle** — The networking layer depends on abstractions (`NetworkLogger` and `LogFormatter`) rather than concrete implementations.
- **Composition over Inheritance** — `CompositeLogger` composes multiple loggers instead of relying on inheritance.

---

# Thread Safety

All public logging abstractions conform to `Sendable`, making the module safe to use with Swift Concurrency.

---

# Summary

The `Logging` module provides a lightweight, extensible, and protocol-oriented approach to network logging. By separating **events**, **loggers**, and **formatters**, it enables applications to customize logging behavior while keeping the networking engine clean, reusable, and easy to maintain.
