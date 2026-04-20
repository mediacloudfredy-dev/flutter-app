import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noteflow/features/notes/presentation/providers/note_providers.dart';
import 'package:noteflow/features/notes/presentation/widgets/note_card.dart';
import 'package:noteflow/shared/widgets/empty_state_widget.dart';

class ArchivePage extends ConsumerWidget {
  const ArchivePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final archived = ref.watch(archivedNotesProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Archive')),
      body: archived.when(
        data: (items) => items.isEmpty
            ? const EmptyStateWidget(icon: Icons.archive_outlined, title: 'Archive empty', subtitle: 'Archived notes will appear here')
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
