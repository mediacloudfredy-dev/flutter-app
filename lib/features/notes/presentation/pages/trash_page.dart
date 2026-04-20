import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noteflow/features/notes/presentation/providers/note_providers.dart';
import 'package:noteflow/features/notes/presentation/widgets/note_card.dart';
import 'package:noteflow/shared/widgets/empty_state_widget.dart';

class TrashPage extends ConsumerWidget {
  const TrashPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trash = ref.watch(trashNotesProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trash'),
        actions: [
          TextButton(
            onPressed: () async {
              await ref.read(noteRepositoryProvider).emptyTrash();
              ref.invalidate(trashNotesProvider);
            },
            child: const Text('Empty'),
          ),
        ],
      ),
      body: trash.when(
        data: (items) => items.isEmpty
            ? const EmptyStateWidget(icon: Icons.delete_outline, title: 'Trash is empty', subtitle: 'Deleted notes stay here')
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: items.length,
                itemBuilder: (_, i) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: NoteCard(note: items[i]),
                ),
              ),
        error: (_, __) => const SizedBox.shrink(),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
