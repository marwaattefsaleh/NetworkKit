
# Configuration

The Configuration module defines how a NetworkClient behaves.

It contains two primary types:

- NetworkEnvironment
- NetworkConfiguration

## NetworkEnvironment

Describes where requests are sent.

Responsibilities:

- Base URL
- Default headers
- Environment identity

## NetworkConfiguration

Describes how requests are executed.

Responsibilities:

- Retry policy
- Authentication
- Logging
- Response validation
- Decoding
- Error mapping
- Interceptors

Separating environment from configuration allows multiple clients to share the same execution behavior while targeting different servers.
