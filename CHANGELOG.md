# Changelog

## [0.2.0] - 2026-05-23

### Added

- **Core Utility Layer**
  - `AppColors` — centralized color constants (primary, error, success, surface, etc.)
  - `AppStrings` — all UI strings in one place for easy localization
  - `AppSizes` — layout constants (sidebar width, paddings, radii, breakpoints)
  - `Failures` — abstract `Failure` with `CacheFailure`, `ServerFailure`, `UnknownFailure`
  - `Exceptions` — `CacheException`, `ServerException`
  - `Helpers` — `formatDate()`, `generateId()` (UUID), `truncateText()`

- **Core Reusable Widgets**
  - `AppButton` — custom button with loading state
  - `LoadingView` — centered loading spinner with optional message
  - `EmptyStateView` — empty state with icon, message, and action button

- **Note Detail Page**
  - `NoteDetailPage` — full detail view with title, date, content, pin badge
  - Edit, delete (with confirmation dialog), pin/unpin actions in AppBar

- **Notes List Widget**
  - `NotesList` — replaces inline list logic; BLoC-powered with pinned/unpinned sections
  - Pull-to-refresh, long-press context menu (pin/delete)
  - Loading, empty, and error states handled via core widgets

- **Note Card Widget**
  - `NoteCard` — card-style note item with title, content snippet, pin icon, date

- **WebView Toolbar**
  - `WebviewToolbar` — bold/italic/underline formatting buttons with save action

- **Fallback Editor**
  - `FallbackEditor` — native TextField-based editor when WebView fails to load

- **Testing**
  - `GetNotes` use case test: 3 cases (success, empty, error)
  - `SidebarCubit` test: 5 cases (initial, toggle x2, show, hide)

### Changed

- Version bump: `0.1.0-dev.1` → `0.2.0`

## [0.1.0-dev.1] - 2026-05-22

### ✨ InDev — Initial Development Build

Aplikasi masih dalam tahap pengembangan awal. Fitur dan API bisa berubah tanpa pemberitahuan.

### Added

- **Fitur Settings**
  - Halaman settings full page (`SettingsPage`)
  - `SettingsCubit` — state management dengan SharedPreferences persistence
  - Theme: System / Light / Dark (real-time, langsung berubah)
  - Sort order: Newest, Oldest, Title A-Z, Title Z-A
  - Editor font size: Small / Medium / Large
  - About: versi aplikasi
  - Tombol Settings (⚙️) di footer sidebar

- **Arsitektur Clean Architecture**
  - Domain layer: entity, repository contract, use case
  - Data layer: model, local datasource (SharedPreferences), repository impl
  - Presentation layer: BLoC, Cubit, pages, widgets
  - `lib/core/` — DI (get_it), theme, constants

- **State Management (flutter_bloc)**
  - `NoteBloc` — CRUD, pin/unpin, search notes
  - `SidebarCubit` — hide/show sidebar

- **Fitur Notes**
  - Create, read, update, delete note
  - Pin / unpin note
  - Search notes by title or content
  - Persistence via SharedPreferences

- **Sidebar Kiri**
  - Desktop & tablet: inline sidebar, bisa hide/show dengan animasi
  - Mobile: drawer sidebar
  - Daftar pinned notes, all notes
  - Tombol tambah note baru
  - Lebar sidebar menyesuaikan breakpoint (200px tablet, 280px desktop)

- **Editor WebView Lokal**
  - `assets/web/index.html` + CSS/JS
  - Toolbar: bold, italic, underline, strikethrough, list, heading
  - JavaScript bridge untuk komunikasi Flutter ↔ Web
  - Dark mode otomatis

- **Native Editor**
  - `NoteEditorPage` — alternatif quick edit tanpa WebView

- **Responsive Layout**
  - 3 breakpoint: mobile (<600px), tablet (600–1024px), desktop (>1024px)
  - Editor dibatasi `maxWidth` agar tidak terlalu lebar di layar besar
  - NoteTile pakai `PopupMenuButton` agar tidak overflow di HP kecil

- **Dependency Injection**
  - `get_it` untuk semua service, repository, use case

- **Testing**
  - BLoC test: 5 test cases (initial state, load success, load error, create, delete)

### Technical Notes

- SDK: `^3.11.4`
- Flutter: Material 3, theme light/dark
- WebView: `webview_flutter` 4.x via `loadFlutterAsset`
- Storage: JSON in SharedPreferences (mudah diganti ke SQLite/Hive)
