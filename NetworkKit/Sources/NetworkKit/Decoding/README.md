
# Decoding

The Decoding module is responsible for converting raw response data into strongly typed Swift models.

The networking layer delegates all serialization responsibilities to a `ResponseDecoder`, allowing different data formats to be supported without changing request execution.

---

# Components

## ResponseDecoder

Defines the interface for decoding response data.

## JSONResponseDecoder

Default implementation using Foundation's `JSONDecoder`.

---

# Responsibilities

- Deserialize response data.
- Convert raw bytes into Swift models.
- Hide serialization details from the networking layer.

The module is intentionally **not** responsible for:

- Executing requests.
- Validating responses.
- Error mapping.
- Authentication.
- Logging.

---

# Architecture

HTTP Response

↓

Raw Data

↓

ResponseDecoder

↓

Swift Model

---

# Extensibility

Additional decoders can be implemented by conforming to `ResponseDecoder`.

Examples include:

- XML
- Property Lists
- Protobuf
- MessagePack
- CBOR

No changes to `NetworkClient` are required when introducing new decoding strategies.
