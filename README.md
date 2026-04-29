# CampusConnect

A university-scoped social platform built with Flutter, designed to connect students through feeds, carpooling, project partnerships, hostelite exchange, and more — all within verified university communities.

---

## Team Members

| Name | Student ID |
|---|---|
| **Mehkaan Khan** | F2024-0130 |
| **Abdullah Sajjad** | F2024-0917 |
| **Abdur-Rahman Rana** | F2024-0912 |

---

## Task 1: UI Submission — Work Division

### Abdullah Sajjad — F2024-0917
- Onboarding
- Project Partners
- Create Post
- Thread & Moderation
- Profile Setup

### Mehkaan Khan — F2024-0130
- Auth
- Main Feed
- Notifications
- User Profile
- Hostellite Exchange

### Abdur-Rahman Rana — F2024-0912
- Leaderboard
- Hostellite Exchange
- Uni Graph
- Other Unis

---

## Design

Figma: [View Prototype](https://www.figma.com/design/CriMpInvYTRkZw5b8hDuOn/Untitled?node-id=0-1&t=kU3nOpp5xcJM2UsT-1)

---

## Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter 3.x (Dart) |
| Architecture | Clean Architecture (Data / Domain / Presentation) |
| State Management | Provider |
| Navigation | GoRouter |
| Backend | Firebase (Auth, Firestore, Storage, FCM) |
| Local Storage | SharedPreferences |
| HTTP | http package |

---

## Project Structure

```
lib/
├── core/
│   ├── constants/       # Colors, assets, keys
│   ├── theme/           # App theme (light/dark)
│   ├── router/          # GoRouter configuration
│   └── widgets/         # Shared widgets
└── features/
    ├── auth/            # Authentication (login, signup, reset, logout)
    ├── settings/        # Language, notifications, profile settings
    └── cart/            # Cart with counter and timer
```

Each feature follows the three-layer Clean Architecture pattern:

```
feature/
├── data/
│   ├── datasources/     # Remote / local data sources
│   ├── models/          # JSON-serializable models
│   └── repositories/    # Repository implementations
├── domain/
│   ├── entities/        # Pure Dart entities
│   ├── repositories/    # Abstract repository contracts
│   └── usecases/        # Single-responsibility use cases
└── presentation/
    ├── provider/        # ChangeNotifier providers
    ├── pages/           # Screen widgets
    └── widgets/         # Feature-specific widgets
```

---

## Features

1. **University Email Verification** — Restrict registration to `.edu` or university-specific domains
2. **Profile Setup Flow** — Name, department, semester, photo, and bio after signup
3. **Role-Based Access Control** — Student, Hostelite, and Moderator roles
4. **Session Management** — Auto-logout on inactivity with token refresh
5. **University-Scoped Feed** — Feed limited to each university; read-only for external users
6. **Post Creation** — Text, image, video, and poll posts
7. **Reactions & Voting** — Five reactions plus upvote/downvote scoring
8. **Nested Commenting** — Threaded comments with two levels of replies
9. **Post Categories & Flairs** — Academic, Events, Hostel, Marketplace, Carpool tags
10. **Content Moderation** — Report posts/comments; moderators can remove content or ban users
11. **Carpool System** — Create posts, handle requests, display routes, manage capacity
12. **Project Partner Posting** — Post for collaborators with domain and skill specifications
13. **Skill Tagging & Filtering** — Tag and filter posts by skill sets
14. **Hostellite Goods Exchange** — Board for renting or exchanging items among hostelites
15. **Complaint Submission** — Submit complaints related to hostel or exchange activities
16. **Push Notifications** — Real-time notifications via Firebase Cloud Messaging
17. **Dark Mode** — Full dark theme support
18. **Onboarding Screens** — Introduce app features to new users
19. **University Leaderboard** — Rankings based on activity metrics
20. **Moderator Interface** — Dedicated view for managing content and users
21. **User Profile Management** — View/edit profile, post history, reactions, and carpools

---

## Getting Started

### Prerequisites

- Flutter SDK 3.x
- Dart 3.x
- Android Studio / VS Code
- Firebase project configured

### Installation

```bash
# Clone the repository
git clone https://github.com/MehkaanKhan/Campus-Connect.git
cd Campus-Connect

# Install dependencies
flutter pub get

# Run the app
flutter run
```

### Firebase Setup

1. Create a Firebase project at [console.firebase.google.com](https://console.firebase.google.com)
2. Add Android/iOS apps and download `google-services.json` / `GoogleService-Info.plist`
3. Place them in `android/app/` and `ios/Runner/` respectively
4. Enable Authentication, Firestore, Storage, and Cloud Messaging in Firebase console
