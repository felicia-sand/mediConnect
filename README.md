# MediConnect 🏥

**MediConnect** is a modern iOS healthcare application built with **Swift & SwiftUI** that bridges the gap between patients and doctors — enabling seamless appointment booking, virtual consultations, and health record management.

---

## 📱 Features

- 🔐 **Secure Authentication** — Sign up/login for patients and doctors
- 📅 **Appointment Booking** — Browse doctors and schedule appointments with ease
- 💬 **In-App Messaging** — Direct communication between patients and doctors
- 📋 **Medical Records** — Securely store and share health records
- 🎥 **Telemedicine** — Virtual consultations via video call
- 🔔 **Smart Notifications** — Appointment reminders and health alerts
- 📊 **Health Dashboard** — Track vitals, history, and upcoming visits

---

## 🛠️ Tech Stack

| Layer | Technology |
|---|---|
| Language | Swift 5.9+ |
| UI Framework | SwiftUI |
| Architecture | MVVM (Model-View-ViewModel) |
| Networking | URLSession + Async/Await |
| Local Storage | CoreData / SwiftData |
| Authentication | Firebase Auth |
| Backend | Firebase Firestore |
| Notifications | Apple Push Notification Service (APNs) |
| Minimum iOS | iOS 17.0+ |

---

## 📁 Project Structure

```
mediConnect/
├── mediConnectApp.swift          # App entry point
├── Assets.xcassets/              # Images, colors, icons
├── Info.plist                    # App configuration
│
├── Core/
│   ├── Network/                  # API clients, endpoints
│   ├── Storage/                  # CoreData/SwiftData models
│   ├── Extensions/               # Swift extensions
│   └── Utilities/                # Helpers, constants
│
├── Features/
│   ├── Authentication/
│   │   ├── Views/                # Login, Signup screens
│   │   └── ViewModels/           # Auth logic
│   ├── Dashboard/
│   │   ├── Views/                # Home, feed screens
│   │   └── ViewModels/           # Dashboard logic
│   ├── Appointments/
│   │   ├── Views/                # Booking, schedule screens
│   │   └── ViewModels/           # Appointment logic
│   ├── Doctors/
│   │   ├── Views/                # Doctor listing, profile
│   │   └── ViewModels/           # Doctor data logic
│   ├── Messaging/
│   │   ├── Views/                # Chat screens
│   │   └── ViewModels/           # Message logic
│   └── Profile/
│       ├── Views/                # User profile, settings
│       └── ViewModels/           # Profile logic
│
├── Models/
│   ├── User.swift                # User data model
│   ├── Doctor.swift              # Doctor data model
│   ├── Appointment.swift         # Appointment model
│   └── Message.swift             # Chat message model
│
└── Resources/
    ├── Fonts/                    # Custom fonts
    └── Localizations/            # Localization files
```

---

## 🚀 Getting Started

### Prerequisites

- macOS 14.0+
- Xcode 15.0+
- iOS 17.0+ Simulator or physical device
- CocoaPods or Swift Package Manager

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/felicia-sand/mediConnect.git
   cd mediConnect
   ```

2. **Open in Xcode**
   ```bash
   open mediConnect.xcodeproj
   ```

3. **Configure Firebase**
   - Create a Firebase project at [console.firebase.google.com](https://console.firebase.google.com)
   - Download `GoogleService-Info.plist` and add it to the project
   - Enable Authentication and Firestore in Firebase console

4. **Build & Run**
   - Select your target simulator or device
   - Press `⌘ + R` to build and run

---

## 🏗️ Architecture

MediConnect follows the **MVVM (Model-View-ViewModel)** pattern:

```
View  ←→  ViewModel  ←→  Model
 ↓              ↓
SwiftUI      Business      Data
 Views         Logic       Layer
```

- **Models** — Plain Swift structs/classes representing data
- **ViewModels** — `@ObservableObject` classes handling business logic & state
- **Views** — Pure SwiftUI views that react to ViewModel state changes

---

## 🗺️ Roadmap

- [x] Project setup & architecture
- [ ] Authentication (Login / Sign Up)
- [ ] Doctor listing & search
- [ ] Appointment booking flow
- [ ] In-app messaging
- [ ] Video consultation (WebRTC)
- [ ] Medical records upload
- [ ] Push notifications
- [ ] Dark mode support
- [ ] iPad support

---

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📄 License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.

---

## 👩‍💻 Author

**Felicia** — [@felicia-sand](https://github.com/felicia-sand)

---

<p align="center">Made with ❤️ using Swift & SwiftUI</p>
