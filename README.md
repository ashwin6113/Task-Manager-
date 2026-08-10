# Smart Task Manager

A production-grade, enterprise-ready Flutter application built with Clean Architecture, robust state management, and modern design standards.

---

## 🏗️ Architecture Overview

The project is structured following **Clean Architecture** principles to separate concerns, make testing simpler, and ensure the codebase scales. 

```
lib/
├── main.dart                          # App Entrypoint
├── core/                              # Low-level framework/cross-cutting infrastructure
│   ├── config/                        # Environment config loader (dev, uat, prod)
│   ├── constants/                     # Constant strings, route pathways, secure keys
│   ├── error/                         # Custom Exception hierarchy
│   ├── extensions/                    # Platform/type utility extensions
│   ├── network/                       # DioClient, request handlers, and Interceptors
│   ├── router/                        # GoRouter declarative configuration
│   ├── services/                      # Base adapters (Hive, Connectivity, Storage)
│   ├── theme/                         # Material 3 typography, tokens, & ThemeExtensions
│   └── utils/                         # Reusable core utilities (e.g. UseCase base class)
├── features/                          # Domain-focused, isolated feature modules
│   └── auth/                          # Authentication feature skeleton
│       ├── data/                      # Repositories & Datasources (API / Hive / Secure)
│       ├── domain/                    # Entities, Repositories definitions, & Use Cases
│       └── presentation/              # Pages, scoped Riverpod controllers, & UI widgets
└── shared/                            # Global UI widgets, common buttons, and layouts
```

---

## ⚙️ Environment Configuration

The app supports dynamic multi-environment configuration (Development, UAT, and Production) using external JSON resource files.

### Configuration Files
Located in `environment/`:
- `dev.json`
- `uat.json`
- `prod.json`

Each file specifies properties such as `apiUrl`, `webUrl`, and `version`.

### Running/Building the App
Pass the compile-time `ENV` string matching the target config file:

```bash
# Run in development environment
flutter run --dart-define=ENV=dev

# Run in UAT environment
flutter run --dart-define=ENV=uat

# Build for production environment
flutter build apk --dart-define=ENV=prod
```

---

## 📡 Network & Token Lifecycle Strategy

The application integrates a custom `DioClient` pipeline tailored for production workloads:

- **Unified Error Handling**: The `ErrorInterceptor` intercepts REST faults, automatically converting them to domain exceptions like `NetworkException` or `ServerException`.
- **Token Refresh Queue**: If a request fails with a `401 Unauthorized` code, the `AuthInterceptor` holds subsequent calls in a queue via `QueuedInterceptor`, triggers a token refresh using a single shared Future token request (preventing concurrent token refresh storms), and replays the queued HTTP calls.
- **Console Log Output**: Requests, responses, and errors are cleanly logged using the `logger` library inside the `LoggingInterceptor`.

---

## 🎨 Theme & Tokens

The UI is built on a custom design system centered on Material 3:
- **Seed Theme**: Light & dark schemes are generated dynamically using `ColorScheme.fromSeed`.
- **Design Tokens**: Standardized spacings, border radii, and icon sizes are managed under `AppSpacing`, `AppRadius`, and `AppSizes`.
- **Custom Color Extension**: Custom colors like `success`, `warning`, and `shimmerBase` are implemented as a `ThemeExtension` via `AppColors` for cross-platform visual consistency.
