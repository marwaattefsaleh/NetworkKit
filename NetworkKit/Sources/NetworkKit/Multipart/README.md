# Multipart

## Overview

The `Multipart` module provides the models required to build and upload `multipart/form-data` requests.

Multipart requests allow an HTTP request to contain both text fields and binary files within the same payload. This format is commonly used for uploading images, videos, documents, and other files alongside additional form data.

The module focuses on describing the structure of multipart requests while leaving request encoding and transmission to the networking layer.

---

# Architecture

```text
                MultipartRequest
                ┌──────────────┐
                │ Parameters   │
                │ Files        │
                └──────┬───────┘
                       │
         ┌─────────────┴─────────────┐
         │                           │
         ▼                           ▼
 Form Fields                 MultipartFile
                                     │
                                     ▼
                             MultipartSource
                         ┌───────────┴───────────┐
                         ▼                       ▼
                    Data Source            File URL
```

---

# Components

## MultipartRequest

`MultipartRequest` represents the payload of a `multipart/form-data` request.

A multipart request consists of:

- Zero or more text parameters.
- Zero or more uploaded files.

Example:

```swift
let request = MultipartRequest(
    parameters: [
        "username": "john",
        "email": "john@example.com"
    ],
    files: [avatar]
)
```

---

## MultipartFile

`MultipartFile` represents a single file included in a multipart request.

Each file contains:

- Form field name
- File name
- MIME type
- File data
- Source information

Example:

```swift
let image = MultipartFile(
    name: "avatar",
    fileName: "profile.jpg",
    mimeType: "image/jpeg",
    data: imageData,
    source: .data(imageData)
)
```

---

## MultipartSource

`MultipartSource` identifies where the uploaded file originated.

Supported sources include:

### In-memory data

```swift
.data(imageData)
```

Useful when:

- Capturing photos
- Downloading temporary files
- Working with generated content

### Local file

```swift
.fileURL(fileURL)
```

Useful when:

- Uploading documents
- Uploading videos
- Working with files stored on disk

---

# Typical Upload Flow

```text
User Selects File
        │
        ▼
MultipartFile
        │
        ▼
MultipartRequest
        │
        ▼
MultipartBody
        │
        ▼
URLRequest
        │
        ▼
HTTPClient
        │
        ▼
Server
```

---

# Usage

## Upload a Single File

```swift
let image = MultipartFile(
    name: "image",
    fileName: "photo.jpg",
    mimeType: "image/jpeg",
    data: imageData,
    source: .data(imageData)
)

let multipart = MultipartRequest(
    files: [image]
)
```

---

## Upload Multiple Files

```swift
let multipart = MultipartRequest(
    files: [
        avatar,
        document,
        video
    ]
)
```

---

## Upload Files with Form Fields

```swift
let multipart = MultipartRequest(
    parameters: [
        "firstName": "John",
        "lastName": "Doe"
    ],
    files: [
        avatar
    ]
)
```

---

# hasFiles

`MultipartRequest` provides a convenience property for determining whether any files have been added.

```swift
if multipart.hasFiles {
    // Build multipart request
}
```

---

# Supported Content Types

The multipart module is designed to work with any file type.

Common MIME types include:

| File Type | MIME Type |
|-----------|-----------|
| JPEG | `image/jpeg` |
| PNG | `image/png` |
| GIF | `image/gif` |
| PDF | `application/pdf` |
| JSON | `application/json` |
| ZIP | `application/zip` |
| MP4 | `video/mp4` |
| MP3 | `audio/mpeg` |

---

# Integration

The `Multipart` module works together with the request body and networking components.

```text
MultipartRequest
        │
        ▼
MultipartBody
        │
        ▼
RequestBuilder
        │
        ▼
URLRequest
        │
        ▼
HTTPClient
```

---

# Design Principles

The `Multipart` module follows several design principles:

- **Single Responsibility Principle** — Models describe multipart request data without performing encoding or networking.
- **Protocol-Oriented Architecture** — Integrates cleanly with the networking layer through abstractions.
- **Immutable Models** — Multipart request models are immutable after creation.
- **Thread Safety** — All public types conform to `Sendable`, making them safe for use with Swift Concurrency.

---

# Summary

The `Multipart` module provides a lightweight and reusable representation of `multipart/form-data` requests. By separating multipart models from request encoding and network transport, the module remains simple, extensible, and easy to integrate into different networking implementations.
