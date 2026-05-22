# Gurat

A Flutter notes application with Google Keep-style grid layout, Clean Architecture, BLoC state management, local WebView editor, and responsive design.

## Features

- **Notes CRUD** — Create, read, update, delete notes
- **Grid View** — Google Keep-style block layout (responsive columns: 1–4)
- **Pin / Unpin** — Pin important notes to the top
- **Search** — Search notes by title or content
- **Note Detail Page** — Full detail view with edit, delete, and pin actions
- **WebView Editor** — Rich text editor with toolbar (bold, italic, lists, headings) via local HTML/JS
- **Fallback Editor** — Native TextField editor when WebView is unavailable
- **Sidebar** — Inline sidebar on desktop/tablet (hide/show), drawer on mobile
- **Responsive** — 3 breakpoints: mobile (<600px), tablet (600–1024px), desktop (>1024px)
- **Settings** — Theme (light/dark/system), sort order, editor font size
- **Dark Mode** — Full dark mode support for all components including WebView editor
- **Persistent** — All data saved via SharedPreferences
- **Material 3** — Modern Material Design 3 theming

## Architecture

```
lib/
├── main.dart                       # Entry point
├── app/
│   └── app.dart                    # MaterialApp + BLoC providers + theme
├── core/
│   ├── constants/                  # AppColors, AppStrings, AppSizes
│   ├── di/                         # Dependency injection (get_it)
│   ├── errors/                     # Failures & Exceptions
│   ├── theme/                      # Light/dark theme definitions
│   ├── utils/                      # Helpers (date, id, text)
│   └── widgets/                    # AppButton, LoadingView, EmptyStateView
└── features/
    ├── notes/                      # Notes feature module
    │   ├── data/
    │   │   ├── datasources/        # Local data source (SharedPreferences)
    │   │   ├── models/             # Data models with JSON serialization
    │   │   └── repositories/       # Repository implementation
    │   ├── domain/
    │   │   ├── entities/           # Note entity
    │   │   ├── repositories/       # Repository contract (abstract)
    │   │   └── usecases/           # Business logic use cases
    │   └── presentation/
    │       ├── bloc/               # NoteBloc (events + states)
    │       ├── cubit/              # SidebarCubit
    │       ├── pages/              # Notes page, detail page, editor pages
    │       └── widgets/            # NoteCard, Sidebar, editors
    └── settings/                   # Settings feature module
        ├── domain/entities/        # AppSettings entity (theme, sort, font)
        └── presentation/
            ├── cubit/              # SettingsCubit with persistence
            └── pages/              # Settings page

Clean Architecture layers:

┌──────────────────────────────────────────┐
│           Presentation (UI)              │
│   Pages · Widgets · BLoC / Cubit         │
├──────────────────────────────────────────┤
│           Domain (Business)              │
│   Entities · Repository Contracts        │
│   Use Cases                              │
├──────────────────────────────────────────┤
│           Data (Implementation)          │
│   Data Sources · Models · Repositories   │
└──────────────────────────────────────────┘
```

## Project Structure Details

| Layer | Description |
|---|---|---|
| **core** | Shared utilities: constants (`AppColors`, `AppStrings`, `AppSizes`), error handling (`Failures`, `Exceptions`), helpers (`formatDate`, `generateId`, `truncateText`), reusable widgets (`AppButton`, `LoadingView`, `EmptyStateView`), DI setup (`get_it`), and theming. |
| **domain** | Pure Dart — no framework dependencies. Contains `Note` entity, `NoteRepository` abstract class, and use cases. |
| **data** | Implements domain contracts. `NoteLocalDataSource` reads/writes JSON via SharedPreferences. `NoteModel` handles JSON serialization/deserialization. |
| **presentation** | Flutter UI with `flutter_bloc`. `NoteBloc` manages CRUD + search. `SidebarCubit` manages sidebar visibility. `SettingsCubit` manages app settings. Widgets include `NoteCard`, `WebviewToolbar`, and `FallbackEditor`. Notes displayed in a responsive grid layout (Google Keep-style). |

## State Management

| Bloc / Cubit | Purpose |
|---|---|
| **NoteBloc** | Manages notes state: load, create, update, delete, pin, search |
| **SidebarCubit** | Toggles sidebar visibility (hide/show) with animated transition |
| **SettingsCubit** | Manages app settings (theme, sort order, font size) with SharedPreferences persistence |

## Getting Started

### Prerequisites

- Flutter SDK ^3.11.4
- Android Studio / VS Code
- Emulator or physical device

### Installation

```bash
# Clone the repository
git clone https://github.com/LunaeKim99/AiNotesApp.git
cd AiNotesApp

# Install dependencies
flutter pub get

# Run the app
flutter run

# Build APK
flutter build apk --debug
```

### Run Tests

```bash
flutter test
```

Test coverage:
- **`note_bloc_test.dart`** — 5 BLoC test cases (initial state, load success, load error, create, delete)
- **`get_notes_test.dart`** — 3 use case test cases (success, empty, error)
- **`sidebar_cubit_test.dart`** — 5 cubit test cases (initial, toggle, show, hide)

## Dependencies

| Package | Version | Purpose |
|---|---|---|
| `flutter_bloc` | ^9.1.0 | State management |
| `equatable` | ^2.0.7 | Value equality |
| `get_it` | ^8.0.3 | Dependency injection |
| `shared_preferences` | ^2.5.3 | Local data persistence |
| `uuid` | ^4.5.1 | Unique ID generation |
| `intl` | ^0.20.2 | Date formatting |
| `webview_flutter` | ^4.12.0 | Local WebView editor |

### Dev Dependencies

| Package | Version | Purpose |
|---|---|---|
| `bloc_test` | ^10.0.0 | BLoC testing utilities |
| `mocktail` | ^1.0.4 | Mocking for Dart tests |

## WebView Editor

The rich text editor is built with vanilla HTML/CSS/JS stored in `assets/web/`:

- `index.html` — Editor layout with toolbar
- `css/style.css` — Styling with light/dark mode support
- `js/app.js` — Editor logic + JavaScript bridge for Flutter communication

Communication between Flutter and WebView:
- **Flutter → Web**: `controller.runJavaScript("editor.setContent(...)")`
- **Web → Flutter**: `FlutterBridge.postMessage(...)` → received via `JavaScriptChannel`

## Responsive Breakpoints

| Layout | Width | Sidebar |
|---|---|---|
| Mobile | <600px | Drawer (slide from left) |
| Tablet | 600–1024px | Inline, 200px width, hide/show toggle |
| Desktop | >1024px | Inline, 280px width, hide/show toggle |
