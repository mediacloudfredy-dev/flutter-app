import 'package:go_router/go_router.dart';
import 'package:noteflow/app/router/app_routes.dart';
import 'package:noteflow/features/folders/presentation/pages/folders_page.dart';
import 'package:noteflow/features/notes/presentation/pages/archive_page.dart';
import 'package:noteflow/features/notes/presentation/pages/checklist_note_page.dart';
import 'package:noteflow/features/notes/presentation/pages/edit_note_page.dart';
import 'package:noteflow/features/notes/presentation/pages/home_page.dart';
import 'package:noteflow/features/notes/presentation/pages/reminders_page.dart';
import 'package:noteflow/features/notes/presentation/pages/search_page.dart';
import 'package:noteflow/features/notes/presentation/pages/trash_page.dart';
import 'package:noteflow/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:noteflow/features/settings/presentation/pages/settings_page.dart';
import 'package:noteflow/features/splash/presentation/pages/splash_page.dart';
import 'package:noteflow/features/tags/presentation/pages/tags_page.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(path: AppRoutes.splash, builder: (c, s) => const SplashPage()),
      GoRoute(path: AppRoutes.onboarding, builder: (c, s) => const OnboardingPage()),
      GoRoute(path: AppRoutes.home, builder: (c, s) => const HomePage()),
      GoRoute(path: AppRoutes.createNote, builder: (c, s) => const EditNotePage()),
      GoRoute(
        path: AppRoutes.editNote,
        builder: (c, s) => EditNotePage(noteId: int.tryParse(s.pathParameters['id'] ?? '')),
      ),
      GoRoute(
        path: AppRoutes.checklist,
        builder: (c, s) => ChecklistNotePage(noteId: int.tryParse(s.pathParameters['id'] ?? '')),
      ),
      GoRoute(path: AppRoutes.search, builder: (c, s) => const SearchPage()),
      GoRoute(path: AppRoutes.folders, builder: (c, s) => const FoldersPage()),
      GoRoute(path: AppRoutes.tags, builder: (c, s) => const TagsPage()),
      GoRoute(path: AppRoutes.archive, builder: (c, s) => const ArchivePage()),
      GoRoute(path: AppRoutes.trash, builder: (c, s) => const TrashPage()),
      GoRoute(path: AppRoutes.reminders, builder: (c, s) => const RemindersPage()),
      GoRoute(path: AppRoutes.settings, builder: (c, s) => const SettingsPage()),
    ],
  );
}
