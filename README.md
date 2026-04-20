# NoteFlow

Local-first notes app built with Flutter, Riverpod, go_router, and Isar.

## Getting Started

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

## Architecture

- Feature-first structure in `lib/features/*`
- Lightweight clean architecture (`data/domain/presentation`)
- Riverpod providers for state management
- Isar for local database
- `flutter_local_notifications` for reminder scheduling

## Current Feature Coverage

- Splash + onboarding flow
- Home notes list/grid, filter by folder/tag, sort
- Create/edit notes: title/content/color/folder/tags/pin/archive/reminder/trash
- Checklist note CRUD + reorder + progress
- Search with debounce
- Folders CRUD (safe unlink on delete)
- Tags CRUD (safe unlink on delete)
- Archive / Trash / Reminders screens with actions
- Settings theme/layout/autosave

