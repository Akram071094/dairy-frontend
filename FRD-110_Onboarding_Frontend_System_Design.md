# FRD-110 — Onboarding Frontend System Design

| Field | Value |
|-------|-------|
| Document ID | FRD-110 |
| Title | Onboarding Frontend System Design |
| Category | Frontend Design Document |
| Version | 1.0.0 |
| Status | Draft |
| Owner | Frontend Architecture Team |
| Applies To | Onboarding Experience (MindFleet Dairy) |
| Related Documents | API-110, API-120, BC-110, BC-120, DM-110, DM-120 |

---

## Section 1 — High-Level User Journey

### 1.1 Journey Overview

The onboarding experience transforms a陌生的 distributor into a fully operational MindFleet Dairy user. The journey is designed as a conversational AI-guided flow — never a form-filling exercise.

```
Launch App
    │
    ▼
Welcome Screen — AI Assistant Introduction
    │
    ▼
Login / Sign Up (email + password + org code)
    │
    ▼
┌─────────────────────────────────────────────────┐
│              AI ACTION CENTER                    │
│  "Good morning, Akram! Let's set up your         │
│   dairy business. Here's what we need today..." │
└─────────────────────────────────────────────────┘
    │
    ├── Step 1: Business Registration
    │       └── Business name, code, contact, address
    │
    ├── Step 2: Business Profile
    │       └── Registration numbers, tax info, employee count
    │
    ├── Step 3: Branding
    │       └── Colors, logo, business identity
    │
    ├── Step 4: Preferences
    │       └── Working days, hours, credit terms, invoice prefix
    │
    └── Step 5: Review & Activate
            └── Confirmation → Activation → Success
    │
    ▼
Onboarding Complete — Transition to Application Home
```

### 1.2 User-Facing Narrative

- **First Launch**: User opens the app for the first time. They see a warm, minimal welcome screen. An AI assistant character introduces itself: "Hi! I'm Mia, your MindFleet business assistant. I'll help you get your dairy distribution business up and running."

- **Account Creation**: User enters email, password, and organization code (if provided by an existing business owner). They can also sign up without an org code to create a new organization.

- **AI Action Center**: After authentication, the user lands on the Action Center. This is the single hub for all onboarding activities. Mia greets them and presents the next recommended step.

- **Business Setup**: Mia guides the user through registering their business — name, business code, contact details, address. Each field group is presented as a conversation card, not a form.

- **Business Profile**: Mia asks for business registration details, tax information, employee count. Optional fields are marked as "We can add this later."

- **Branding**: The user picks primary/secondary colors and uploads a logo. Mia shows a live preview of how their brand will look.

- **Preferences**: Mia asks about working days, hours, credit terms. These are presented as simple choices, not complex configuration.

- **Review & Activate**: Mia presents a summary of everything entered. User confirms. One tap to activate. A celebration animation plays.

- **Transition**: The app transitions from onboarding mode to full application mode. Mia says: "Your business is live! Here's your dashboard."

---

## Section 2 — Frontend Screen Flow

### 2.1 Screen Inventory

| # | Screen | Purpose | Trigger | APIs Used | Navigation Rules | Exit Conditions |
|---|--------|---------|---------|-----------|-----------------|-----------------|
| 1 | **Splash** | App launch, check auth status | App open | GET /me | → Welcome if no token / token expired → Action Center if valid token | Auto-navigate after check |
| 2 | **Welcome** | AI introduction, app value prop | Splash (unauthenticated) | None | → Login (tap "I have an account") → Signup (tap "Get Started") | User taps CTA |
| 3 | **Login** | Authenticate existing user | Welcome → Login | POST /auth/login | → Action Center (success) → Welcome (back) | Auth success or back |
| 4 | **Sign Up** | Create new account | Welcome → Get Started | POST /auth/signup | → Action Center (success) → Welcome (back) | Auth success or back |
| 5 | **Action Center** | Onboarding hub, AI-guided | Auth success, screen close | GET /onboarding-status | → Business Setup (step 1) → Profile (step 2) → Branding (step 3) → Preferences (step 4) → Review (step 5) | All steps complete → Onboarding Complete |
| 6 | **Business Setup** | Register organization | Action Center → Step 1 | POST /organizations | → Action Center (success) → Action Center (back) | Step completed or cancelled |
| 7 | **Business Profile** | Business details | Action Center → Step 2 | POST /organizations/{id}/profile | → Action Center (success) → Action Center (back) | Step completed or skipped |
| 8 | **Branding** | Brand identity | Action Center → Step 3 | POST /organizations/{id}/branding | → Action Center (success) → Action Center (back) | Step completed or skipped |
| 9 | **Preferences** | Business preferences | Action Center → Step 4 | POST /organizations/{id}/preferences | → Action Center (success) → Action Center (back) | Step completed or skipped |
| 10 | **Review** | Summary & confirmation | Action Center → Step 5 | GET /organizations/{id} | → Activate (confirm) → Action Center (edit) | Confirmed or edit |
| 11 | **Onboarding Complete** | Success celebration | POST /organizations/{id}/activate | POST /organizations/{id}/activate | → Application Home (auto) | Auto-transition after animation |

### 2.2 Screen Flow Diagram

```
┌─────────┐
│  Splash  │
└────┬─────┘
     │ (no token)
     ▼
┌─────────┐
│ Welcome  │
└────┬─────┘
     │
     ├── "Get Started" ───────→ ┌─────────┐
     │                          │ Sign Up  │
     │                          └────┬─────┘
     │                               │ success
     ├── "I have an account" ──→ ┌─────────┐
     │                           │  Login   │
     │                           └────┬─────┘
     │                                │ success
     └────────────────────────────────┘
                                      │
                                      ▼
                              ┌────────────────┐
                              │ Action Center  │◄────┐
                              └───┬────┬────┬──┘    │
                                  │    │    │        │
                    ┌─────────────┘    │    └──────────────┐
                    ▼                  ▼                   ▼
            ┌──────────────┐  ┌──────────────┐   ┌──────────────┐
            │ Business     │  │ Business     │   │ Branding     │
            │ Setup (Step1)│  │ Profile (S2) │   │ (Step 3)     │
            └──────┬───────┘  └──────┬───────┘   └──────┬───────┘
                   │                 │                   │
                   └─────────────────┼───────────────────┘
                                     │
                                     ▼
                            ┌────────────────┐
                            │ Preferences    │
                            │ (Step 4)       │
                            └───────┬────────┘
                                    │
                                    ▼
                            ┌────────────────┐
                            │    Review      │
                            │ (Step 5)       │
                            └───────┬────────┘
                                    │ confirm
                                    ▼
                            ┌────────────────────┐
                            │ Onboarding Complete │
                            └────────────────────┘
                                    │
                                    ▼
                            ┌────────────────┐
                            │  App Home      │
                            └────────────────┘
```

---

## Section 3 — Action Center Design

### 3.1 Layout Structure

The Action Center is a single, scrollable screen. No tabs, no drawers, no bottom navigation.

```
┌─────────────────────────────────────────┐
│  ┌─────────────────────────────────┐    │
│  │       HERO SECTION              │    │
│  │  ┌──────┐  ┌──────────────────┐ │    │
│  │  │ Mia  │  │ "Good morning!   │ │    │
│  │  │avatar│  │  Let's set up    │ │    │
│  │  │      │  │  your dairy      │ │    │
│  │  │ 🐄   │  │  business."      │ │    │
│  │  └──────┘  └──────────────────┘ │    │
│  └─────────────────────────────────┘    │
│                                         │
│  ┌─────────────────────────────────┐    │
│  │   PROGRESS SECTION              │    │
│  │   [●●●●○○○○]  3/5 steps done  │    │
│  │   "You're 60% there!"           │    │
│  └─────────────────────────────────┘    │
│                                         │
│  ┌─────────────────────────────────┐    │
│  │   NEXT RECOMMENDED ACTION       │    │
│  │  ┌───────────────────────────┐  │    │
│  │  │ 🎯 Business Profile      │  │    │
│  │  │ Add your registration    │  │    │
│  │  │ details to continue.     │  │    │
│  │  │ [Continue →]             │  │    │
│  │  └───────────────────────────┘  │    │
│  └─────────────────────────────────┘    │
│                                         │
│  ┌─────────────────────────────────┐    │
│  │   ACTIVITY TIMELINE             │    │
│  │  ✅ Business Setup — Done      │    │
│  │  ⏳ Business Profile — Pending │    │
│  │  ⏳ Branding — Pending         │    │
│  │  ⏳ Preferences — Pending      │    │
│  │  ⏳ Activation — Pending       │    │
│  └─────────────────────────────────┘    │
│                                         │
│  ┌─────────────────────────────────┐    │
│  │   QUICK ACTIONS                 │    │
│  │  [Edit Business] [Skip Profile]│    │
│  └─────────────────────────────────┘    │
└─────────────────────────────────────────┘
```

### 3.2 State Transitions

| Completed Steps | Hero Message | Progress | Next Action |
|----------------|--------------|----------|-------------|
| None | "Welcome! Let's register your business first." | 0/5 (0%) | Business Setup |
| Step 1 | "Great! Business is registered. Now let's add your business profile." | 1/5 (20%) | Business Profile |
| Steps 1-2 | "Excellent! Profile is set. Let's make it yours with some branding." | 2/5 (40%) | Branding |
| Steps 1-3 | "Looking good! Let's configure your business preferences." | 3/5 (60%) | Preferences |
| Steps 1-4 | "Almost there! Review everything and activate your business." | 4/5 (80%) | Review & Activate |
| All | "Your business is live! 🎉" | 5/5 (100%) | Transition to Home |

---

## Section 4 — API Mapping

### 4.1 Authentication APIs

#### POST /api/v1/auth/signup

| Field | Value |
|-------|-------|
| **Purpose** | Create new user account |
| **Trigger Screen** | Sign Up |
| **Request** | `{ email, password, first_name, last_name }` |
| **Response** | `{ access_token, refresh_token, token_type, expires_in, user }` |
| **Loading State** | "Creating your account..." with pulse animation on button |
| **Success State** | Auto-navigate to Action Center; store tokens securely |
| **Failure State** | Show inline error: "This email is already registered" or "Something went wrong. Please try again." |
| **Next Navigation** | → Action Center (GET /onboarding-status) |

#### POST /api/v1/auth/login

| Field | Value |
|-------|-------|
| **Purpose** | Authenticate existing user |
| **Trigger Screen** | Login |
| **Request** | `{ email, password, organization_code? }` |
| **Response** | `{ access_token, refresh_token, token_type, expires_in, user, organization }` |
| **Loading State** | "Signing you in..." with shimmer on button |
| **Success State** | Store tokens; navigate to Action Center |
| **Failure State** | "Incorrect email or password." or "Account is not active." |
| **Next Navigation** | → Action Center |

#### GET /api/v1/auth/me

| Field | Value |
|-------|-------|
| **Purpose** | Validate stored token on app launch |
| **Trigger Screen** | Splash |
| **Request** | Headers: `Authorization: Bearer <token>` |
| **Response** | `{ id, email, first_name, last_name, status }` |
| **Loading State** | Splash screen with app logo animation |
| **Success State** | → Action Center |
| **Failure State** | → Welcome Screen (clear stored tokens) |
| **Next Navigation** | → Action Center or Welcome |

### 4.2 Organization APIs

#### POST /api/v1/organizations

| Field | Value |
|-------|-------|
| **Purpose** | Register a new dairy distributor organization |
| **Trigger Screen** | Business Setup |
| **Request** | `{ business_code, display_name, legal_name?, gst_number?, fssai_license_number?, business_type?, primary_contact_name?, primary_contact_email?, primary_contact_phone?, country?, state?, city?, address?, postal_code?, timezone, currency, language }` |
| **Response** | `{ id, business_code, display_name, status, ... }` |
| **Loading State** | "Registering your business..." with document animation |
| **Success State** | Store organization ID; update Action Center step 1 complete |
| **Failure State** | "This business code is already taken." or "Please check your information and try again." |
| **Next Navigation** | → Back to Action Center (step 1 marked complete) |

#### POST /api/v1/organizations/{organization_id}/profile

| Field | Value |
|-------|-------|
| **Purpose** | Add business profile details |
| **Trigger Screen** | Business Profile |
| **Request** | `{ registration_number?, tax_identification_number?, industry_classification?, year_established?, employee_count?, annual_revenue?, website_url? }` |
| **Response** | `{ id, organization_id, ... }` |
| **Loading State** | "Saving business profile..." |
| **Success State** | Action Center step 2 complete |
| **Failure State** | "Could not save profile. Please try again." |
| **Next Navigation** | → Back to Action Center |

#### POST /api/v1/organizations/{organization_id}/branding

| Field | Value |
|-------|-------|
| **Purpose** | Set brand identity |
| **Trigger Screen** | Branding |
| **Request** | `{ primary_color?, secondary_color?, logo_url?, favicon_url? }` |
| **Response** | `{ id, organization_id, ... }` |
| **Loading State** | "Applying your brand..." |
| **Success State** | Action Center step 3 complete |
| **Failure State** | "Could not save branding. Please try again." |
| **Next Navigation** | → Back to Action Center |

#### POST /api/v1/organizations/{organization_id}/preferences

| Field | Value |
|-------|-------|
| **Purpose** | Configure business preferences |
| **Trigger Screen** | Preferences |
| **Request** | `{ working_days?, working_hours_start?, working_hours_end?, financial_year_start_month?, default_credit_days?, invoice_prefix?, ... }` |
| **Response** | `{ id, organization_id, ... }` |
| **Loading State** | "Saving your preferences..." |
| **Success State** | Action Center step 4 complete |
| **Failure State** | "Could not save preferences. Please try again." |
| **Next Navigation** | → Back to Action Center |

#### POST /api/v1/organizations/{organization_id}/activate

| Field | Value |
|-------|-------|
| **Purpose** | Activate organization for business operations |
| **Trigger Screen** | Review (confirm button) |
| **Request** | None |
| **Response** | `{ id, status: "active", updated_at }` |
| **Loading State** | "Activating your business..." with celebration build-up |
| **Success State** | → Onboarding Complete with success animation |
| **Failure State** | "Activation failed. Please ensure all steps are complete." |
| **Next Navigation** | → Onboarding Complete → App Home |

#### GET /api/v1/organizations/{organization_id}/onboarding-status

| Field | Value |
|-------|-------|
| **Purpose** | Check current onboarding progress |
| **Trigger Screen** | Action Center (on load and after each step) |
| **Request** | Path: organization_id |
| **Response** | `{ organization_id, steps: { create_organization, business_profile, branding, preferences, activation }, current_step, is_complete }` |
| **Loading State** | Progress ring pulse animation |
| **Success State** | Update Action Center state |
| **Failure State** | Show cached progress; retry silently |
| **Next Navigation** | Update UI only |

#### GET /api/v1/organizations/{organization_id}

| Field | Value |
|-------|-------|
| **Purpose** | Fetch full organization data for review |
| **Trigger Screen** | Review |
| **Request** | Path: organization_id |
| **Response** | `{ id, business_code, display_name, legal_name, gst_number, fssai_license_number, business_type, ..., status }` |
| **Loading State** | "Loading your business details..." |
| **Success State** | Populate review screen |
| **Failure State** | "Could not load details. Please try again." |
| **Next Navigation** | Review screen populated |

---

## Section 5 — UI State Machine

### 5.1 Global State Machine

```
                    ┌─────────────┐
                    │   IDLE      │
                    └──────┬──────┘
                           │ user action
                           ▼
                    ┌─────────────┐
                    │  LOADING    │◄────── retry
                    └──────┬──────┘
                           │
                    ┌──────┴──────┐
                    │             │
                    ▼             ▼
             ┌──────────┐  ┌──────────┐
             │  SUCCESS  │  │  FAILURE │
             └────┬─────┘  └────┬─────┘
                  │             │
                  ▼             │
           ┌─────────────┐      │
           │ PREVIEW/CONF│      │
           └──────┬──────┘      │
                  │ confirm     │ retry/dismiss
                  ▼             │
           ┌─────────────┐      │
           │  COMPLETED   │     │
           └──────┬──────┘      │
                  │             │
                  ▼             ▼
           ┌─────────────┐  ┌─────────────┐
           │ TRANSITION   │  │    IDLE     │
           └─────────────┘  └─────────────┘
```

### 5.2 Per-Step State Machine

```
┌──────────────┐
│  NOT STARTED │  (step not yet attempted)
└──────┬───────┘
       │ user taps "continue"
       ▼
┌──────────────┐
│  IN PROGRESS │  (user filling details)
└──────┬───────┘
       │ user taps "save"
       ▼
┌──────────────┐
│  VALIDATING  │  (client-side validation)
└──────┬───────┘
       │ valid
       ▼
┌──────────────┐
│  SUBMITTING  │  (API call in progress)
└──────┬───────┘
       │
    ┌──┴──┐
    │     │
    ▼     ▼
┌──────┐ ┌──────────┐
│ DONE │ │  ERROR   │
└──────┘ └────┬─────┘
              │ retry
              ▼
         ┌──────────────┐
         │  IN PROGRESS │
         └──────────────┘
```

---

## Section 6 — Component Hierarchy

### 6.1 Splash Screen

```
SplashScreen
├── AppLogo (animated entrance)
├── AppName (fade in)
└── LoadingIndicator (subtle bottom)
```

### 6.2 Welcome Screen

```
WelcomeScreen
├── Top Art (illustration area)
├── AIAssistantAvatar (Mia character)
├── TitleText ("Welcome to MindFleet Dairy")
├── SubtitleText (value proposition)
├── PrimaryButton ("Get Started")
├── SecondaryButton ("I have an account")
└── FooterText (version, terms link)
```

### 6.3 Login Screen

```
LoginScreen
├── BackButton
├── TitleText ("Welcome back")
├── SubtitleText ("Sign in to continue")
├── EmailField
├── PasswordField
├── PrimaryButton ("Sign In")
├── SecondaryLink ("Forgot password?")
├── DividerWithText ("or")
└── FooterLink ("Don't have an account? Sign up")
```

### 6.4 Sign Up Screen

```
SignUpScreen
├── BackButton
├── TitleText ("Create your account")
├── SubtitleText ("Join MindFleet Dairy")
├── FirstNameField
├── LastNameField
├── EmailField
├── PasswordField
├── ConfirmPasswordField
├── PrimaryButton ("Create Account")
└── FooterLink ("Already have an account? Sign in")
```

### 6.5 Action Center

```
ActionCenter
├── HeroSection
│   ├── AIAssistantAvatar (Mia)
│   ├── GreetingText (dynamic, time + name based)
│   └── StatusMessage ("Let's set up your business!")
├── ProgressSection
│   ├── ProgressRing (circular percentage)
│   ├── StepCounter ("3/5 steps done")
│   └── EncouragementText ("You're 60% there!")
├── NextActionCard
│   ├── ActionIcon (contextual)
│   ├── ActionTitle
│   ├── ActionDescription
│   ├── ActionButton ("Continue →" or "Start →")
│   └── SkipLink ("Skip for now")
├── ActivityTimeline
│   ├── TimelineStep (completed — checkmark)
│   ├── TimelineStep (current — highlighted)
│   ├── TimelineStep (pending — dimmed)
│   └── TimelineStep (pending — dimmed)
└── QuickActions
    ├── GhostButton ("Edit Business")
    └── GhostButton ("Skip Profile")
```

### 6.6 Business Setup Screen

```
BusinessSetupScreen
├── BackButton
├── TitleSection
│   ├── AssistantAvatar (small)
│   ├── StepIndicator ("Step 1 of 5")
│   └── AIPrompt ("Let's register your business.")
├── FormCard
│   ├── SectionHeader ("Business Identity")
│   ├── BusinessCodeField (with validation hint)
│   ├── DisplayNameField
│   ├── LegalNameField
│   ├── BusinessTypeDropdown
│   ├── SectionHeader ("Contact Information")
│   ├── PrimaryContactNameField
│   ├── PrimaryContactEmailField
│   ├── PrimaryContactPhoneField
│   ├── SectionHeader ("Address")
│   ├── CountryField
│   ├── StateField
│   ├── CityField
│   ├── AddressField
│   ├── PostalCodeField
│   ├── SectionHeader ("Configuration")
│   ├── TimezoneDropdown
│   ├── CurrencyDropdown
│   └── LanguageDropdown
├── BottomActions
│   ├── PrimaryButton ("Register Business")
│   └── SecondaryButton ("Save Draft")
```

### 6.7 Business Profile Screen

```
BusinessProfileScreen
├── BackButton
├── TitleSection
│   ├── AssistantAvatar (small)
│   ├── StepIndicator ("Step 2 of 5")
│   └── AIPrompt ("Tell us about your business registration.")
├── FormCard
│   ├── RegistrationNumberField
│   ├── TaxIdField
│   ├── IndustryClassificationField
│   ├── YearEstablishedPicker
│   ├── EmployeeCountField
│   ├── AnnualRevenueField
│   └── WebsiteUrlField
├── BottomActions
│   ├── PrimaryButton ("Save Profile")
│   └── SecondaryButton ("Skip for now")
```

### 6.8 Branding Screen

```
BrandingScreen
├── BackButton
├── TitleSection
│   ├── AssistantAvatar
│   ├── StepIndicator ("Step 3 of 5")
│   └── AIPrompt ("Let's make your business look great!")
├── ColorSection
│   ├── ColorPickerCard ("Primary Color")
│   └── ColorPickerCard ("Secondary Color")
├── LogoSection
│   ├── UploadCard ("Upload Logo")
│   └── UploadCard ("Upload Favicon")
├── PreviewSection
│   ├── BrandPreviewCard (live preview)
│   └── BrandNamePreview
├── BottomActions
│   ├── PrimaryButton ("Save Branding")
│   └── SecondaryButton ("Skip for now")
```

### 6.9 Preferences Screen

```
PreferencesScreen
├── BackButton
├── TitleSection
│   ├── AssistantAvatar
│   ├── StepIndicator ("Step 4 of 5")
│   └── AIPrompt ("Configure how your business operates.")
├── FormCard
│   ├── WorkingDaysSelector (multi-select chips)
│   ├── WorkingHoursStartPicker
│   ├── WorkingHoursEndPicker
│   ├── FiscalYearStartPicker
│   ├── DefaultCreditDaysField
│   ├── InvoicePrefixField
│   └── CollectionPreferencesToggle (expandable)
├── BottomActions
│   ├── PrimaryButton ("Save Preferences")
│   └── SecondaryButton ("Skip for now")
```

### 6.10 Review Screen

```
ReviewScreen
├── BackButton
├── TitleSection
│   ├── AssistantAvatar
│   ├── StepIndicator ("Step 5 of 5")
│   └── AIPrompt ("Review everything before we go live.")
├── SummaryCard
│   ├── ReviewSection ("Business Info")
│   │   ├── ReviewRow (label, value, edit button)
│   │   └── ReviewRow (label, value, edit button)
│   ├── ReviewSection ("Business Profile")
│   │   └── ReviewRow...
│   ├── ReviewSection ("Branding")
│   │   └── ReviewRow...
│   └── ReviewSection ("Preferences")
│       └── ReviewRow...
└── BottomActions
    └── PrimaryButton ("Activate Business 🚀")
```

### 6.11 Onboarding Complete Screen

```
OnboardingCompleteScreen
├── SuccessAnimation (large celebration)
├── TitleText ("Your business is live! 🎉")
├── SubtitleText ("You're all set to start distributing dairy.")
├── AIAvatar (Mia smiling)
├── MiaMessage ("I'll be here to help you every step of the way.")
├── StatCards
│   ├── StatCard ("Business Registered")
│   ├── StatCard ("Profile Completed")
│   ├── StatCard ("Branding Set")
│   └── StatCard ("Preferences Configured")
└── PrimaryButton ("Go to Dashboard")
```

---

## Section 7 — Widget Reuse Strategy

### 7.1 Reusable Widgets

| Widget | Used In | Props |
|--------|---------|-------|
| `PrimaryButton` | All screens | `label, onTap, isLoading, icon` |
| `SecondaryButton` | All screens | `label, onTap, isLoading` |
| `GhostButton` | Action Center, Preference screens | `label, onTap` |
| `AIAssistantAvatar` | Welcome, Action Center, all step screens | `size, mood (smiling/thinking/celebrating)` |
| `AIPrompt` | All step screens | `message, stepNumber, totalSteps` |
| `ProgressRing` | Action Center | `progress, size, strokeWidth` |
| `ActionCard` | Action Center | `icon, title, description, buttonLabel, onTap` |
| `TimelineStep` | Action Center | `label, status (completed/current/pending), isLast` |
| `FormCard` | All step screens | `children, padding` |
| `FormSectionHeader` | All form screens | `title, icon` |
| `AppTextField` | All form screens | `label, hint, controller, validator, keyboardType` |
| `DropdownField` | Business Setup, Preferences | `label, items, value, onChanged` |
| `ColorPickerCard` | Branding | `label, color, onColorChanged` |
| `UploadCard` | Branding | `label, fileUrl, onUpload, onRemove` |
| `BrandPreviewCard` | Branding | `primaryColor, secondaryColor, logoUrl, businessName` |
| `ReviewSection` | Review | `title, items, onEdit` |
| `ReviewRow` | Review | `label, value, onEdit` |
| `StepIndicator` | All step screens | `currentStep, totalSteps` |
| `LoadingOverlay` | All screens | `message, animationType` |
| `SuccessAnimation` | Onboarding Complete | `onComplete` |
| `ErrorDialog` | All screens | `title, message, onRetry, onDismiss` |
| `ConfirmationDialog` | Review | `title, message, onConfirm, onCancel` |
| `StatCard` | Onboarding Complete | `icon, label, value` |
| `SectionDivider` | All screens | `label` |

### 7.2 Shared Widget Package

```
lib/shared/widgets/
├── buttons/
│   ├── primary_button.dart
│   ├── secondary_button.dart
│   ├── ghost_button.dart
│   └── icon_button.dart
├── inputs/
│   ├── app_text_field.dart
│   ├── dropdown_field.dart
│   ├── color_picker_card.dart
│   └── upload_card.dart
├── display/
│   ├── ai_assistant_avatar.dart
│   ├── ai_prompt.dart
│   ├── progress_ring.dart
│   ├── action_card.dart
│   ├── timeline_step.dart
│   ├── form_card.dart
│   ├── form_section_header.dart
│   ├── brand_preview_card.dart
│   ├── review_section.dart
│   ├── review_row.dart
│   ├── step_indicator.dart
│   └── stat_card.dart
├── feedback/
│   ├── loading_overlay.dart
│   ├── success_animation.dart
│   ├── error_dialog.dart
│   └── confirmation_dialog.dart
└── layout/
    ├── section_divider.dart
    └── bottom_action_panel.dart
```

---

## Section 8 — API Interaction Flow

### 8.1 Sign Up Flow

```
User Action              UI                    API
───────────              ──                    ───
Tap "Create Account" → Button loading state
                        "Creating your account..."
                        Email field disabled
                        Password field disabled
                                             POST /auth/signup
                                             { email, password,
                                               first_name, last_name }
                        │                       │
                        ▼                       ▼
                  ┌─────┴──────┐
                  │            │
            SUCCESS           FAILURE
                  │            │
                  ▼            ▼
           Store tokens    Show inline error
           Navigate to    "This email is already
           Action Center  registered."
                          Enable fields
                          User can retry
```

### 8.2 Organization Create Flow

```
User Action              UI                    API
───────────              ──                    ───
Tap "Register Business" → Button loading state
                          "Registering your business..."
                          All fields disabled
                                             POST /organizations
                                             { business_code,
                                               display_name, ... }
                        │                       │
                        ▼                       ▼
                  ┌─────┴──────┐
                  │            │
            SUCCESS           FAILURE
                  │            │
                  ▼            ▼
           Store org_id    Show error banner
           Mark step 1     "Could not register
           complete        business"
           Navigate to     Enable fields
           Action Center   User can retry
```

### 8.3 General API Pattern

All onboarding API calls follow this pattern:

```
User Action
    │
    ▼
Validate Input (client-side)
    │
    ├── Invalid → Show field errors → User corrects → Retry
    │
    └── Valid
        │
        ▼
Show Loading State (disable inputs, show spinner + message)
    │
    ▼
Execute API Call
    │
    ├── Success (2xx)
    │   ├── Parse response
    │   ├── Update local state (provider/bloc)
    │   ├── Show brief success feedback (haptic + subtle checkmark)
    │   └── Navigate or update UI
    │
    ├── Validation Error (422)
    │   ├── Parse error details
    │   ├── Map to field-level errors
    │   └── Show inline on relevant fields
    │
    ├── Auth Error (401/403)
    │   ├── Clear tokens
    │   └── Navigate to Login
    │
    ├── Server Error (5xx)
    │   ├── Show error dialog with retry
    │   └── Log error
    │
    └── Network Error
        ├── Show offline banner
        └── Auto-retry on connection restore
```

---

## Section 9 — Upload Workflow Design

### 9.1 Logo Upload Flow

```
User taps "Upload Logo"
    │
    ▼
System image picker opens
    │
    ▼
User selects image
    │
    ▼
Client-side validation:
  ├── File type (PNG, JPG, SVG)
  ├── File size (< 5MB)
  ├── Dimensions check
  │
  ├── Invalid → Show error toast → User selects again
  │
  └── Valid
      │
      ▼
Show preview in UploadCard
    │
    ▼
"Compressing image..."
    │
    ▼
Upload to server / CDN
    │
    ├── Success → Store URL → Update preview
    │
    └── Failure → Show "Upload failed. Tap to retry."
```

### 9.2 Future Upload Workflows (not yet implemented)

For template-based uploads (products, retailers, etc.), the flow would be:

```
Download Template (CSV/XLSX)
    │
    ▼
User fills template
    │
    ▼
Upload File
    │
    ▼
Server-side validation
    │
    ├── Pass → Preview data
    │   └── User approves → Submit → Complete
    │
    └── Fail → Show error rows → User corrects → Re-upload
```

---

## Section 10 — Progress Engine

### 10.1 Progress Calculation

```
completedSteps = count of true values in steps{}
totalSteps = 5
progress = (completedSteps / totalSteps) × 100
currentStep = first step that is false (or "review" if all true)
remainingSteps = totalSteps - completedSteps
```

### 10.2 Progress State

```dart
class OnboardingProgress {
  final bool orgCreated;
  final bool profileCompleted;
  final bool brandingCompleted;
  final bool preferencesCompleted;
  final bool activated;

  int get completedSteps => [orgCreated, profileCompleted, brandingCompleted, 
                              preferencesCompleted, activated].where((e) => e).length;
  int get totalSteps => 5;
  double get percentage => completedSteps / totalSteps;
  String get currentStepName => // determine from first incomplete step
  String get nextAction => // friendly label
  String get encouragementMessage => // based on percentage tier
}
```

### 10.3 Encouragement Messages by Tier

| Progress | Message |
|----------|---------|
| 0% | "Let's get started! Every journey begins with a single step." |
| 20% | "Great start! Your business is taking shape." |
| 40% | "You're making excellent progress!" |
| 60% | "More than halfway there! Keep going." |
| 80% | "Almost done! Just the final review left." |
| 100% | "Congratulations! Your business is live! 🎉" |

### 10.4 Refresh Strategy

- `GET /onboarding-status` is called:
  - On Action Center initial load
  - After every completed step (returning from step screen)
  - On app resume (from background)
- Never poll aggressively — only on navigation events
- Cache last known progress locally for offline display
- Show cached progress with "offline" indicator if network unavailable

---

## Section 11 — Error Handling Strategy

### 11.1 Error Categories

| Category | Examples | User Message | Recovery |
|----------|----------|--------------|----------|
| **Validation** | Missing required field, invalid email, business code format | Specific field error + "Please check this field." | User corrects and resubmits |
| **Duplicate** | Email taken, business code exists | "This [field] is already in use. Try a different one." | User changes value and resubmits |
| **Auth** | Invalid credentials, expired token | "Your session has expired. Please sign in again." | Navigate to Login |
| **Server** | 500, 502, 503 | "Something went wrong on our end. Please try again." | Retry button with exponential backoff |
| **Network** | No internet, timeout | "No internet connection. We'll retry automatically when you're back online." | Offline banner + auto-retry |

### 11.2 Error UI Patterns

- **Field-level errors**: Red border + message below field (validation errors)
- **Inline banner**: Below header (server errors, duplicates)
- **Full-screen error**: With retry button (network errors)
- **Dialog**: With retry and dismiss options (unexpected errors)
- **Toast**: Brief, auto-dismiss (transient errors like upload failure)

### 11.3 Business-Friendly Error Messages

| Raw Backend | User-Facing Message |
|-------------|---------------------|
| "Email already registered" | "This email is already registered. Sign in instead?" |
| "business_code must be alphanumeric" | "Business code can only contain letters and numbers." |
| "business_code must be uppercase" | "Business code should be in capital letters." |
| "Organization not found" | "We couldn't find this organization." |
| "Invalid Credentials" | "Incorrect email or password. Please try again." |
| "Account is not active" | "This account has been deactivated. Contact support." |
| "Permission Denied" | "You don't have permission to do this." |

---

## Section 12 — Loading Experience

### 12.1 Intelligent Loading Messages

| API | Loading Message | Animation |
|-----|----------------|----------|
| POST /auth/signup | "Creating your account..." | Pulsing document icon |
| POST /auth/login | "Signing you in..." | Shimmer on button |
| GET /onboarding-status | "Checking your progress..." | Progress ring pulse |
| POST /organizations | "Registering your business..." | Animated building icon |
| POST /organizations/{id}/profile | "Saving business profile..." | Data stream animation |
| POST /organizations/{id}/branding | "Applying your brand..." | Color morph animation |
| POST /organizations/{id}/preferences | "Saving preferences..." | Gear rotation animation |
| POST /organizations/{id}/activate | "Activating your business..." | Rocket climb animation |
| Logo upload | "Uploading your logo..." | Upload progress bar |

### 12.2 Loading States

- **Button loading**: Button shows spinner, label replaced with message, disabled
- **Full-screen loading**: Center spinner with contextual message, subtle background dim
- **Skeleton loading**: Placeholder shimmer for content-heavy screens
- **Progress loading**: For uploads — determinate progress bar with percentage
- **Overlay loading**: Semi-transparent overlay with spinner, blocks interaction

---

## Section 13 — Animation Strategy

### 13.1 Screen-Level Animations

| Screen | Entry | Exit | Page Transition |
|--------|-------|------|-----------------|
| Splash | Logo fade-in + scale (800ms) | Fade-out (300ms) | None |
| Welcome | Content slide-up (500ms, staggered) | Fade-out (200ms) | Slide-up from bottom |
| Login | Slide-in from right (300ms) | Slide-out to left (300ms) | Cupertino-style push |
| Sign Up | Slide-in from right (300ms) | Slide-out to left (300ms) | Cupertino-style push |
| Action Center | Content fade-in staggered (600ms) | None (persistent) | Scale-down to center |
| All Step Screens | Slide-up from bottom (350ms) | Slide-down to bottom (250ms) | Modal bottom sheet style |
| Review | Staggered card fade-in (500ms) | Fade-out (200ms) | Slide-up |
| Onboarding Complete | Scale-up celebration (1000ms) | None | Explosion → new page |

### 13.2 Component Animations

| Component | Animation |
|-----------|-----------|
| Primary Button | Scale 0.95 on press, elastic rebound |
| Action Card | Lift on hover/tap, subtle shadow increase |
| Progress Ring | Animated fill on update (800ms easeOut) |
| Timeline Step | Checkmark draw animation on completion |
| Success Animation | Confetti burst + checkmark draw (1200ms) |
| Error Shake | Horizontal shake on invalid field (300ms) |
| Card Entrance | Fade-in + slide-up (400ms, staggered by index) |
| Avatar | Subtle idle float animation (breathing) |
| Color picker | Smooth color transition on selection |

### 13.3 Animation Principles

- **Purposeful**: Every animation communicates progress or state change
- **Subtle**: 200-600ms range, ease-in-out curves, no excessive effects
- **Consistent**: Same curve (easeInOutCubic) used throughout
- **Accessible**: Respects `prefers-reduced-motion` (disable all animations)
- **Performance**: Use `AnimatedBuilder`, `Transform`, and `Opacity` only — no layout-triggering animations

---

## Section 14 — Visual Hierarchy

### 14.1 Typography Hierarchy

| Level | Font | Size | Weight | Usage |
|-------|------|------|--------|-------|
| Display | Inter | 32px | Bold (700) | Hero title on Welcome |
| H1 | Inter | 28px | SemiBold (600) | Screen titles |
| H2 | Inter | 22px | SemiBold (600) | Section headers |
| H3 | Inter | 18px | Medium (500) | Card titles |
| Body | Inter | 16px | Regular (400) | Main content |
| Body Small | Inter | 14px | Regular (400) | Descriptions, hints |
| Caption | Inter | 12px | Regular (400) | Labels, timestamps |
| Button | Inter | 16px | SemiBold (600) | All buttons |

### 14.2 Color System

| Token | Usage |
|-------|-------|
| `primary` (Blue #2563EB) | Primary buttons, active states, links |
| `primaryLight` (#DBEAFE) | Light backgrounds, highlights |
| `secondary` (Teal #0D9488) | Accents, success states |
| `surface` (#FFFFFF) | Card backgrounds, screen background |
| `surfaceDim` (#F8FAFC) | Secondary backgrounds |
| `text` (#0F172A) | Primary text |
| `textSecondary` (#64748B) | Secondary text, hints |
| `border` (#E2E8F0) | Dividers, card borders |
| `error` (#EF4444) | Error states, validation |
| `success` (#22C55E) | Success states, completed items |

### 14.3 Spacing System

| Token | Value | Usage |
|-------|-------|-------|
| `xs` | 4px | Inner card padding |
| `sm` | 8px | Between related elements |
| `md` | 16px | Between form fields |
| `lg` | 24px | Between sections |
| `xl` | 32px | Screen edge padding |
| `xxl` | 48px | Large section gaps |

### 14.4 Attention Management

- **Primary focus**: The Next Recommended Action card on Action Center (highest contrast, prominent shadow)
- **Secondary focus**: Progress ring + step counter (top-right area)
- **Tertiary focus**: Activity timeline (scrollable below)
- **CTA hierarchy**: Primary Button → Secondary Button → Ghost Link

Each step screen follows the "one thing at a time" principle:
1. AI Prompt (top) — What we're doing
2. Form Card (middle) — The inputs needed
3. Bottom Actions (bottom) — What to do next

---

## Section 15 — State Management

### 15.1 Recommended Approach: Provider + ChangeNotifier

Use `provider` package for simplicity, testability, and Flutter ecosystem compatibility.

### 15.2 State Architecture

```
┌─────────────────────────────────────────────────────┐
│                    GLOBAL STATE                       │
│  AuthState (token, user, isAuthenticated)             │
│  OnboardingState (progress, currentStep)             │
│  OrganizationState (orgId, orgData)                  │
└──────────────────────────────────────────────────────┘
                            │ provides
                            ▼
┌─────────────────────────────────────────────────────┐
│                   SCREEN STATE                        │
│  WelcomeScreenState (animation phase)                │
│  LoginScreenState (form data, validation, submit)    │
│  BusinessSetupState (form data, validation, submit)  │
│  ProfileScreenState (form data, validation, submit)  │
│  BrandingScreenState (colors, upload, preview)       │
│  PreferencesScreenState (form data, validation)      │
│  ReviewScreenState (loaded data, edit targets)       │
└──────────────────────────────────────────────────────┘
```

### 15.3 State Definitions

```dart
// Global
class AuthState extends ChangeNotifier {
  String? accessToken;
  String? refreshToken;
  UserModel? currentUser;
  bool get isAuthenticated => accessToken != null;
  // methods: login(), signup(), logout(), refreshToken()
}

class OnboardingState extends ChangeNotifier {
  OnboardingProgress progress;
  OrganizationModel? currentOrganization;
  // methods: loadProgress(), markStepComplete(), refresh()
}

// Screen-level
class BusinessSetupState extends ChangeNotifier {
  OrganizationCreate formData;
  Map<String, String?> fieldErrors;
  SubmissionStatus status; // idle, validating, submitting, success, error
  // methods: validate(), submit(), setField()
}
```

### 15.4 Data Flow

```
User Action
    │
    ▼
Widget calls Provider method
    │
    ▼
Provider updates state, sets loading=true
    │
    ▼
Provider calls Service (API)
    │
    ▼
Service returns result
    │
    ├── Success → Provider updates state, sets loading=false, notifies listeners
    │
    └── Failure → Provider sets error state, notifies listeners
    │
    ▼
Widget rebuilds, shows updated UI
```

### 15.5 Caching Strategy

- **Tokens**: `flutter_secure_storage` (encrypted)
- **Onboarding progress**: In-memory + `shared_preferences` (cached)
- **Organization data**: In-memory during session
- **Form drafts**: `shared_preferences` per step (auto-save every 5s)

### 15.6 Refresh Strategy

- **Action Center**: Refresh `onboarding-status` on every navigation to it
- **Token**: Auto-refresh on 401 response via interceptor
- **Form data**: Not refreshed (single-session entry)
- **App resume**: Refresh `onboarding-status` from background

---

## Section 16 — Folder Structure

### 16.1 Recommended Flutter Project Structure

```
lib/
├── main.dart                          # App entry point, provider setup
├── app.dart                           # MaterialApp, theme, router
│
├── core/
│   ├── constants/
│   │   ├── api_constants.dart         # Base URL, endpoint paths
│   │   ├── app_constants.dart         # App name, version, timeouts
│   │   └── ui_constants.dart          # Animation durations, spacing tokens
│   ├── theme/
│   │   ├── app_theme.dart             # ThemeData, ColorScheme
│   │   ├── app_colors.dart            # Color constants
│   │   ├── app_typography.dart        # TextTheme
│   │   └── app_dimensions.dart        # Spacing, radii, sizes
│   ├── network/
│   │   ├── api_client.dart            # Dio instance, base config
│   │   ├── api_interceptors.dart      # Auth, logging, retry interceptors
│   │   └── api_exceptions.dart        # Custom exception classes
│   ├── router/
│   │   └── app_router.dart            # GoRouter configuration
│   └── utils/
│       ├── validators.dart            # Email, password, field validators
│       ├── extensions.dart            # String, context extensions
│       └── logger.dart                # Logging utility
│
├── shared/
│   ├── providers/
│   │   └── auth_provider.dart         # Global auth state
│   └── widgets/
│       ├── buttons/
│       │   ├── primary_button.dart
│       │   ├── secondary_button.dart
│       │   ├── ghost_button.dart
│       │   └── icon_button.dart
│       ├── inputs/
│       │   ├── app_text_field.dart
│       │   ├── dropdown_field.dart
│       │   ├── color_picker_card.dart
│       │   └── upload_card.dart
│       ├── display/
│       │   ├── ai_assistant_avatar.dart
│       │   ├── ai_prompt.dart
│       │   ├── progress_ring.dart
│       │   ├── action_card.dart
│       │   ├── timeline_step.dart
│       │   ├── form_card.dart
│       │   ├── form_section_header.dart
│       │   ├── brand_preview_card.dart
│       │   ├── review_section.dart
│       │   ├── review_row.dart
│       │   ├── step_indicator.dart
│       │   └── stat_card.dart
│       └── feedback/
│           ├── loading_overlay.dart
│           ├── success_animation.dart
│           ├── error_dialog.dart
│           └── confirmation_dialog.dart
│
├── features/
│   ├── auth/
│   │   ├── models/
│   │   │   └── auth_models.dart       # UserModel, LoginRequest, SignupRequest
│   │   ├── services/
│   │   │   └── auth_service.dart      # Auth API calls
│   │   ├── providers/
│   │   │   ├── auth_provider.dart     # Auth state management (or in shared)
│   │   │   └── login_provider.dart    # Login form state
│   │   └── screens/
│   │       ├── welcome_screen.dart
│   │       ├── login_screen.dart
│   │       └── signup_screen.dart
│   │
│   └── onboarding/
│       ├── models/
│       │   ├── organization_model.dart    # Organization, OrgCreate, OrgProfile
│       │   ├── onboarding_status.dart     # OnboardingProgress
│       │   └── branding_model.dart        # Branding, ColorModel
│       ├── services/
│       │   └── onboarding_service.dart    # All onboarding API calls
│       ├── providers/
│       │   ├── onboarding_provider.dart   # Global onboarding state
│       │   ├── business_setup_provider.dart
│       │   ├── business_profile_provider.dart
│       │   ├── branding_provider.dart
│       │   ├── preferences_provider.dart
│       │   └── review_provider.dart
│       ├── screens/
│       │   ├── action_center_screen.dart
│       │   ├── business_setup_screen.dart
│       │   ├── business_profile_screen.dart
│       │   ├── branding_screen.dart
│       │   ├── preferences_screen.dart
│       │   ├── review_screen.dart
│       │   └── onboarding_complete_screen.dart
│       └── widgets/
│           ├── hero_section.dart
│           ├── progress_section.dart
│           ├── next_action_card.dart
│           ├── activity_timeline.dart
│           ├── quick_actions.dart
│           ├── summary_card.dart
│           └── step_form.dart
│
├── animations/
│   ├── entrance_animations.dart       # Slide-up, fade-in builders
│   ├── success_animations.dart        # Confetti, checkmark draw
│   ├── loading_animations.dart        # Pulse, shimmer, morph
│   └── page_transitions.dart          # Custom route transitions
│
└── assets/
    ├── images/
    │   ├── mia_avatar.png             # AI assistant character
    │   ├── welcome_illustration.png
    │   └── app_logo.png
    ├── fonts/
    │   └── Inter/                     # Inter font files
    └── animations/
        ├── success.riv                # Rive animation for success
        └── loading.riv                # Rive animation for loading
```

### 16.2 Test Structure

```
test/
├── unit/
│   ├── models/
│   ├── services/
│   └── providers/
├── widget/
│   ├── shared/
│   └── features/
├── integration/
│   └── onboarding_flow_test.dart
└── mocks/
    ├── mock_api_client.dart
    └── mock_services.dart
```

---

## Section 17 — Developer Implementation Plan

### Phase 1: Foundation (Day 1-2)

| Task | Est. | Files |
|------|------|-------|
| Initialize Flutter project with dependencies | 2h | `pubspec.yaml`, `analysis_options.yaml` |
| Set up folder structure | 1h | All directories |
| Configure theme (colors, typography, spacing) | 2h | `app_theme.dart`, `app_colors.dart`, `app_typography.dart` |
| Set up API client with Dio + interceptors | 2h | `api_client.dart`, `api_interceptors.dart` |
| Create constants | 1h | `api_constants.dart`, `app_constants.dart` |
| Set up GoRouter | 2h | `app_router.dart` |
| Implement shared button widgets | 2h | `primary_button.dart`, `secondary_button.dart`, `ghost_button.dart` |
| Implement shared form widgets | 2h | `app_text_field.dart`, `dropdown_field.dart` |
| Implement feedback widgets | 2h | `loading_overlay.dart`, `error_dialog.dart`, `confirmation_dialog.dart` |

**Total**: ~16h

### Phase 2: Core Screens (Day 3-4)

| Task | Est. | Files |
|------|------|-------|
| Implement AuthService | 2h | `auth_service.dart` |
| Implement AuthProvider | 2h | `auth_provider.dart` |
| Build Welcome Screen | 3h | `welcome_screen.dart` |
| Build Login Screen | 3h | `login_screen.dart` |
| Build Sign Up Screen | 3h | `signup_screen.dart` |
| Build Splash Screen | 2h | Splash logic in `main.dart` |
| Implement auth models | 1h | `auth_models.dart` |

**Total**: ~16h

### Phase 3: Action Center (Day 5-6)

| Task | Est. | Files |
|------|------|-------|
| Implement OnboardingService | 3h | `onboarding_service.dart` |
| Implement OnboardingProvider | 2h | `onboarding_provider.dart` |
| Build display widgets | 3h | `ai_assistant_avatar.dart`, `ai_prompt.dart`, `progress_ring.dart` |
| Build action card widget | 2h | `action_card.dart` |
| Build timeline widget | 2h | `timeline_step.dart` |
| Build Action Center screen | 4h | `action_center_screen.dart` |
| Build hero section | 1h | `hero_section.dart` |
| Build progress section | 1h | `progress_section.dart` |

**Total**: ~18h

### Phase 4: Step Screens (Day 7-9)

| Task | Est. | Files |
|------|------|-------|
| Build Business Setup screen + provider | 6h | `business_setup_screen.dart`, `business_setup_provider.dart` |
| Build Business Profile screen + provider | 4h | `business_profile_screen.dart`, `business_profile_provider.dart` |
| Build Branding screen + provider | 5h | `branding_screen.dart`, `branding_provider.dart` |
| Build color picker + upload widgets | 3h | `color_picker_card.dart`, `upload_card.dart` |
| Build Preferences screen + provider | 5h | `preferences_screen.dart`, `preferences_provider.dart` |
| Implement all models | 2h | `organization_model.dart`, `onboarding_status.dart`, `branding_model.dart` |

**Total**: ~25h

### Phase 5: Review & Complete (Day 10-11)

| Task | Est. | Files |
|------|------|-------|
| Build Review screen + provider | 5h | `review_screen.dart`, `review_provider.dart` |
| Build review widgets | 2h | `review_section.dart`, `review_row.dart` |
| Build Onboarding Complete screen | 3h | `onboarding_complete_screen.dart` |
| Implement animation utilities | 3h | `entrance_animations.dart`, `page_transitions.dart` |
| Implement success animation | 3h | `success_animation.dart`, `success_animations.dart` |
| Implement loading animations | 2h | `loading_animations.dart` |

**Total**: ~18h

### Phase 6: Polish & Testing (Day 12-14)

| Task | Est. | Files |
|------|------|-------|
| Implement error handling across all screens | 4h | All screens |
| Add field validators | 2h | `validators.dart` |
| Implement offline/retry logic | 3h | `api_interceptors.dart`, providers |
| Add haptic feedback | 1h | Shared widgets |
| Write unit tests for providers | 4h | `test/unit/providers/` |
| Write unit tests for services | 3h | `test/unit/services/` |
| Write widget tests for shared components | 3h | `test/widget/shared/` |
| Write widget tests for screens | 4h | `test/widget/features/` |
| Integration test for full flow | 3h | `test/integration/` |
| Accessibility audit | 2h | All widgets |

**Total**: ~29h

### 17.1 Total Estimate: ~122 hours (3 weeks for 1 developer)

### 17.2 Dependencies

```
Phase 1 ──► Phase 2 ──► Phase 3 ──► Phase 4 ──► Phase 5 ──► Phase 6
Foundation   Core Auth   Action Ctr   Step Forms   Review        Polish
                                                              & Testing
```

- Phase 1 is prerequisite for all others
- Phase 2 is prerequisite for Phase 3
- Phase 3 is prerequisite for Phase 4
- Phase 4 is prerequisite for Phase 5
- Phase 6 runs after all phases (but error handling can start in Phase 2)

### 17.3 Pubspec Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  # State Management
  provider: ^6.1.0
  # Networking
  dio: ^5.4.0
  # Storage
  flutter_secure_storage: ^9.0.0
  shared_preferences: ^2.2.0
  # Navigation
  go_router: ^14.0.0
  # UI
  flutter_colorpicker: ^1.0.0
  image_picker: ^1.0.0
  file_picker: ^8.0.0
  # Forms
  email_validator: ^2.1.0
  # Animations
  lottie: ^3.0.0
  # Utilities
  intl: ^0.19.0
  uuid: ^4.0.0
  path: ^1.9.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^4.0.0
  mockito: ^5.4.0
  build_runner: ^2.4.0
```
