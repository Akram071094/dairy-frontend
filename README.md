# dairy-frontend

MindFleet Dairy — Flutter mobile-first application for Dairy Distribution Intelligence Platform.

## Architecture

- **State Management**: Provider + ChangeNotifier
- **Routing**: go_router
- **Networking**: Dio with auth interceptors
- **Storage**: flutter_secure_storage + shared_preferences
- **Design**: FRD-110 — Onboarding Frontend System Design

## Project Structure

```
lib/
├── main.dart                     # Entry point with provider setup
├── core/                         # Foundation layer
│   ├── constants/                # API endpoints, app constants, UI constants
│   ├── theme/                    # Colors, typography, dimensions, theme
│   ├── network/                  # API client, interceptors, exceptions
│   ├── router/                   # GoRouter configuration
│   └── utils/                    # Validators, extensions
├── shared/                       # Reusable widgets
│   └── widgets/
│       ├── buttons/              # Primary, secondary, ghost buttons
│       ├── inputs/               # Text field, dropdown, color picker, upload
│       ├── display/              # AI avatar, progress ring, cards, timeline
│       ├── feedback/             # Loading overlay, success, dialogs
│       └── layout/               # Section divider, bottom action panel
├── features/                     # Feature modules
│   ├── auth/                     # Login, signup, auth provider
│   └── onboarding/               # Action center, step screens, provider
└── animations/                   # Entrance, loading, success animations
```

## Getting Started

1. Ensure Flutter 3.2+ is installed
2. Run `dart run build_runner build` (for code generation)
3. Run `flutter pub get`
4. Run `flutter run`

## Onboarding Flow

The onboarding experience is designed as an AI-guided Action Center (FRD-110):

1. **Splash** → Auth check
2. **Welcome** → AI introduction
3. **Login / Sign Up** → Authentication
4. **Action Center** → AI-guided onboarding hub
5. **Business Setup** → Register organization
6. **Business Profile** → Business details
7. **Branding** → Brand identity
8. **Preferences** → Business configuration
9. **Review & Activate** → Confirmation
10. **Complete** → Celebration & transition

## Backend

This frontend consumes the dairy-backend API at `http://localhost:8000/api/v1/`. Configure the base URL in `lib/core/constants/api_constants.dart`.
