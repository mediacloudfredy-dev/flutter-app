import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noteflow/core/extensions/date_time_x.dart';
import 'package:noteflow/features/notes/presentation/providers/note_providers.dart';
import 'package:noteflow/shared/widgets/empty_state_widget.dart';

class RemindersPage extends ConsumerWidget {
  const RemindersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reminders = ref.watch(reminderNotesProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Reminders')),
      body: reminders.when(
        data: (items) => items.isEmpty
            ? const EmptyStateWidget(icon: Icons.alarm_off_outlined, title: 'No reminders', subtitle: 'Set reminders from note editor')
            : ListView.builder(
                itemCount: items.length,
                itemBuilder: (_, i) {
                  final n = items[i];
                  return ListTile(
                    title: Text(n.title.isEmpty ? 'Untitled note' : n.title),
                    subtitle: Text(n.reminderAt?.toReadable() ?? '-'),
                    trailing: IconButton(
                      onPressed: () async {
                        await ref.read(noteRepositoryProvider).save(n.copyWith(reminderAt: null));
                        ref.invalidate(reminderNotesProvider);
                      },
                      icon: const Icon(Icons.cancel_outlined),
                    ),
                  );
                },
              ),
        error: (_, __) => const SizedBox.shrink(),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
