# Flutter Architecture & Testing Lab
![Coverage](https://img.shields.io/badge/coverage-86%25-brightgreen)
![CI](https://github.com/SEU_USERNAME/flutter-architecture-testing-lab/actions/workflows/flutter_ci.yml/badge.svg)

A production-oriented Flutter project demonstrating Clean Architecture, Riverpod-based state management, and a comprehensive testing strategy.

This project was built to showcase engineering maturity, architectural clarity, and real-world testability practices in Flutter applications.

---

## 🎯 Purpose

The goal of this repository is to demonstrate:

- Clean Architecture separation (Domain, Data, Presentation)
- Test-driven thinking
- Layer isolation and dependency inversion
- Riverpod as dependency injection
- Proper error handling using Failure abstractions
- Unit, ViewModel, and Widget testing strategies
- Maintainable and scalable structure

This is not a UI-focused project — it is an architecture and testing showcase.

---

## 🏗 Architecture Overview

The project strictly follows Clean Architecture principles:

lib/
  core/
    error/
  features/auth/
    domain/
    data/
    presentation/

### 🔹 Domain Layer
- Pure Dart
- No Flutter dependencies
- Contains:
  - Entities
  - Repository contracts
  - Use cases

### 🔹 Data Layer
- Implements repository contracts
- Simulates network layer
- Converts models ↔ entities
- Handles infrastructure logic

### 🔹 Presentation Layer
- Riverpod-based state management
- UI logic separated from business rules
- Exposes reactive state:
  - `isLoading`
  - `user`
  - `errorMessage`

### 🔹 Core Layer
- Centralized Failure handling
- Shared abstractions

---

## 🔄 Authentication Flow

1. UI triggers login
2. ViewModel calls `LoginUser` use case
3. Use case calls repository contract
4. Repository implementation simulates network call
5. Result is mapped to UI state

Valid credentials:

Email: test@test.com  
Password: 123456

Invalid credentials return an `AuthFailure`.

A simulated network delay is included to mimic real-world behavior.

---

## 🧪 Testing Strategy

This project includes multiple levels of testing:

### ✅ Unit Tests
- `LoginUser` use case
- Repository behavior (mocked dependencies)
- ViewModel state transitions

### ✅ Widget Test
- Login screen interaction
- User input simulation
- Success and failure UI validation

### Test Coverage Includes:
- Success scenarios
- Failure scenarios
- State transitions
- UI updates after async calls

Run tests with:

flutter test

Generate coverage:

flutter test --coverage

---

## 🛠 Tech Stack

- Flutter
- Riverpod
- Clean Architecture
- Mocktail
- Flutter Test Framework

---

## 🧠 Engineering Principles Applied

- Separation of concerns
- Dependency inversion
- Single responsibility principle
- Testable design
- Explicit error modeling
- Predictable state management

---

## 📌 Why This Project Matters

Many Flutter projects focus only on UI.

This repository demonstrates:

- Architecture-first thinking
- Production-ready structure
- Scalability considerations
- Professional testing discipline

It represents how I structure real-world applications to ensure long-term maintainability and reliability.

---

## 🚀 Future Improvements

- CI integration with GitHub Actions
- Coverage badge
- Flavor-based configuration
- Integration tests
- Logging abstraction layer

---

## 📫 Author

Yan Felipe Grando  
Senior Mobile Engineer  
Flutter | iOS | Fullstack | AI-Oriented Engineering
