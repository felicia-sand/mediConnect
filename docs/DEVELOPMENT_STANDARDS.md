# MediConnect iOS — Development Standards & Guidelines 📋

This document outlines the engineering standards, Git workflow, coding conventions, and quality gates for contributors to the **MediConnect iOS** project.

---

## 🌿 Git Workflow & Branching Strategy

MediConnect uses a structured branching strategy to maintain stability on production while supporting rapid feature delivery.

### 1. Branch Hierarchy

| Branch | Base | Target | Description |
|---|---|---|---|
| `main` | — | — | Production-ready, locked branch. Releases are tagged from here. |
| `develop` | `main` | `main` | Integration branch for current sprint features. |
| `feature/<name>` | `develop` | `develop` | New features or components. |
| `bugfix/<name>` | `develop` | `develop` | Fixes for issues identified during development. |
| `release/<version>`| `develop` | `main` & `develop` | Final validation and version bumps before deployment. |
| `hotfix/<name>` | `main` | `main` & `develop` | Emergency production patches. |

### 2. Branch Naming Rules

- Use lowercase kebab-case for branch names.
- Prefix with the branch type:
  - `feature/doctor-search-filter`
  - `feature/appointment-calendar-view`
  - `bugfix/auth-session-expiry`
  - `hotfix/crash-on-ios17-launch`

---

## 📝 Commit Conventions

All commits must follow the **Conventional Commits** specification:

```
<type>(<optional scope>): <description>
```

### Commit Types

- `feat`: A new feature or capability.
- `fix`: A bug fix or patch.
- `docs`: Documentation updates only.
- `style`: Formatting, spacing, or visual adjustments with no code logic impact.
- `refactor`: Code modifications that neither fix bugs nor add new features.
- `perf`: Code optimizations to enhance speed or memory usage.
- `test`: Adding or correcting tests.
- `chore`: Build configuration, `.gitignore`, dependency updates, or toolchain changes.

### Golden Rules for Commits

1. **Imperative Mood**: Use imperative verbs ("add", "implement", "fix", not "added", "fixing").
2. **Atomic Commits**: Each commit should represent one logical change.
3. **Never Fabricate Commits**: Commit only genuine, verified changes.
4. **No Secrets in History**: Verify `git status` and staged files before committing.

---

## 💻 Swift & SwiftUI Coding Standards

### 1. Swift API Design Guidelines
- Conform strictly to Apple's [Swift API Design Guidelines](https://www.swift.org/documentation/api-design-guidelines/).
- Use clear, expressive naming: clarity at the point of use is prioritized over brevity.
- Types, structs, classes, and protocols use `UpperCamelCase`.
- Variables, functions, and properties use `lowerCamelCase`.

### 2. Safety & Optionals
- **Zero Force Unwrapping**: Avoid the force unwrap operator (`!`) and force casting (`as!`).
- Use `guard let` for early exits to avoid deep indentation:
  ```swift
  guard let user = currentUser else {
      showAuthenticationError()
      return
  }
  ```
- Provide sensible defaults using nil-coalescing (`??`) where appropriate.

### 3. SwiftUI Best Practices
- **Extract Subviews**: Keep `var body: some View` under 50 lines. Extract complex components into private subviews or dedicated reusable views.
- **State Management**:
  - Use `@State` strictly for local, private view-level state.
  - Use `@StateObject` to instantiate ViewModels owned by the view.
  - Use `@ObservedObject` when passing an existing ViewModel down the hierarchy.
  - Use `@EnvironmentObject` for app-wide shared state (e.g., `AuthViewModel`).
- **Main Thread Execution**: All ViewModels interacting with SwiftUI state must annotate classes or published handlers with `@MainActor`.

### 4. Concurrency
- Utilize modern Swift Structured Concurrency (`async`/`await`, `Task`).
- Avoid deprecated completion-handler callback pyramids.
- Cancel long-running tasks on view disappearance using `.task { }` view modifiers.

---

## 🔒 Security & Privacy Standards

1. **Protected Credentials**:
   - `GoogleService-Info.plist`, `.env` files, and private keys must **never** be committed.
   - Any sensitive configurations should be managed via environment variables or secure configuration templates.
2. **Keychain for Tokens**:
   - Authentication tokens, session identifiers, and user passwords must be stored in the iOS Keychain.
   - `UserDefaults` must only be used for non-sensitive user preferences (e.g., dark mode toggle, notification preferences).
3. **Zero Health Data Logging**:
   - Never print sensitive medical records, patient names, or consultation notes to the console in release configurations.

---

## 🔍 Pull Request (PR) Quality Gate

Before submitting a Pull Request, verify:

- [ ] Project builds cleanly with **0 compiler warnings**.
- [ ] No extraneous files or local configuration staged.
- [ ] Code follows Swift indentation (4 spaces) and naming conventions.
- [ ] Branch is rebased onto the latest `develop` branch.
- [ ] Unit tests cover new business logic and pass reliably.
- [ ] PR description details the changes, motivation, and verification steps.
