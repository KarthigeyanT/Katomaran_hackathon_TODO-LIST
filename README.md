# Katomaran Hackathon - TODO List App

A Flutter-based task management application with Facebook authentication.

## 🚀 Features

- 🔐 Secure Facebook Authentication
- 📝 Task Management
- 📅 Due Date Tracking
- 📎 File Attachments
- 📱 Responsive Design

## 🛠️ Setup Instructions

### Prerequisites
- Flutter SDK (latest stable version)
- Android Studio / Xcode (for emulator/simulator)
- Facebook Developer Account
- Firebase Project

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/KarthigeyanT/Katomaran_hackathon_TODO-LIST.git
   cd Katomaran_hackathon_TODO-LIST
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Set up environment**
   - Copy `.env.example` to `.env`
   - Update the values in `.env` with your Facebook App credentials
   - Run the setup script:
     - On Windows: `./setup_env.ps1`
     - On macOS/Linux: `chmod +x setup_env.sh && ./setup_env.sh`

4. **Run the app**
   ```bash
   flutter run
   ```

## 🔒 Security Notice

This project uses environment variables to manage sensitive information. Never commit your `.env` file to version control.

## 🏗️ System Architecture

```mermaid
graph TD
    %% UI Layer
    UI[📱 UI Layer]
    UI -->|State Management| Provider[🔄 Provider State Management]
    
    %% Services Layer
    Provider --> Auth[🔐 Authentication]
    Provider --> TaskService[📋 Task Service]
    Provider --> Logger[📝 Logger Service]
    
    %% Authentication
    Auth -->|Uses| Facebook[🔵 Facebook Graph API]
    Auth -->|Uses| FirebaseAuth[🔥 Firebase Authentication]
    
    %% Data Layer
    TaskService -->|Read/Write| LocalDB[💾 Local Database]
    TaskService -->|Sync| CloudDB[☁️ Cloud Firestore]
    
    %% Logging
    Logger -->|Logs to| Console[💻 Console]
    Logger -->|Saves to| LogStorage[📂 Log Files]
    
    %% Styling
    classDef ui fill:#4285F4,stroke:#1A73E8,color:white,rounded:10px
    classDef service fill:#34A853,stroke:#1E8E3E,color:white,rounded:10px
    classDef auth fill:#EA4335,stroke:#D23F31,color:white,rounded:10px
    classDef storage fill:#FBBC05,stroke:#F9AB00,color:black,rounded:10px
    classDef external fill:#9C27B0,stroke:#7B1FA2,color:white,rounded:10px
    
    class UI,Provider ui
    class Auth,TaskService,Logger service
    class Facebook,FirebaseAuth auth
    class LocalDB,CloudDB,LogStorage storage
    class Console external
```

## 🎯 Project Scope & Requirements

### Core Features
- **User Authentication**
  - Facebook Login via Graph API
  - Email/Password fallback authentication
  - Secure session management

- **Task Management**
  - Create, Read, Update, Delete tasks
  - Task categories and priorities
  - Due date tracking with notifications

- **Data Management**
  - Offline-first architecture
  - Real-time cloud sync
  - Local data persistence

- **Logging & Monitoring**
  - Comprehensive event logging
  - Error tracking and reporting
  - Debug information capture

### Technical Requirements
- **Frontend**: Flutter (Dart)
- **State Management**: Provider
- **Authentication**: Firebase Auth + Facebook Graph API
- **Database**: Cloud Firestore with local caching
- **Logging**: Custom logger with file persistence
- **Platforms**: Android, iOS, Web (responsive design)

## 📄 License

This project is a part of a hackathon run by [Katomaran](https://www.katomaran.com)

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
