# Error

The Error module provides a unified error model for NetworkKit.

Instead of exposing transport-specific errors (such as `URLError` or `AFError`), all failures are converted into `NetworkError`.

This gives applications a consistent and predictable way to handle networking failures regardless of the underlying HTTP engine.

---

# Components

## NetworkError

Represents all networking-related errors.

Categories include:

* Request construction
* HTTP errors
* Network connectivity
* Serialization
* Authentication
* Transport
* Unknown

## ErrorMapper

Defines how arbitrary errors are converted into `NetworkError`.

## DefaultErrorMapper

Provides built-in mappings for:

* `URLError`
* `DecodingError`
* `EncodingError`
* `AuthenticationError`
* `AFError` (when Alamofire is available)

---

# Error Flow

```text
Foundation / Alamofire Error
            │
            ▼
      ErrorMapper
            │
            ▼
      NetworkError
            │
            ▼
        Application
```

Applications should catch `NetworkError` rather than transport-specific errors whenever possible.

---

# Extensibility

Custom networking engines may provide their own `ErrorMapper` implementations to translate framework-specific errors into `NetworkError`.

This keeps the rest of the networking layer independent of any particular HTTP implementation.

