
# Authentication

The `Authentication` module provides a complete, concurrency-safe authentication system for `NetworkKit`.

Its responsibilities include:

* Managing authentication tokens.
* Refreshing expired credentials.
* Persisting authentication state.
* Coordinating concurrent refresh requests.
* Integrating with the retry mechanism without coupling networking to a specific authentication implementation.

The module is built using Swift Concurrency (`actor`) to ensure thread safety.

---

## Architecture

```text
                    NetworkClient
                          │
                          ▼
                    RetryExecutor
                          │
                          ▼
               CredentialRefresher
                          │
                          ▼
               AuthenticationManager
                  │               │
                  ▼               ▼
          TokenProvider     TokenRefresher
                  │
                  ▼
                Token
```

---

## Components

### AuthenticationManager

`AuthenticationManager` is the central coordinator of the authentication system.

Responsibilities:

* Returns the current authentication token.
* Validates token expiration.
* Refreshes expired tokens.
* Persists newly issued tokens.
* Ensures only one refresh operation runs at a time.

Because it is implemented as an `actor`, multiple network requests can safely request a valid token simultaneously without triggering duplicate refresh operations.

---

### Token

`Token` represents authentication credentials.

A token contains:

* Access Token
* Refresh Token (optional)
* Expiration Date (optional)

It also provides convenience helpers:

* `isExpired`
* `shouldRefresh(within:)`

The refresh window allows credentials to be refreshed before they actually expire, reducing the likelihood of requests failing while in transit.

---

### TokenProvider

`TokenProvider` abstracts token storage.

Implementations may store credentials in:

* Memory
* Keychain
* Database
* Secure Enclave
* Any custom storage

`NetworkKit` ships with `DefaultTokenProvider`, which stores tokens in memory.

Applications are encouraged to provide a Keychain-backed implementation for production.

---

### DefaultTokenProvider

A simple in-memory implementation of `TokenProvider`.

Useful for:

* Unit testing
* Sample applications
* Temporary storage

Not recommended for production because tokens are lost when the application terminates.

---

### TokenRefresher

`TokenRefresher` is responsible for communicating with the authentication backend.

Responsibilities:

* Send the refresh request.
* Decode the authentication response.
* Return a newly issued `Token`.

It does **not** store tokens.

It does **not** manage authentication state.

It only performs the refresh request.

Example responsibilities:

* OAuth refresh endpoint
* JWT refresh endpoint
* Custom authentication API

---

### CredentialRefresher

`CredentialRefresher` is a higher-level abstraction used by the retry system.

Its responsibility is simply:

> Ensure authentication credentials are refreshed.

Unlike `TokenRefresher`, it does not expose refresh tokens or authentication implementation details.

This keeps the retry layer completely independent of the authentication mechanism.

`AuthenticationManager` conforms to `CredentialRefresher`.

---

### AuthenticationError

Represents authentication-specific failures.

Examples include:

* Missing access token
* Missing refresh token
* Refresh failure
* Missing credential refresher

These errors may later be wrapped inside `NetworkError.authentication` before being returned to SDK consumers.

---

## Refresh Flow

When a request requires authentication:

```text
NetworkClient
      │
      ▼
AuthenticationManager.validToken()
      │
      ▼
TokenProvider.getToken()
      │
      ▼
Token expired?
      │
 ┌────┴─────┐
 │          │
No         Yes
 │          │
 ▼          ▼
Return   TokenRefresher.refresh()
Token         │
              ▼
      New Token Received
              │
              ▼
TokenProvider.save()
              │
              ▼
Return Token
```

---

## Concurrent Refresh Protection

If multiple requests detect an expired token simultaneously, only one refresh request is performed.

```text
Request A ───────┐
                 │
Request B ───────┼────► AuthenticationManager
                 │
Request C ───────┘
                      │
                      ▼
              Single Refresh Task
                      │
                      ▼
          All Requests Await Result
```

This prevents duplicate refresh requests and keeps authentication synchronized across concurrent network operations.

---

## Design Principles

The authentication module follows several architectural principles:

* **Single Responsibility Principle**

  * `TokenProvider` stores tokens.
  * `TokenRefresher` performs refresh requests.
  * `AuthenticationManager` coordinates authentication.

* **Dependency Inversion**

  * Consumers depend on protocols instead of concrete implementations.

* **Thread Safety**

  * Authentication state is protected using Swift actors.

* **Transport Independence**

  * Authentication logic is independent of `URLSession`, `Alamofire`, or any networking engine.

* **Extensibility**

  * Applications can provide custom implementations for token storage and refresh without modifying `NetworkKit`.

---

## Extending the Module

Applications can customize authentication by implementing:

* `TokenProvider`
* `TokenRefresher`

This makes it easy to support different authentication mechanisms while reusing the same networking infrastructure.
