# Backend – Ilia Users

This document describes the backend architecture, folder structure, technical decisions, and possible future improvements.

The backend is a RESTful API built with Node.js and TypeScript, designed to be lightweight yet robust, ensuring data integrity and clear business rules.

---

# 🏗 Architecture

The backend follows a layered architecture with clear separation of responsibilities:

- Routes → Define HTTP endpoints
- Controllers → Handle request validation and orchestration
- Services → Contain business logic and database interaction
- Database Layer → Managed via Prisma ORM

The design prioritizes:

- Simplicity aligned with project scope
- Explicit validation and error handling
- Testability
- Clean separation between layers

---

## 📂 Project Structure

```text
backend/
├── prisma/                 # Database Layer (Prisma ORM)
│    ├── migrations/        # Version control for database schema
│    ├── dev.db             # Local SQLite database file
│    └── schema.prisma      # Data models and database configuration
│
├── src/                    # Source Code
│    ├── controllers/       # Interface Layer (Request/Response handling)
│    │     └── users.controller.ts
│    ├── routes/            # Route Definitions
│    │     └── users.routes.ts
│    ├── services/          # Business Logic Layer
│    │     └── users.service.ts
│    ├── tests/             # Integration Tests (Jest + Supertest)
│    │     └── users.test.ts
│    └── server.ts          # Express App and Server initialization
│
├── .env                    # Environment variables
├── jest.config.ts          # Testing configuration
├── package.json            # Scripts and dependencies
└── tsconfig.json           # TypeScript configuration
```

---

# 📌 Layer Responsibilities

## 🔹 server.ts

- Express application configuration
- Middleware setup (CORS, JSON parsing)
- Route registration
- Server bootstrap

---

## 🔹 routes/

Defines HTTP endpoints and delegates logic to controllers.

Example:

- `GET /users`
- `POST /users`

---

## 🔹 controllers/

Responsible for:

- Input validation (Zod)
- Calling service layer
- Mapping service results to HTTP responses
- Handling specific HTTP status codes

No database logic exists in controllers.

---

## 🔹 services/

Contains business logic and database operations.

- Communicates with Prisma ORM
- No HTTP logic
- No request validation

This separation allows easy unit testing of business logic.

---

## 🔹 prisma/

Database configuration and migrations.

### Database

- SQLite was chosen for simplicity.
- No external setup required.
- Easy for evaluators to run.

### Schema

The `User` model:

```bash
model User {
    id Int @id @default(autoincrement())
    name String
    email String @unique
    }
```


The `email` field has a UNIQUE constraint, ensuring data integrity at the database level.

---

# 🔒 Validation Strategy

Request validation is performed using **Zod** in the controller layer.

Example:

- Required fields
- Email format validation
- HTTP 400 returned for invalid input

This ensures invalid data never reaches the database.

---

# ❗ Error Handling Strategy

The backend explicitly handles:

- HTTP 400 → Invalid request data
- HTTP 409 → Duplicate email (database constraint)
- HTTP 500 → Unexpected server errors

Duplicate email detection leverages Prisma error codes (`P2002`).

Errors are not swallowed and are clearly mapped to HTTP status codes.

---

# 🧪 Testing Strategy

The backend includes integration tests using:

- Jest
- Supertest

Tests validate:

- Successful user creation
- Duplicate email handling (409)
- Validation errors (400)
- User listing
- End-to-end behavior (controller → service → database)

Tests run against a real SQLite database.

---

# 🎯 Technical Decisions

## 1️⃣ Express 4 (Stable Version)

Express 4 was chosen over Express 5 to ensure stability and avoid experimental behavior.

---

## 2️⃣ Prisma ORM

Chosen for:

- Type safety
- Migrations support
- Clean schema definition
- Easy integration with SQLite

---

## 3️⃣ SQLite Database

Selected for:

- Zero external dependencies
- Easy setup for evaluators
- File-based persistence

In a production scenario, this could be replaced with PostgreSQL.

---

## 4️⃣ Clear Separation of Layers

Avoids mixing:

- HTTP concerns
- Business logic
- Database logic

Improves maintainability and testability.

---

## 5️⃣ Explicit Error Mapping

HTTP errors are mapped intentionally, avoiding generic 500 responses where possible.

---

# 🚀 Possible Improvements

While the current implementation is intentionally simple, the following improvements could be made:

- Introduce a global error handler middleware
- Add logging middleware (Winston or Pino)
- Add request ID tracing
- Implement DTO pattern
- Introduce environment-based configuration
- Replace SQLite with PostgreSQL for scalability
- Add Docker configuration
- Add CI/CD pipeline
- Add OpenAPI/Swagger documentation
- Implement pagination and filtering

---

# 📌 Summary

This backend prioritizes:

- Explicit validation
- Explicit error handling
- Testability
- Simplicity aligned with scope

The goal was to demonstrate architectural clarity rather than overengineering.