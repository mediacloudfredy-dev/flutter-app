import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:noteflow/app/router/app_routes.dart';
import 'package:noteflow/core/services/local_prefs_service.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    final seen = await LocalPrefsService().isOnboardingDone();
    if (!mounted) return;
    context.go(seen ? AppRoutes.home : AppRoutes.onboarding);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.sticky_note_2_rounded, size: 72),
            SizedBox(height: 12),
            Text('NoteFlow'),
          ],
        ),
      ),
    );
  }
}
