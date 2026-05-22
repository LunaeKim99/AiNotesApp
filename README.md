# AiNotes App

A Flutter notes application with Clean Architecture, BLoC state management, local WebView editor, and responsive design.

## Features

- **Notes CRUD** — Create, read, update, delete notes
- **Pin / Unpin** — Pin important notes to the top
- **Search** — Search notes by title or content
- **WebView Editor** — Rich text editor with toolbar (bold, italic, lists, headings) via local HTML/JS
- **Native Editor** — Alternative quick-edit mode without WebView
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
│   ├── constants/                  # App constants, breakpoints
│   ├── di/                         # Dependency injection (get_it)
│   └── theme/                      # Light/dark theme definitions
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
    │       ├── pages/              # Notes page, editor pages
    │       └── widgets/            # Reusable widgets
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
|---|---|
| **domain** | Pure Dart — no framework dependencies. Contains `Note` entity, `NoteRepository` abstract class, and use cases. |
| **data** | Implements domain contracts. `NoteLocalDataSource` reads/writes JSON via SharedPreferences. `NoteModel` handles JSON serialization/deserialization. |
| **presentation** | Flutter UI with `flutter_bloc`. `NoteBloc` manages CRUD + search. `SidebarCubit` manages sidebar visibility. `SettingsCubit` manages app settings. |

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
