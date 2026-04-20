import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:noteflow/app/router/app_routes.dart';
import 'package:noteflow/core/services/local_prefs_service.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _controller = PageController();
  int _index = 0;

  final _slides = const [
    ('Capture ideas quickly', 'Write notes in seconds and keep your day organized.'),
    ('Stay focused', 'Pin, archive, and sort notes with simple structure.'),
    ('Never miss a task', 'Use reminders for time-sensitive notes.'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(onPressed: _finish, child: const Text('Skip')),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  itemCount: _slides.length,
                  onPageChanged: (i) => setState(() => _index = i),
                  itemBuilder: (_, i) => Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.sticky_note_2_outlined, size: 72),
                      const SizedBox(height: 24),
                      Text(_slides[i].$1, style: Theme.of(context).textTheme.headlineSmall, textAlign: TextAlign.center),
                      const SizedBox(height: 12),
                      Text(_slides[i].$2, textAlign: TextAlign.center),
                    ],
                  ),
                ),
              ),
              Row(
                children: [
                  ...List.generate(
                    _slides.length,
                    (i) => Container(
                      margin: const EdgeInsets.only(right: 6),
                      width: _index == i ? 20 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _index == i ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.outlineVariant,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const Spacer(),
                  FilledButton(
                    onPressed: _index == _slides.length - 1
                        ? _finish
                        : () => _controller.nextPage(duration: const Duration(milliseconds: 250), curve: Curves.easeOut),
                    child: Text(_index == _slides.length - 1 ? 'Finish' : 'Next'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _finish() async {
    await LocalPrefsService().setOnboardingDone();
    if (mounted) context.go(AppRoutes.home);
  }
}
