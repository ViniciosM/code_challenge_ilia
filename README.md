# Code Challenge Ilia

Fullstack application for user registration and listing.

This project is composed of:

- 📱 Mobile application (Flutter)
- 🌐 Backend API (Node.js + Express + Prisma)

---

## 📌 Overview

The system allows:

- Creating users (name and email)
- Listing registered users
- Preventing duplicate emails (HTTP 409)
- Proper frontend error handling
- Basic automated testing (mobile and backend)

The project was intentionally built focusing on:

- Clear separation of responsibilities
- Explicit error handling
- Predictable state management
- Simplicity without overengineering
- Testability

---

## 🛠 Tech Stack

### Mobile
- Flutter
- Bloc (state management)
- Dio (HTTP client)
- GetIt (dependency injection)
- Equatable
- bloc_test (unit testing)

### Backend
- Node.js
- Express
- Prisma ORM
- SQLite
- Zod (request validation)
- Jest + Supertest (integration testing)

---

## ⚙️ Prerequisites

Before running the project, make sure you have the following installed:

### 1️⃣ Node.js
- Download and install from [nodejs.org](https://nodejs.org/)
- Recommended: **Node 18+**
- Verify: `node -v` | `npm -v`

### 2️⃣ Flutter
- Follow the official guide: [docs.flutter.dev](https://docs.flutter.dev/get-started/install)
- Verify: `flutter doctor`

### 3️⃣ Git
- Download from [git-scm.com](https://git-scm.com/)
- Verify: `git --version`

---

### 🚀 How to Run the Project

Clone the repository:

git clone <repository-url>
cd code_challenge_ilia

## 🌐 Backend Setup

```bash
cd backend
npm install
npx prisma migrate dev
npm run dev
```

The server will run at:
http://localhost:3000

You can test it with:
curl http://localhost:3000/users

## 📱 Mobile Setup
```bash
cd mobile
flutter pub get
flutter run
```

## ⚠️ Important for Android Emulator:

Since the backend runs on HTTP (not HTTPS), Android requires enabling cleartext traffic.

Open:
 mobile/android/app/src/main/AndroidManifest.xml

Inside the <application> tag, add:
```bash
<application
    android:usesCleartextTraffic="true"
    ... >
```

Make sure the base URL is:

http://10.0.2.2:3000

For iOS Simulator:

http://localhost:3000

### 🧪 Running Tests

## Backend
```bash
 backend
 npm test
 ```
## Mobile
 ```bash
 cd mobile
 flutter test
 ```

 ## 📸 Evidences
 

 | App | Bacend |
| :---: | :---: |
| <img src="https://github.com/user-attachments/assets/2aefedc1-4e80-4506-9db5-f656090d9b3c" height="600"> | <img src="https://github.com/user-attachments/assets/57deb560-b971-4f75-a6c9-0c8d214b8ae1" height="600"> |


 
