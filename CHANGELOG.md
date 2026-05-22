# Changelog

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
