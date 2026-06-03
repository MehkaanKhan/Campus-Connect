# CAMPUS CONNECT — Project Brief
> Paste this at the start of every Claude Code session.

---

## What is Campus Connect
A university social platform connecting students across campuses for social interaction, ridesharing, marketplace trading, and project collaboration.

**One sentence:** Campus Connect is a mobile app where university students share posts, organise carpools, trade hostel goods, find project partners, and track campus reputation in real time.

---

## Tech Stack
| Layer | Technology |
|---|---|
| Frontend | Flutter (iOS + Android — mobile only) |
| State Management | Provider (ChangeNotifier — NO Riverpod, NO Bloc) |
| Routing | GoRouter v14 with auth guards + refreshListenable |
| Backend | Supabase (PostgreSQL + Auth + Storage + RLS) |
| Architecture | Clean Architecture (strictly follow structure below) |
| Project name | campus_connect |

---

## Clean Architecture — STRICT RULES
```
Presentation → Domain → Data
```
- **Domain**: pure Dart. Zero Flutter imports. Zero Supabase imports.
- **Data**: implements domain interfaces. ALL Supabase calls live here only.
- **Presentation**: Provider + pages + widgets. No Supabase here ever.
- **Core**: theme, constants, common widgets. Shared across all layers.

---

## Exact Folder Structure
```
lib/
├── main.dart
├── core/
│   ├── constants/
│   │   ├── app_colors.dart       ← all color tokens
│   │   ├── app_assets.dart
│   │   └── app_keys.dart
│   ├── theme/app_theme.dart
│   ├── utils/size_config.dart    ← responsive scaling
│   ├── router/
│   │   ├── app_router.dart
│   │   ├── home_shell.dart
│   │   └── placeholder_screens.dart
│   └── widgets/
│       ├── app_loader.dart
│       └── app_snackbar.dart
└── features/
    └── <feature_name>/
        ├── data/
        │   ├── datasources/<feature>_remote_datasource.dart
        │   ├── models/
        │   └── repositories/<feature>_repository_impl.dart
        ├── domain/
        │   ├── entities/<feature>_entity.dart
        │   ├── repositories/<feature>_repository.dart   ← abstract
        │   └── usecases/<verb>_<noun>_usecase.dart
        └── presentation/
            ├── pages/<feature>_page.dart
            ├── provider/<feature>_provider.dart
            └── widgets/
```

**Naming conventions:**
- `data/datasources/` — NOT `data/source/`
- `data/repositories/` — NOT `data/repositoryImp/`
- Repository impl file: `<feature>_repository_impl.dart` — NOT `_imp.dart`

---

## Provider Pattern (use this exact pattern)
```dart
enum FeedStatus { initial, loading, loaded, error }

class FeedProvider extends ChangeNotifier {
  final GetFeedUsecase _getFeedUsecase;
  final VoteOnPostUsecase _voteUsecase;

  FeedStatus _status = FeedStatus.initial;
  List<PostEntity> _posts = [];
  String? _error;

  FeedStatus get status => _status;
  List<PostEntity> get posts => _posts;
  String? get error => _error;
  bool get isLoading => _status == FeedStatus.loading;

  FeedProvider(this._getFeedUsecase, this._voteUsecase);

  Future<void> loadFeed() async {
    _status = FeedStatus.loading;
    _error = null;
    notifyListeners();
    try {
      _posts = await _getFeedUsecase();
      _status = FeedStatus.loaded;
    } catch (e) {
      _error = e.toString();
      _status = FeedStatus.error;
    }
    notifyListeners();
  }

  // Optimistic update — fire-and-forget for non-critical async ops
  void toggleUpvote(String postId) {
    final idx = _posts.indexWhere((p) => p.id == postId);
    if (idx < 0) return;
    _posts[idx] = _posts[idx].copyWith(isUpvoted: true);
    notifyListeners();
    _voteUsecase(postId, 'up').ignore();
  }
}
```

- Always use **status enums** (not a bare `bool _isLoading`)
- Dependencies injected via constructor
- `notifyListeners()` called after every state change
- **Optimistic updates** with `.ignore()` for vote/reaction mutations
- Entities must expose `copyWith()` for immutable mutations
- Register all providers in `main.dart` with `MultiProvider`

---

## Responsive Sizing (SizeConfig)
```dart
// Design canvas: 390 × 887 logical px (iPhone 14 base)
16.w    // width-scaled value
20.h    // height-scaled value
14.sp   // font-size-scaled value
8.r     // radius-scaled value
```
Import `size_config.dart` and use extension methods — never hardcode raw pixel values.

---

## Authentication Flow
- **Provider:** Supabase auth stream subscribed in `AuthProvider`
- **Signup:** email + password → Supabase Auth → creates `profiles` row
- **Login:** `signInWithPassword(email, password)`
- **Password Reset:** `resetPasswordForEmail` → deep link `campusconnect://login-callback/`
- **Email verification** gated before `/profile-setup`
- Flags on `AuthProvider`: `needsEmailVerification`, `needsPasswordReset`
- Router uses `AuthProvider` as `refreshListenable` for reactive redirects

---

## Features
| Feature | Route | Description |
|---|---|---|
| auth | `/login`, `/signup`, `/reset-password` | Email/password auth, email verification, password reset |
| onboarding | `/onboarding` | First-time walkthrough screens |
| profile_setup | `/profile-setup` | Pick university, department, semester, avatar |
| feed | `/feed` | Campus-wide social feed with upvote/downvote |
| create_post | `/create-post` | Compose posts with images and flair tags |
| thread | `/thread?id=<postId>` | Post detail + nested comments |
| carpool | `/carpool` | Post and join student carpool rides |
| hostellite_exchange | `/hostellite-exchange` | Borrow/rent/free hostel goods marketplace |
| project_partners | `/project-partners` | Find collaborators for academic/startup projects |
| notifications | `/notifications` | In-app notifications feed |
| user_profile | `/user-profile` | View profiles with posts, karma, stats |
| settings | `/settings/profile`, `/settings/language`, `/settings/notifications` | App settings |
| leaderboard | `/leaderboard` | Karma-based student rankings |
| explore | `/explore` | Discovery hub (universities, categories, trending) |
| other_unis | `/other-unis` | Browse other university profiles |
| uni_graph | `/uni-graph` | University network connection visualisation |
| cart | `/cart` | Marketplace shopping cart |

**Bottom Nav (5 tabs):**
```
HOME    /feed           → assets/icons/ic_home.svg
EXPLORE /explore        → assets/icons/ic_search.svg
CREATE  /create-post    → assets/icons/ic_create.svg
ALERTS  /notifications  → assets/icons/ic_bell.svg
PROFILE /user-profile   → assets/icons/ic_person.svg
```
Active colour: `AppColors.sage` · Inactive: `AppColors.navInactive`

---

## Supabase Schema
```
profiles          id, full_name, email, avatar_url, university_id, department,
                  semester, bio, karma_score, onboarding_seen, created_at

universities      id, name, logo_text, description

posts             id, author_id→profiles, university_id→universities, title,
                  content, image_url, flair, upvote_count, downvote_count,
                  comment_count, allow_replies, created_at

votes             user_id→profiles, post_id→posts, vote_type (up|down)

comments          id, post_id→posts, author_id→profiles, content, upvote_count,
                  is_op, parent_id (nullable, for nested replies), created_at

post_tags         post_id→posts, tag

carpool_rides     id, driver_id→profiles, origin, destination, departure_time,
                  departure_date, total_seats, taken_seats, estimated_minutes,
                  filter_slot (morning|evening|weekend), map_image_url, created_at

carpool_passengers  user_id→profiles, ride_id→carpool_rides

exchange_items    id, seller_id→profiles, title, description,
                  item_type (borrow|rent|free), price, price_unit,
                  condition (brand_new|like_new|good|fair),
                  image_url, is_available, created_at

project_listings  id, creator_id→profiles, badge, badge_color, title,
                  description, created_at

project_skills    listing_id→project_listings, skill_name

project_applications  id, listing_id→project_listings, applicant_id→profiles,
                  cover_message, phone_number,
                  status (pending|accepted|rejected), created_at

notifications     id, user_id→profiles, type (comment|carpool|club|marketplace|general),
                  message, is_read, has_action, avatar_url, created_at
```

**Storage buckets:** `avatars` (profile photos) · `post-images` (post attachments)

---

## Key Domain Entities
```dart
// Feed
PostEntity { id, authorName, authorAvatarUrl, timeAgo, flair, flairColor,
             title, excerpt, imageUrl?, upvotes, downvotes, commentCount,
             isUpvoted, isDownvoted }

// Auth / Profile
UserEntity        { id, name, email, avatarUrl?, universityId? }
UserProfileEntity { id, name, department, year, bio, avatarUrl,
                    postCount, karma, ridesCount,
                    posts[], reactedPosts[], joinedCarpools[] }

// Carpool
CarpoolRideEntity { id, from, to, time, date, totalSeats, takenSeats,
                    driverName, driverAvatarUrl, estimatedMinutes,
                    hasJoined, filter }

// Marketplace
ExchangeItemEntity { id, title, description, type (ItemType), price?,
                     priceUnit, condition (ItemCondition), sellerName,
                     sellerAvatarUrl, imageUrl, timeAgo, isAvailable }

// Collaboration
ProjectPartnerEntity { id, creatorId, badge, badgeColor, title, description,
                       skills[], applicationCount, currentUserApplicationStatus }
```

---

## Design System
```
Brand:       primary      #3D5C3D   dark sage — buttons, ThemeData seed
             secondary    #6B8F6B   medium sage — active states
             sage         #6B8F6B   alias for secondary (use for active nav, chips)

Backgrounds: pageBg       #F8FAFC   main feed/explore pages
             altPageBg    #F7F7F5   hostellite/thread pages
             cardBg       #FFFFFF   card surfaces
             onboardingBg #EEEDE4   onboarding screens

Text:        textPrimary   #1A1A1A
             textSecondary #64748B
             textMuted     #94A3B8
             textHint      #AAAAAA
             textCaption   #555555
             textLabel     #888880  (UPPERCASE small-caps labels)

Borders:     border        #EEEE8   standard dividers
             inputBorder   #DCDCD4  form inputs

Utility:     error         #EF4444
             success       #22C55E
             accent        #F59E0B  (cart / amber highlights)

Nav:         navInactive   #999990  inactive tab icons/labels

Flair chips: Events        #D6D6EA  lavender
             Academic      #FED9B8  peach
             Hostel        #E2E3E0  gray
             Carpool       #E2E9E0  light sage
             Marketplace   #D6D6EA  lavender

Fonts:  Inter (primary body) · PlusJakartaSans (display/headings)
Radius: 8px buttons · 12px cards · 10px inputs
```

Use `AppColors.<token>` always — never hardcode hex values.

---

## Rules for Claude Code
- Use `AppColors` tokens from `app_colors.dart` — never hardcode hex
- Use `SizeConfig` extensions (`.w`, `.h`, `.sp`, `.r`) — never hardcode pixels
- Follow folder naming exactly: `datasources/`, `repositories/` (not `source/`, `repositoryImp/`)
- Domain layer: pure Dart only — no Flutter, no Supabase
- Build order: domain entity → domain repository (abstract) → domain usecase → data layer → presentation
- All Supabase queries live in datasource files only
- Every async call needs `enum Status { initial, loading, loaded, error }` in provider
- Every list screen needs an empty-state widget
- GoRouter only — never `Navigator.push` or `Navigator.pushNamed`
- SVG icons via `flutter_svg` with `ColorFilter.mode(color, BlendMode.srcIn)`
- `copyWith()` required on every domain entity
- Optimistic mutations: update state immediately → call usecase with `.ignore()`
- All providers registered in `MultiProvider` in `main.dart`
- Mobile-only layout: single column, bottom nav bar (`CampusBottomNavBar`)
