
# Body

The Body module defines how HTTP request bodies are represented and encoded.

Instead of using a single enum with associated values, NetworkKit models each body type as an independent type conforming to `RequestBody`.

This follows the Open/Closed Principle, allowing new body formats to be added without modifying existing code.

## Available Body Types

| Type | Description |
|------|-------------|
| `NoBody` | No request body. |
| `EmptyBody` | Explicitly empty body (`Content-Length: 0`). |
| `JSONBody` | Encodes an `Encodable` value as JSON. |
| `FormURLEncodedBody` | Encodes key-value pairs using `application/x-www-form-urlencoded`. |
| `RawBody` | Sends arbitrary binary data. |
| `MultipartBody` | Represents multipart uploads. |

## Architecture

Endpoint

↓

RequestBody

↓

URLRequestBuilder

↓

URLRequest

The request body is responsible only for encoding itself.

Transport-specific concerns, such as multipart encoding, are delegated to the networking engine (`URLSession` or `Alamofire`).
