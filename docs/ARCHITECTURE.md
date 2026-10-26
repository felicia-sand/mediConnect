# MediConnect iOS — Architecture Blueprint 📐

This document outlines the architectural patterns, data flow, and engineering design principles guiding the **MediConnect** native iOS application.

---

## 🏛️ Architectural Overview

MediConnect is engineered using the **Model-View-ViewModel (MVVM)** design pattern augmented with a centralized **Core Service Layer** and **Feature-First Domain Slicing**. This structure guarantees:

1. **Separation of Concerns**: UI rendering is strictly decoupled from business logic and cloud persistence.
2. **Testability**: ViewModels and Services operate independently of UIKit/SwiftUI view lifecycles, enabling deterministic unit testing.
3. **Scalability**: New features (e.g., Telemedicine, Prescriptions) can be implemented in self-contained feature modules without polluting shared layers.
4. **Swift Concurrency**: Asynchronous operations utilize structured concurrency (`async`/`await`, `Task`) ensuring compile-time data race safety.

```
┌─────────────────────────────────────────────────────────────┐
│                      Presentation Layer                     │
│                                                             │
│  ┌───────────────────────┐         ┌─────────────────────┐  │
│  │     SwiftUI Views     │ ◄─────► │     ViewModels      │  │
│  │ (Declarative / State) │  Binds  │ (@ObservableObject) │  │
│  └───────────────────────┘         └─────────────────────┘  │
└───────────────────────────────────────────────┬─────────────┘
                                                │ Calls
                                                ▼
┌─────────────────────────────────────────────────────────────┐
│                      Core / Service Layer                   │
│                                                             │
│  ┌─────────────────────────┐     ┌───────────────────────┐  │
│  │     NetworkManager      │     │    Storage / Cache    │  │
│  │ (URLSession async/await)│     │  (Keychain / Storage) │  │
│  └─────────────────────────┘     └───────────────────────┘  │
└───────────────────────────────────────────────┬─────────────┘
                                                │ Fetches / Persists
                                                ▼
┌─────────────────────────────────────────────────────────────┐
│                      Backend Cloud Services                 │
│                                                             │
│  ┌─────────────────────────┐     ┌───────────────────────┐  │
│  │  Firebase Authentication│     │    Cloud Firestore    │  │
│  └─────────────────────────┘     └───────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

---

## 🧩 Architectural Layers

### 1. Presentation Layer (SwiftUI Views)

- **Role**: Render user interface components and capture user interactions.
- **Rules**:
  - Views are declarative and stateless where possible.
  - No network requests, database transactions, or business logic inside view bodies.
  - State is observed via `@ObservedObject`, `@StateObject`, or `@EnvironmentObject`.
  - UI updates are driven strictly by ViewModel published properties.

### 2. ViewModel Layer

- **Role**: Serve as the mediator between the UI and domain services.
- **Rules**:
  - Conforms to `ObservableObject` and runs state mutations on the `@MainActor`.
  - Exposes `@Published` properties for UI state binding (e.g., `isLoading`, `errorMessage`, `isAuthenticated`).
  - Manages view-specific validation, formatting, and action handling.
  - Injects or calls underlying service layer components asynchronously.

### 3. Domain Models

- **Role**: Strongly typed representations of medical domain entities.
- **Entities**:
  - `User`: Patient and doctor profiles, credentials, contact info, and roles (`patient`, `doctor`, `admin`).
  - `Doctor`: Medical practitioner profile, specialization, rating, clinic location, and pricing.
  - `Appointment`: Scheduled visits, timestamps, status (`upcoming`, `completed`, `cancelled`), and notes.
  - `Message`: Telemedicine chat messages, sender/receiver IDs, timestamps, and read states.
- **Rules**:
  - Built as Swift immutable `struct` types.
  - Conform to `Identifiable`, `Codable`, and `Sendable`.

### 4. Core & Service Layer

- **Role**: Reusable infrastructure, networking, and platform utilities.
- **Components**:
  - `NetworkManager`: Generic network client supporting REST endpoints with Swift Concurrency and error handling.
  - `AppConstants`: Single source of truth for app metadata, API routes, Firestore collections, and layout metrics.
  - `Extensions`: Native type extensions for Swift (`Date`, `String`) and SwiftUI (`Color`, `View`).
  - `Storage`: Secure token management in iOS Keychain and local configuration.

---

## ☁️ Firebase Cloud Architecture

MediConnect relies on **Google Cloud Firebase** for backend infrastructure:

### 1. Firebase Authentication
- Handles patient and provider identity lifecycle.
- Supports Email/Password authentication.
- Auth session state is observed at the root application level (`ContentView.swift`).

### 2. Cloud Firestore Schema
Cloud Firestore collections mirror `AppConstants.Firebase`:

```
firestore/
├── users/
│   └── {userId}/
│       ├── fullName: String
│       ├── email: String
│       ├── role: "patient" | "doctor"
│       └── createdAt: Timestamp
│
├── doctors/
│   └── {doctorId}/
│       ├── name: String
│       ├── specialty: String
│       ├── rating: Double
│       └── isAvailable: Bool
│
├── appointments/
│   └── {appointmentId}/
│       ├── patientId: String
│       ├── doctorId: String
│       ├── date: Timestamp
│       └── status: "upcoming" | "completed" | "cancelled"
│
└── conversations/
    └── {conversationId}/
        ├── participants: [String]
        └── messages/
            └── {messageId}/
                ├── senderId: String
                ├── content: String
                └── timestamp: Timestamp
```

---

## 🔒 Security & Data Privacy

1. **Healthcare Data Compliance**: MediConnect is designed with medical data confidentiality principles. No personally identifiable health data (PHI) is transmitted unencrypted or logged.
2. **Credential Segregation**: `GoogleService-Info.plist` and local environment files are ignored by version control.
3. **Keychain Integration**: Auth tokens and sensitive sessions are written to the iOS Keychain with `kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly`.

---

## 🚦 Error Handling Strategy

MediConnect utilizes typed Swift errors for all asynchronous operations:

```swift
enum NetworkError: LocalizedError {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse(Int)
    case decodingError(Error)
    case unknown
}
```

All errors surfaced to the user are mapped to friendly localized strings and displayed through SwiftUI alert bindings or banner states in the ViewModel.
