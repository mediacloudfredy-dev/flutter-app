import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noteflow/features/notes/domain/entities/note_entity.dart';
import 'package:noteflow/features/notes/presentation/providers/note_providers.dart';

Future<void> showNoteActionSheet(
  BuildContext context,
  WidgetRef ref,
  NoteEntity note,
) async {
  await showModalBottomSheet<void>(
    context: context,
    builder: (_) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.push_pin_outlined),
            title: Text(note.isPinned ? 'Unpin' : 'Pin'),
            onTap: () async {
              await ref
                  .read(noteRepositoryProvider)
                  .togglePin(note.id!, !note.isPinned);
              ref.invalidate(noteListProvider);
              if (context.mounted) Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.archive_outlined),
            title: Text(note.isArchived ? 'Unarchive' : 'Archive'),
            onTap: () async {
              await ref
                  .read(noteRepositoryProvider)
                  .toggleArchive(note.id!, !note.isArchived);
              ref.invalidate(noteListProvider);
              ref.invalidate(archivedNotesProvider);
              if (context.mounted) Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete_outline),
            title: const Text('Move to trash'),
            onTap: () async {
              await ref.read(noteRepositoryProvider).softDelete(note.id!);
              ref.invalidate(noteListProvider);
              ref.invalidate(trashNotesProvider);
              if (context.mounted) Navigator.pop(context);
            },
          ),
        ],
      ),
    ),
  );
}
