# Mobile Application – Ilia Users

This document describes the mobile architecture, folder structure, and technical decisions made for the Flutter application.

---

# 🏗 Architecture

The mobile application follows a feature-based architecture inspired by Flutter Official case study: https://docs.flutter.dev/app-architecture/case-study, but more simplified and adapted to the scope of the challenge.

The goal was to ensure:

- Clear separation of responsibilities
- Predictable state management
- Explicit error handling
- Testability
- Simplicity aligned with production practices

State management is handled using **Bloc**.

---

## 📂 Project Structure

The mobile application follows a modular and layer-based architecture (Clean Architecture inspired), ensuring that business logic, data handling, and UI components are decoupled and testable.

```text
lib/
├── core/                       # Shared infrastructure and cross-cutting concerns
│   ├── design_system/          # UI Foundation (Theme, Colors, Reusable Widgets)
│   │   ├── theme/              # AppTheme and AppColors
│   │   └── widgets/            # Generic UI components (e.g., UIButton, UIText)
│   ├── di/                     # Dependency Injection (GetIt configuration)
│   │   └── injector.dart
│   ├── network/                # HTTP abstraction layer
│   │   ├── response/           # Global app exceptions and failure models
│   │   └── dio_client.dart     # Dio wrapper with centralized configuration
│   └── utils/                  # Reusable utilities
│       └── validators.dart     # Form validation logic (email, minLength, required)
│
├── features/                   # Business modules (feature-based architecture)
│   └── users/                  # User management feature
│       ├── data/               # Data Layer (Models and Repository implementation)
│       │   ├── models/
│       │   └── repositories/
│       ├── view/               # UI Layer (Screens, Widgets, and Modals)
│       └── viewmodel/          # State Management (Events, States, Bloc)
│
├── l10n/                       # Localization files (ARB format)
│   ├── app_en.arb              # English translations
│   └── app_pt.arb              # Portuguese translations
│
└── main.dart                   # Application entry point and global configuration
```
---

# 📌 Folder Responsibilities

## 🔹 core/

Contains shared infrastructure and reusable components.

### design_system/
Reusable UI elements and theme configuration.

### di/
Dependency injection setup using GetIt.

### network/
- Dio client configuration
- Interceptors
- Timeout handling
- HTTP error mapping

---

## 🔹 features/users/

Feature-based organization.

### data/
- `models/` → Data models
- `repositories/` → Repository implementations and contracts

### view/
UI layer (screens, modals, widgets).

### viewmodel/
Bloc, events, and state definitions.

---

# 🔄 State Management

The application uses **Bloc** for predictable and testable state management.

### Events

- `GetUsers`
- `AddUser`

### State
enum UserStatus { initial, loading, success, failed }


State contains:

- `status`
- `users`
- `errorMessage`

---

# 🧠 Event Responsibility Design

Special attention was given to separation of responsibilities.

### AddUser

- Responsible only for creating a user
- On success, triggers `GetUsers`
- Does not manage list state directly

### GetUsers

- Responsible for:
  - Loading users
  - Managing loading state
  - Managing failure state
  - Updating user list

This avoids mixing concerns and prevents UI inconsistencies.

---

# 🌐 Networking Layer

The app uses **Dio** as HTTP client.

Features:

- Base URL configuration
- Timeout configuration
- Interceptors for logging
- HTTP status handling (including 409)

Errors are converted into domain failures before reaching the UI layer.

---

# ❗ Error Handling Strategy

The app explicitly handles:

- Network errors
- HTTP 409 (duplicate email)
- Validation failures

No silent failures are allowed.

Backend error codes are mapped to user-friendly messages.

---

# 💉 Dependency Injection

Dependency injection is managed using **GetIt**.

All repositories and bloc instances are registered centrally in:

core/di/injector.dart


This ensures:

- Testability
- Loose coupling
- Easy mocking

---

# 🧪 Testing Strategy

The mobile application includes unit tests for:

- UserModel
- UserRepository
- UserBloc

Testing pattern used:

- AAA (Arrange, Act, Assert)

Bloc tests validate:

- State transitions
- Error handling
- Event sequencing

---

# 🎯 Design Decisions

### 1️⃣ Feature-based architecture
Chosen for scalability and separation of concerns.

### 2️⃣ Explicit error handling
Avoids silent failures and improves debuggability.

### 3️⃣ Single Responsibility per Event
Each Bloc event handles one responsibility.

### 4️⃣ Production-aligned simplicity
The architecture mirrors real-world production practices while keeping the solution concise.

---

# 🚀 Possible Improvements (Future Work)

- Migration to sealed states for stronger type safety
- Pagination support
- Offline caching
- CI integration
