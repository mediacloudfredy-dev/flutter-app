import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noteflow/features/notes/presentation/providers/note_providers.dart';
import 'package:noteflow/features/notes/presentation/widgets/note_card.dart';
import 'package:noteflow/shared/widgets/app_confirm_dialog.dart';
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
              final ok = await showConfirmDialog(
                context,
                title: 'Empty trash?',
                message: 'This action cannot be undone.',
                confirmText: 'Delete all',
              );
              if (!ok) return;
              await ref.read(noteRepositoryProvider).emptyTrash();
              ref.invalidate(trashNotesProvider);
            },
            child: const Text('Empty'),
          ),
        ],
      ),
      body: trash.when(
        data: (items) => items.isEmpty
            ? const EmptyStateWidget(
                icon: Icons.delete_outline,
                title: 'Trash is empty',
                subtitle: 'Deleted notes stay here',
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: items.length,
                itemBuilder: (_, i) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: NoteCard(
                    note: items[i],
                    onLongPress: () async {
                      final id = items[i].id;
                      if (id == null) return;
                      await showModalBottomSheet<void>(
                        context: context,
                        builder: (_) => SafeArea(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                leading: const Icon(Icons.restore),
                                title: const Text('Restore'),
                                onTap: () async {
                                  await ref.read(noteRepositoryProvider).restore(id);
                                  ref.invalidate(trashNotesProvider);
                                  ref.invalidate(noteListProvider);
                                  if (context.mounted) Navigator.pop(context);
                                },
                              ),
                              ListTile(
                                leading: const Icon(Icons.delete_forever_outlined),
                                title: const Text('Delete permanently'),
                                onTap: () async {
                                  await ref.read(noteRepositoryProvider).deletePermanent(id);
                                  ref.invalidate(trashNotesProvider);
                                  if (context.mounted) Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
        error: (_, __) => const Center(child: Text('Failed to load trash')),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
