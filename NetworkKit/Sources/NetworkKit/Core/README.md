# Core

The Core module contains the fundamental abstractions used throughout NetworkKit.

Every other module depends on one or more types defined here.

## Components

### Endpoint

Describes an HTTP request.

### HTTPMethod

Represents supported HTTP methods.

### HTTPHeaders

Provides a type-safe wrapper around HTTP header fields.

### NetworkResponse

Represents a successfully executed HTTP response.

## Architecture

Application

↓

Endpoint

↓

URLRequestBuilder

↓

HTTPClient

↓

NetworkResponse

↓

Decoder

The Core module intentionally contains no networking logic and no transport-specific implementations.

Its responsibility is to define the common language used across the entire networking stack.

## Design Principles

- Transport independent
- Immutable value types
- Protocol-oriented
- Reusable
- Shared across all modules
