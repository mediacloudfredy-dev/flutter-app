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
            ? const EmptyStateWidget(
                icon: Icons.alarm_off_outlined,
                title: 'No reminders',
                subtitle: 'Set reminders from note editor',
              )
            : ListView.builder(
                itemCount: items.length,
                itemBuilder: (_, i) {
                  final n = items[i];
                  return ListTile(
                    title: Text(n.title.isEmpty ? 'Untitled note' : n.title),
                    subtitle: Text(n.reminderAt?.toReadable() ?? '-'),
                    trailing: PopupMenuButton<String>(
                      onSelected: (v) async {
                        if (v == 'clear') {
                          await ref.read(noteRepositoryProvider).save(n.copyWith(reminderAt: null));
                        }
                        if (v == 'reschedule' && context.mounted) {
                          final picked = await showDatePicker(
                            context: context,
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2100),
                            initialDate: n.reminderAt ?? DateTime.now(),
                          );
                          if (picked == null || !context.mounted) return;
                          final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(n.reminderAt ?? DateTime.now()),
                          );
                          if (time == null) return;
                          final dt = DateTime(picked.year, picked.month, picked.day, time.hour, time.minute);
                          await ref.read(noteRepositoryProvider).save(n.copyWith(reminderAt: dt));
                        }
                        ref.invalidate(reminderNotesProvider);
                      },
                      itemBuilder: (_) => const [
                        PopupMenuItem(value: 'reschedule', child: Text('Reschedule')),
                        PopupMenuItem(value: 'clear', child: Text('Clear reminder')),
                      ],
                    ),
                  );
                },
              ),
        error: (_, __) => const Center(child: Text('Failed to load reminders')),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
