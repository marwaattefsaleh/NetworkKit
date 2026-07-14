# Builder

The **Builder** module is responsible for converting high-level `Endpoint` definitions into concrete `URLRequest` instances.

It acts as the bridge between your application's networking models and the underlying HTTP transport layer.

The builder focuses solely on **request construction** and is intentionally independent of request execution, retries, authentication, logging, and response processing.

---

# Responsibilities

`URLRequestBuilder` is responsible for:

* Constructing the request URL.
* Combining the environment's base URL with the endpoint path.
* Appending query parameters.
* Applying the HTTP method.
* Applying default environment headers.
* Applying endpoint-specific headers.
* Encoding and attaching the request body.
* Applying the request timeout.

It is **not** responsible for:

* Executing requests.
* Authentication.
* Retry logic.
* Logging.
* Response validation.
* Response decoding.

These responsibilities belong to other modules within `NetworkKit`.

---

# Request Build Flow

```text
Endpoint
    │
    ▼
URLRequestBuilder
    │
    ├── Build URL
    │       ├── Base URL
    │       ├── Path
    │       └── Query Items
    │
    ├── Apply HTTP Method
    │
    ├── Apply Headers
    │       ├── Environment Headers
    │       └── Endpoint Headers
    │
    ├── Apply Request Body
    │
    └── Apply Timeout
            │
            ▼
        URLRequest
```

---

# URL Construction

The builder combines the environment's base URL with the endpoint path.

Example:

**Environment**

```
https://api.example.com
```

**Endpoint**

```
path = "users"
```

Produces:

```
https://api.example.com/users
```

If query items are provided, they are automatically appended using `URLComponents`.

Example:

```
https://api.example.com/users?page=2&limit=20
```

---

# Header Resolution

Headers are applied in two stages.

1. Environment headers
2. Endpoint headers

If both define the same header, the endpoint value overrides the environment value.

Example:

Environment:

```
Accept: application/json
Authorization: Bearer oldToken
```

Endpoint:

```
Authorization: Bearer newToken
```

Result:

```
Accept: application/json
Authorization: Bearer newToken
```

---

# Request Body

The builder delegates body encoding to the `RequestBody` abstraction.

Each body type is responsible for encoding itself and providing its corresponding `Content-Type`.

Built-in body implementations include:

* `NoBody`
* `EmptyBody`
* `JSONBody`
* `FormURLEncodedBody`
* `RawBody`
* `MultipartBody`

This keeps the builder independent of any specific encoding strategy.

---

# Design Principles

The Builder module follows several architectural principles:

### Single Responsibility Principle

The builder only creates `URLRequest` instances.

### Open/Closed Principle

New request body types or endpoint implementations can be introduced without modifying the builder.

### Dependency Inversion

The builder depends on abstractions (`Endpoint` and `RequestBody`) rather than concrete implementations.

### Transport Independence

The builder has no knowledge of `URLSession`, `Alamofire`, or any other networking engine.

---

# Example

```swift
let request = try builder.build(
    endpoint: UserDetailsEndpoint(id: 42)
)
```

The returned `URLRequest` is fully configured and ready to be executed by any `HTTPClient` implementation.

---

# Related Modules

* **Core** – Defines `Endpoint`, `HTTPMethod`, `HTTPHeaders`, and `NetworkResponse`.
* **Body** – Provides request body implementations.
* **Configuration** – Supplies the networking environment and timeout configuration.
* **Engine** – Executes the generated `URLRequest`.

