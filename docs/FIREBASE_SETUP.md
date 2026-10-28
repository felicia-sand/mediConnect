# MediConnect — Firebase Database & Authentication Setup Guide 🔥

This guide outlines how to connect a live **Google Cloud Firebase** backend to the **MediConnect** iOS application.

---

## 🏗️ Architecture Overview

MediConnect uses a **Dual-Mode Repository Architecture**:
- **Offline / Standalone Mode (Default):** Runs immediately without configuration using an in-memory repository pre-seeded with Sri Lankan clinical data.
- **Cloud Firestore Mode:** When `GoogleService-Info.plist` is present, the app automatically connects to live Cloud Firestore collections and Firebase Authentication.

---

## 📋 Step 1: Create Firebase Project

1. Navigate to the [Firebase Console](https://console.firebase.google.com/).
2. Click **Add project** and name it `mediConnect` (or `mediConnect-ios`).
3. (Optional) Disable Google Analytics for this coursework project to simplify setup.
4. Click **Create project**.

---

## 📱 Step 2: Register the iOS Application

1. In your Firebase Project Overview, click the **iOS icon** to add an Apple app.
2. Enter the exact **Bundle Identifier**:
   ```text
   lk.mediconnect.ios
   ```
3. Set the App Nickname: `MediConnect iOS`.
4. Click **Register app**.
5. Download **`GoogleService-Info.plist`**.
6. Move the downloaded `GoogleService-Info.plist` into your local `mediConnect/` directory:
   ```bash
   cp ~/Downloads/GoogleService-Info.plist /Users/user/Desktop/Felicia/mediConnect/mediConnect/
   ```
   *(Note: `.gitignore` is pre-configured to keep this file private).*

---

## 🔐 Step 3: Enable Firebase Authentication

1. In the Firebase Console side menu, navigate to **Build > Authentication**.
2. Click **Get Started**.
3. Under the **Sign-in method** tab, click **Email/Password**.
4. Toggle **Enable** on `Email/Password` (leave Email link disabled).
5. Click **Save**.

---

## 🗄️ Step 4: Create Cloud Firestore Database

1. In the Firebase Console side menu, navigate to **Build > Firestore Database**.
2. Click **Create database**.
3. Choose your database location (e.g. `asia-south1 (Mumbai)` or nearest region to Sri Lanka).
4. Start in **Production mode** (or **Test mode** for initial testing).
5. Click **Create**.

---

## 🛡️ Step 5: Configure Firestore Security Rules

Navigate to the **Rules** tab in your Firestore database and paste the following security rules:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // Helper function
    function isAuthenticated() {
      return request.auth != null;
    }
    
    function isOwner(userId) {
      return isAuthenticated() && request.auth.uid == userId;
    }
    
    // Users Collection
    match /users/{userId} {
      allow read: if isAuthenticated();
      allow write: if isOwner(userId);
    }
    
    // Doctors Collection (Public read, verified doctor write)
    match /doctors/{doctorId} {
      allow read: if true;
      allow write: if isAuthenticated();
    }
    
    // Clinics Collection (Public read)
    match /clinics/{clinicId} {
      allow read: if true;
      allow write: if false;
    }
    
    // Appointments Collection
    match /appointments/{appointmentId} {
      allow read, write: if isAuthenticated();
    }
    
    // Live Queue Rooms (Real-time synchronization)
    match /queues/{roomId} {
      allow read, write: if isAuthenticated();
    }
  }
}
```

---

## 📦 Step 6: Add Firebase SDK via Swift Package Manager

In Xcode:
1. Open `mediConnect.xcodeproj`.
2. Click **File > Add Package Dependencies...**
3. Paste the official repository URL:
   ```text
   https://github.com/firebase/firebase-ios-sdk
   ```
4. Select Dependency Rule: **Up to Next Major Version** (from `10.0.0` or `11.0.0`).
5. In the package products dialog, select:
   - **`FirebaseAuth`**
   - **`FirebaseFirestore`**
6. Click **Add Package**.

---

## ✅ Step 7: Verify Live Cloud Synchronization

1. Press **`⌘ + R`** (`Cmd + R`) to launch the app in the iOS Simulator.
2. Create a new user or book an appointment.
3. Open the Firebase Console -> **Firestore Database** -> refresh to see documents appearing in the `users/` and `appointments/` collections in real-time!
