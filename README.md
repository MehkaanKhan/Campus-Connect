# Campus Connect

A university social platform for students to connect, collaborate, and commute — all within verified campus communities.

> Built with Flutter + Supabase. Clean Architecture. Provider state management.

---

## Team

| Name | Student ID |
|---|---|
| **Mehkaan Khan** | F2024-0130 |
| **Abdullah Sajjad** | F2024-0917 |
| **Abdur-Rahman Rana** | F2024-0912 |

---

## Screenshots

| Feed | Carpool | Project Partners |
|---|---|---|
| University-scoped posts with upvote/downvote | Post and join rides with seat tracking | Find collaborators by skill |

| Leaderboard | Other Unis | Settings |
|---|---|---|
| Karma-based rankings with time filters | Interactive university grid with images | Edit profile, change password, preferences |

---

## Features

### Core Social
- **University Feed** — Posts scoped to your university with upvote/downvote karma scoring
- **Post Flairs** — Categorise posts as General, Events, Academic, Hostel, Marketplace, Carpool
- **Nested Comments** — Two-level threaded replies with reply-to targeting
- **Post Creation** — Compose with image attachments and flair tags
- **Search** — Global post search across the feed

### Carpool & Rides
- **Browse Rides** — Filter by Morning / Evening / Weekend time slots
- **Post a Ride** — Origin, destination, date, time, seat count
- **Join a Ride** — Real-time seat availability tracking
- **Notifications** — Driver is notified when someone joins their ride

### Hostellite Exchange
- **Item Listings** — Borrow, rent, or give away hostel goods
- **Item Detail** — Full item page with availability status
- **Complaint Board** — Submit complaints about listings

### Project Partners
- **Project Listings** — Post for collaborators with skill tags and descriptions
- **Applications** — Apply with a cover message and contact number
- **Application Management** — Accept or reject applicants on your own listings

### Campus Discovery
- **Explore Hub** — Entry point for all sub-features
- **Other Universities** — Browse other campus communities with member counts and building images
- **University Graph** — Interactive network visualisation of university connections — drag nodes, zoom in/out
- **Leaderboard** — Karma rankings filtered by All Time / This Week / This Month

### Notifications
- Real-time in-app notification feed
- Types: comment, reply, carpool join, karma events
- Unread badge on the Alerts tab

### Profile & Settings
- **User Profile** — Avatar, bio, karma score, post count, joined carpools
- **Edit Profile** — Update name, bio, and avatar (Supabase Storage upload)
- **Change Password** — Secure in-app password update
- **Settings** — Notifications, language, privacy, about

### Auth
- Email/password signup restricted to university email domains
- Email verification gate before profile setup
- Password reset via deep link (`campusconnect://login-callback/`)
- Persistent auth session via Supabase auth stream

---

## Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter 3.x (Dart 3.x) — iOS & Android |
| Architecture | Clean Architecture (Domain / Data / Presentation) |
| State Management | Provider (`ChangeNotifier`) |
| Navigation | GoRouter v14 with auth guards |
| Backend | Supabase (PostgreSQL + Auth + Storage + RLS) |
| Icons | Custom SVG system (`assets/icons/icons/`) via `flutter_svg` |
| Responsive sizing | `SizeConfig` extensions (`.w`, `.h`, `.sp`, `.r`) |

---

## Project Structure

```
lib/
├── main.dart                    # MultiProvider wiring + app entry
├── core/
│   ├── constants/               # AppColors tokens, AppAssets paths
│   ├── router/                  # GoRouter config + auth redirect
│   ├── utils/size_config.dart   # Responsive scaling (390×887 design canvas)
│   └── widgets/                 # CampusTopNavBar, CampusBottomNavBar, shimmer_box
└── features/
    ├── auth/
    ├── carpool/
    ├── create_post/
    ├── feed/
    ├── hostellite_exchange/
    ├── hostellite_exchange_board/
    ├── leaderboard/
    ├── notifications/
    ├── other_unis/
    ├── profile_setup/
    ├── project_partners/
    ├── settings/
    ├── thread/
    ├── uni_graph/
    └── user_profile/
```

Each feature follows the Clean Architecture three-layer structure:

```
feature/
├── data/
│   ├── datasources/    # All Supabase calls live here only
│   └── repositories/   # Repository implementations
├── domain/
│   ├── entities/       # Pure Dart — zero Flutter/Supabase imports
│   ├── repositories/   # Abstract contracts
│   └── usecases/       # One responsibility per usecase
└── presentation/
    ├── provider/       # ChangeNotifier + status enums
    ├── pages/          # Screen widgets
    └── widgets/        # Feature-specific widgets + shimmer skeletons
```

---

## Database Schema (Supabase)

```
profiles            id, full_name, email, avatar_url, university_id,
                    department, semester, bio, karma_score, created_at

universities        id, name, logo_text, description, building_image_url

posts               id, author_id, university_id, title, content,
                    image_url, flair, upvote_count, downvote_count,
                    comment_count, allow_replies, created_at

votes               user_id, post_id, vote_type (up|down)

comments            id, post_id, author_id, content, upvote_count,
                    parent_id (nullable — nested replies), created_at

carpool_rides       id, driver_id, origin, destination, departure_time,
                    departure_date, total_seats, taken_seats,
                    estimated_minutes, filter_slot, created_at

carpool_passengers  user_id, ride_id

exchange_items      id, seller_id, title, description, item_type,
                    price, condition, image_url, is_available, created_at

exchange_complaints id, item_id, reporter_id, reason, details, status

project_listings    id, creator_id, badge, title, description, created_at

project_skills      listing_id, skill_name

project_applications  id, listing_id, applicant_id, cover_message,
                      phone_number, status, created_at

notifications       id, user_id, type, message, is_read, avatar_url, created_at
```

**Storage buckets:** `avatars` · `post-images` · `university-images`

---

## Getting Started

### Prerequisites

- Flutter SDK 3.x
- Dart 3.4+
- Android Studio or VS Code
- A [Supabase](https://supabase.com) project

### Installation

```bash
# Clone
git clone https://github.com/MehkaanKhan/Campus-Connect.git
cd Campus-Connect

# Install dependencies
flutter pub get
```

### Environment Setup

Create a `.env` file in the project root:

```env
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-anon-key
```

### Run

```bash
flutter run
```

---

## Design System

| Token | Value | Usage |
|---|---|---|
| `primary` | `#3D5C3D` | Buttons, active states, brand colour |
| `secondary` / `sage` | `#6B8F6B` | Active nav tabs, filter chips |
| `pageBg` | `#F8FAFC` | Main screen backgrounds |
| `cardBg` | `#FFFFFF` | Card and surface backgrounds |
| `textPrimary` | `#1A1A1A` | Headings and body text |
| `textMuted` | `#94A3B8` | Placeholders, secondary labels |

Fonts: **Inter** (body) · **Plus Jakarta Sans** (display headings)

All icons are custom SVGs under `assets/icons/icons/` — never Material Icons.

---

## Figma Design

[View Prototype](https://www.figma.com/design/CriMpInvYTRkZw5b8hDuOn/Untitled?node-id=0-1&t=kU3nOpp5xcJM2UsT-1)
