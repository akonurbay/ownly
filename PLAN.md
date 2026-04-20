# Ownly — Project Plan

## Overview

**Ownly** is a private mobile place-diary app. Not Instagram, not a map — just personal.  
Users add places, capture the atmosphere (mood, weather, who they were with), write a note.  
After a year the app reminds them: "A year ago you were here."

**Stack:** Flutter · Riverpod · Clean Architecture · Hive · fl_chart · go_router · Google Fonts

---

## Architecture

```
lib/
├── main.dart                          # App entry — init Hive, SharedPrefs, determine initial route
├── app.dart                           # MaterialApp.router
│
├── core/
│   ├── theme/
│   │   ├── app_colors.dart            # All design tokens (colors)
│   │   ├── app_text_styles.dart       # Typography scale (Lora + Inter)
│   │   └── app_theme.dart             # ThemeData (Material 3)
│   └── router/
│       └── app_router.dart            # go_router — routes + transitions
│
├── domain/
│   └── entities/
│       ├── enums.dart                 # PlaceCategory, MoodType, WeatherType, CompanionType
│       ├── place.dart                 # Place entity + toJson/fromJson
│       └── visit.dart                 # Visit entity + toJson/fromJson
│
├── data/
│   ├── local/
│   │   └── local_storage.dart         # Hive boxes — JSON-in-Hive (no codegen)
│   └── seed_data.dart                 # 5 places + 9 visits for first launch
│
└── presentation/
    ├── providers/
    │   ├── places_provider.dart        # PlacesNotifier + VisitsNotifier (StateNotifier)
    │   └── settings_provider.dart      # SettingsNotifier (dark theme, notifications, GPS)
    │
    ├── widgets/
    │   ├── ownly_logo.dart             # Branded "O" square logo
    │   ├── place_card.dart             # Grid card with category gradient + badge
    │   └── visit_card.dart             # Visit history row card
    │
    └── screens/
        ├── main_shell.dart             # StatefulNavigationShell + custom BottomNav
        ├── onboarding/                 # 3-slide animated onboarding
        ├── auth/                       # Login / Register tab switcher
        ├── home/                       # Search · filter chips · 2-col grid · FAB
        ├── place_detail/               # Hero · stats · visit history · add-visit sheet
        ├── add_place/                  # 2-step: place info → mood/weather/companion
        ├── analytics/                  # Stats grid · donut charts · bar chart
        ├── time_machine/               # Timeline grouped by year/month/week ago
        └── settings/                   # iOS-style toggles · profile card
```

---

## Screens

| # | Screen | Route | Key Features |
|---|--------|-------|--------------|
| 1 | **OnboardingScreen** | `/onboarding` | 3 animated slides, blob decorations, dot pagination, AnimatedSwitcher |
| 2 | **AuthScreen** | `/auth` | Animated pill tab switcher, login + register forms, SharedPrefs session |
| 3 | **HomeScreen** | `/` | 2-column PlaceCard grid, search bar, horizontal filter chips, accent FAB |
| 4 | **MainShell** | shell | StatefulShellRoute bottom nav (4 tabs), custom nav bar |
| 5 | **PlaceDetailScreen** | `/place/:id` | Category gradient hero, favourite toggle, stats row, visit history, add-visit bottom sheet |
| 6 | **AddPlaceScreen** | `/add-place` | 2-step flow — step 1: name/city/category/note; step 2: mood/weather/companion grid |
| 7 | **AnalyticsScreen** | `/analytics` | 2×2 stats tiles, traveler profile card, category donut, monthly bar chart, mood donut |
| 8 | **TimeMachineScreen** | `/time-machine` | "Surprise me" dark card, vertical timeline with entries from 1yr/1mo/1wk ago |
| 9 | **SettingsScreen** | `/settings` | Profile card, iOS toggles (dark theme, notifications, GPS), export/delete/logout |

---

## Navigation Flow

```
Onboarding ──► Auth ──► Home (main shell)
                              ├── Home        /
                              ├── Time Machine /time-machine
                              ├── Analytics    /analytics
                              └── Settings     /settings

Home ──► PlaceDetail  /place/:id    (slide-right transition)
Home ──► AddPlace     /add-place    (slide-up transition)
TimeMachine ──► PlaceDetail
```

Redirect logic in `main.dart`:
- No onboarding seen → `/onboarding`
- Not logged in → `/auth`
- Otherwise → `/` (main shell)

---

## Data Model

```dart
Place {
  id, name, description, category: PlaceCategory,
  city, latitude?, longitude?, photoPath?,
  createdAt, isFavorite
}

Visit {
  id, placeId,
  mood: MoodType, weather: WeatherType, companion: CompanionType,
  note?, visitedAt
}

// Enums
PlaceCategory  { cafe | nature | museum | restaurant | other }
MoodType       { great | good | neutral | bad }
WeatherType    { sunny | cloudy | rainy | snowy }
CompanionType  { alone | friend | couple | family }
```

Storage: `Hive.box('places')`, `Hive.box('visits')`, `Hive.box('settings')`  
Each entry stored as `jsonEncode(entity.toJson())` keyed by `id`.

---

## Design Tokens

| Token | Value | Usage |
|-------|-------|-------|
| `bgPrimary` | `#F7F2EA` | Main scaffold background |
| `bgCard` | `#FFFCF7` | Cards, inputs |
| `bgDeep` | `#EDE6D9` | Tab switcher, secondary backgrounds |
| `accent` | `#C4875A` | Primary buttons, active states, FAB |
| `textPrimary` | `#2C2416` | Headlines |
| `textSub` | `#7A6A54` | Secondary text |
| `textMuted` | `#AFA090` | Placeholders, labels |
| `border` | `#E0D6C8` | Card borders |

Fonts: `GoogleFonts.lora()` for headings/quotes · `GoogleFonts.inter()` for UI labels

---

## Commit Timeline (14 days)

| Day | Date | Commit |
|-----|------|--------|
| 1 | Apr 20 | `chore: initialize Flutter project, add dependencies` |
| 2 | Apr 21 | `feat: add design tokens — colors, typography, theme` |
| 3 | Apr 22 | `feat: add domain entities — Place, Visit, enums` |
| 4 | Apr 23 | `feat: add Hive local storage with JSON serialization` |
| 5 | Apr 24 | `feat: add seed data for development and demo` |
| 6 | Apr 25 | `feat: add Riverpod providers — places, visits, settings` |
| 7 | Apr 26 | `feat: add go_router with StatefulShellRoute for bottom nav` |
| 8 | Apr 27 | `feat: add shared widgets — OwnlyLogo, PlaceCard, VisitCard` |
| 9 | Apr 28 | `feat: implement OnboardingScreen with animated slides` |
| 10 | Apr 29 | `feat: implement AuthScreen with login/register tab switcher` |
| 11 | Apr 30 | `feat: implement HomeScreen with search, filters and place card grid` |
| 12 | May 01 | `feat: implement PlaceDetailScreen with hero area and visit history` |
| 13 | May 02 | `feat: implement AddPlaceScreen with 2-step place and visit flow` |
| 14a | May 03 | `feat: implement AnalyticsScreen with fl_chart pie and bar charts` |
| 14b | May 03 | `feat: implement TimeMachineScreen with timeline and surprise card` |
| 14c | May 03 | `feat: implement SettingsScreen; wire up main.dart and app.dart` |
