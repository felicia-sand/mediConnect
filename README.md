# MediConnect iOS 🏥

[![Platform](https://img.shields.io/badge/Platform-iOS%2017.0%2B-blue.svg?style=flat-square&logo=apple)](https://developer.apple.com/ios/)
[![Swift](https://img.shields.io/badge/Swift-5.9%20%7C%206.0-orange.svg?style=flat-square&logo=swift)](https://swift.org)
[![SwiftUI](https://img.shields.io/badge/UI-SwiftUI-purple.svg?style=flat-square)](https://developer.apple.com/xcode/swiftui/)
[![Architecture](https://img.shields.io/badge/Architecture-MVVM-green.svg?style=flat-square)](#-architecture)
[![Backend](https://img.shields.io/badge/Backend-Firebase-amber.svg?style=flat-square&logo=firebase)](https://firebase.google.com/)
[![License](https://img.shields.io/badge/License-MIT-lightgrey.svg?style=flat-square)](LICENSE)

**MediConnect** is a native iOS healthcare and telemedicine application built with **Swift and SwiftUI**. It provides a secure, intuitive, and high-performance digital bridge between patients and certified medical professionals — facilitating appointment scheduling, virtual consultations, real-time messaging, and health record management.

---

## 📋 Table of Contents

- [Features](#-features)
- [Technology Stack](#-technology-stack)
- [Prerequisites](#-prerequisites)
- [Development Environment](#-development-environment)
- [Installation and Setup](#-installation-and-setup)
- [Project Structure](#-project-structure)
- [Architecture](#-architecture)
- [Branching Conventions](#-branching-conventions)
- [Contribution Guidelines](#-contribution-guidelines)
- [Security & Secrets Management](#-security--secrets-management)
- [Roadmap](#-roadmap)
- [License](#-license)
- [Author](#-author)

---

## 📱 Features

- 🔐 **Secure Authentication** — Role-aware sign-up and login for patients and medical practitioners.
- 📅 **Appointment Management** — Search specialists, check real-time availability, and schedule appointments.
- 💬 **In-App Messaging** — Encrypted end-to-end communication between patients and doctors.
- 📋 **Medical Records & History** — Secure digital repository for prescriptions, lab results, and patient summaries.
- 🎥 **Telemedicine Consultations** — High-definition video and audio consultation capabilities.
- 🔔 **Smart Notifications** — Timely appointment reminders, prescription updates, and health alerts via APNs.
- 📊 **Health Dashboard** — Centralized patient overview displaying upcoming visits, vitals, and health history.

---

## 🛠️ Technology Stack

| Layer | Technology | Details |
|---|---|---|
| **Platform** | iOS 17.0+ | Native Apple ecosystem |
| **Language** | Swift 5.9 / 6.0 | Modern type-safe Swift with strict concurrency support |
| **UI Framework** | SwiftUI | Declarative, reactive UI with dynamic state management |
| **Architecture** | MVVM | Model-View-ViewModel with Combine / Observation |
| **Networking** | URLSession | Async/Await concurrency with custom network abstraction |
| **Authentication** | Firebase Authentication | Secure email/password and identity provider auth |
| **Cloud Database** | Cloud Firestore | Real-time NoSQL cloud storage for appointments and chats |
| **Local Persistence** | SwiftData / CoreData & Keychain | Local cache and secure credential storage |
| **Push Notifications** | APNs | Apple Push Notification service |
| **Dependency Manager** | Swift Package Manager (SPM) / CocoaPods | Native package resolution |
| **Testing** | XCTest & XCUITest | Unit, integration, and UI automation testing |

---

## 💻 Prerequisites

Ensure your development machine meets the following requirements before building the project:

- **Hardware**: Mac with Apple Silicon (M1/M2/M3/M4) or Intel processor (16 GB RAM recommended).
- **macOS**: macOS Sonoma 14.0 or macOS Sequoia 15.0+.
- **Xcode**: Xcode 15.0 or later (Xcode 15.4 / 16.x recommended).
- **Swift**: Swift 5.9 or higher (bundled with Xcode).
- **Git**: Git 2.30+ installed.
- **Firebase Account**: Access to [Firebase Console](https://console.firebase.google.com) to configure Firestore and Authentication services.
- **Apple Developer Account**: Optional for Simulator testing; required for physical device deployment and push notifications.

---

## ⚙️ Development Environment

### 1. Xcode Configuration

Install the Xcode Command Line Tools if not already installed:

```bash
xcode-select --install
```

Verify your active developer directory:

```bash
xcode-select -p
# Should output: /Applications/Xcode.app/Contents/Developer
```

### 2. Recommended Xcode Settings

- **Code Formatting**: Indentation set to **4 spaces** (no tabs).
- **Line Length**: Soft guide at 100 or 120 characters.
- **Build System**: Default New Build System.
- **Concurrency Checking**: Minimal / Targeted for Swift 5.9; Complete for Swift 6 transition.

### 3. Target Simulators

- **Primary Device**: iPhone 15 Pro / iPhone 16 Pro (iOS 17.0+)
- **Secondary Device**: iPhone SE (3rd generation) for small-screen responsive layout testing
- **Tablet**: iPad Pro 11-inch for adaptive layout validation

---

## 🚀 Installation and Setup

### Step 1: Clone the Repository

Clone the project using your preferred protocol:

```bash
# Using SSH (recommended)
git clone git@github-felicia:felicia-sand/mediConnect.git

# Using HTTPS
git clone https://github.com/felicia-sand/mediConnect.git

cd mediConnect
```

### Step 2: Open in Xcode

Open the project in Xcode:

```bash
# If using an Xcode project
open mediConnect.xcodeproj

# Or launch Xcode and open the project directory
xed .
```

### Step 3: Firebase Configuration

MediConnect uses Firebase for Authentication and Cloud Firestore:

1. Navigate to the [Firebase Console](https://console.firebase.google.com).
2. Create a new Firebase project (e.g., `mediConnect-iOS`).
3. Add an **iOS App** with the bundle identifier:
   ```
   com.felicia.mediConnect
   ```
4. Download the generated `GoogleService-Info.plist` file.
5. Place `GoogleService-Info.plist` into the `mediConnect/` root directory in Xcode. Ensure **"Copy items if needed"** and the **mediConnect** target are checked.
6. Enable the following Firebase services in the console:
   - **Authentication**: Enable *Email/Password* provider.
   - **Cloud Firestore**: Create database in production mode with proper security rules.

> [!IMPORTANT]
> `GoogleService-Info.plist` contains sensitive client credentials and is excluded by `.gitignore`. Never commit this file or any API keys to source control.

### Step 4: Resolve Dependencies

If external packages are used via Swift Package Manager:
- In Xcode, select **File → Packages → Resolve Package Versions**.

### Step 5: Build and Run

1. Select your target scheme: **mediConnect**.
2. Select your target destination: e.g., **iPhone 15 Pro (Simulator)**.
3. Press `⌘ + B` to build or `⌘ + R` to run.

---

## 📁 Project Structure

The project follows a scalable, feature-first MVVM architecture:

```
mediConnect/
├── mediConnectApp.swift          # Main application entry point (@main)
├── ContentView.swift             # Root view & auth state router
│
├── Core/                         # Core infrastructure & shared services
│   ├── Network/
│   │   └── NetworkManager.swift  # URLSession async/await networking client
│   ├── Extensions/
│   │   └── Extensions.swift      # Swift & SwiftUI helper extensions
│   ├── Utilities/
│   │   └── AppConstants.swift    # App-wide constants, endpoints & collection names
│   └── Storage/                  # Local persistence & secure Keychain helpers
│
├── Features/                     # Feature modules (Domain-driven MVVM)
│   ├── Authentication/           # User onboarding & authentication flow
│   │   ├── ViewModels/
│   │   │   └── AuthViewModel.swift
│   │   └── Views/
│   │       └── AuthenticationView.swift
│   ├── Dashboard/                # Primary patient dashboard & tab navigation
│   │   └── Views/
│   │       └── MainTabView.swift
│   ├── Appointments/             # Appointment scheduling & tracking
│   │   ├── ViewModels/
│   │   └── Views/
│   ├── Doctors/                  # Doctor directory & profile views
│   │   ├── ViewModels/
│   │   └── Views/
│   ├── Messaging/                # Real-time consultation messaging
│   │   ├── ViewModels/
│   │   └── Views/
│   └── Profile/                  # User profile, medical history & settings
│       ├── ViewModels/
│       └── Views/
│
├── Models/                       # Strongly-typed domain models & mock data
│   ├── User.swift                # Patient & Doctor user entity
│   ├── Doctor.swift              # Doctor profile entity & specializations
│   ├── Appointment.swift         # Appointment entity & status lifecycle
│   └── Message.swift             # Real-time chat message entity
│
├── Resources/                    # App assets, custom fonts & localizations
│   ├── Assets.xcassets/          # App icons, colors & images
│   ├── Fonts/                    # Custom typography
│   └── Localizations/            # String catalogs & translations
│
└── docs/                         # Technical documentation & project standards
    ├── ARCHITECTURE.md           # In-depth architectural & data-flow documentation
    └── DEVELOPMENT_STANDARDS.md  # Git workflow, coding conventions & review standards
```

---

## 🏗️ Architecture

MediConnect strictly adheres to the **MVVM (Model-View-ViewModel)** architectural pattern with clean unidirectional data flow:

```
┌─────────────────┐         ┌──────────────────────┐         ┌─────────────────┐
│                 │  Binds  │                      │  Calls  │                 │
│  SwiftUI View   │ ◄─────► │  AuthViewModel / VM  │ ──────► │ Service / Core  │
│  (Declarative)  │         │  (@ObservableObject) │         │ (NetworkManager)│
└─────────────────┘         └──────────────────────┘         └─────────────────┘
                                       │                              │
                                Updates│                       Fetches│
                                       ▼                              ▼
                            ┌──────────────────────┐         ┌─────────────────┐
                            │    Domain Model      │ ◄────── │ Firebase Cloud  │
                            │ (User, Doctor, Appt) │         │ Firestore / API │
                            └──────────────────────┘         └─────────────────┘
```

- **Models**: Immutable Swift structs adhering to `Identifiable`, `Codable`, and `Sendable`.
- **ViewModels**: Classes conforming to `ObservableObject` handling state mutations on the `@MainActor`.
- **Views**: Declarative SwiftUI structures reacting purely to ViewModel state changes.
- **Core / Services**: Singleton or injected network managers and storage abstractions.

For comprehensive architectural details and diagrams, consult [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md).

---

## 🌿 Branching Conventions

MediConnect follows standard **GitHub Flow / Git Flow** branching practices to ensure code quality and traceability:

### Branch Structure

| Branch | Purpose | Protection Rules |
|---|---|---|
| `main` | Production-ready, stable, releasable codebase. | Direct commits forbidden; requires PR approval. |
| `develop` | Integration branch for upcoming sprint features. | Direct commits forbidden; requires CI pass. |
| `feature/<name>` | New features or components (e.g., `feature/appointment-booking`). | Branched from `develop`, merged via PR. |
| `bugfix/<name>` | Bug fixes during development (e.g., `bugfix/auth-token-refresh`). | Branched from `develop`, merged via PR. |
| `release/<version>` | Release candidate preparation (e.g., `release/v1.0.0`). | Branched from `develop`, merged into `main` and `develop`. |
| `hotfix/<name>` | Urgent production patches (e.g., `hotfix/crash-on-launch`). | Branched from `main`, merged into `main` and `develop`. |

### Commit Message Conventions

All commits **must** follow the [Conventional Commits](https://www.conventionalcommits.org/) specification:

```
<type>(<optional scope>): <description>
```

#### Allowed Types:
- `feat:` A new feature or user-facing enhancement.
- `fix:` A bug fix.
- `docs:` Documentation changes only (e.g., README, architecture guides).
- `style:` Formatting, whitespace, or visual styling without logic change.
- `refactor:` Code restructuring that neither fixes a bug nor adds a feature.
- `perf:` Performance improvements.
- `test:` Adding, refactoring, or updating tests.
- `chore:` Maintenance tasks, dependency updates, `.gitignore`, or tooling changes.

#### Examples:
```bash
# Correct:
feat(auth): implement biometric login with FaceID
fix(appointment): correct timezone offset in booking date picker
docs(readme): update development environment setup guidelines
chore(git): add Firebase credentials to .gitignore

# Incorrect:
updated code
WIP
fixed bug
commit 2
```

---

## 🤝 Contribution Guidelines

We welcome contributions to MediConnect! Please follow this workflow:

1. **Fork or Clone**: Ensure your local copy is up to date with `main`.
2. **Create a Feature Branch**:
   ```bash
   git checkout -b feature/appointment-rescheduling
   ```
3. **Develop & Adhere to Standards**:
   - Follow the [Swift API Design Guidelines](https://www.swift.org/documentation/api-design-guidelines/).
   - Keep views modular; extract complex subviews into reusable components.
   - Do not use force unwrapping (`!`); use `guard let` or `if let`.
   - Never commit sensitive files, credentials, or personal keys.
4. **Test Your Changes**: Verify that the project builds cleanly without warnings and all unit tests pass.
5. **Commit with Conventional Commits**:
   ```bash
   git commit -m "feat(appointment): add appointment rescheduling sheet"
   ```
6. **Push and Open a Pull Request**:
   ```bash
   git push origin feature/appointment-rescheduling
   ```
7. **PR Review**: Provide a clear PR description detailing motivation, changes, and testing steps. A code review is required before merging.

For full coding standards and review checklists, refer to [docs/DEVELOPMENT_STANDARDS.md](docs/DEVELOPMENT_STANDARDS.md).

---

## 🔒 Security & Secrets Management

MediConnect handles healthcare and personal data. Strict security practices must be maintained:

- **Never Commit Secrets**: `GoogleService-Info.plist`, `.env` files, certificates (`*.p12`, `*.cer`), and private keys must never be staged or committed.
- **Git Ignore Safeguard**: The repository includes a hardened `.gitignore` covering all Xcode user data, build artifacts, and sensitive configuration.
- **Token Storage**: Authentication tokens and sensitive user credentials must be stored exclusively in the iOS **Keychain**, never in `UserDefaults`.
- **Data Privacy**: MediConnect is designed with HIPAA/GDPR health privacy awareness. Sensitive health information must not be logged to console in release builds.

---

## 🗺️ Roadmap

- [x] Initial repository setup and Git workflow configuration
- [x] Core architecture scaffolding (MVVM, NetworkManager, Constants)
- [x] Domain data models (User, Doctor, Appointment, Message)
- [x] Authentication flows (Login, Sign-Up, AuthViewModel)
- [x] Main Tab Navigation (Home, Appointments, Messages, Profile)
- [ ] Firebase Authentication integration
- [ ] Cloud Firestore real-time doctor listings and search
- [ ] Interactive appointment booking flow
- [ ] Real-time in-app consultation chat
- [ ] Telemedicine video consultation (WebRTC integration)
- [ ] Medical records file upload & secure cloud storage
- [ ] Push notifications for appointment reminders (APNs)
- [ ] Dark Mode and Dynamic Type accessibility support

---

## 📄 License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.

---

## 👩‍💻 Author

**Felicia** — [@felicia-sand](https://github.com/felicia-sand)

<p align="center">
  <sub>Built with ❤️ using Swift, SwiftUI, and Firebase</sub>
</p>
