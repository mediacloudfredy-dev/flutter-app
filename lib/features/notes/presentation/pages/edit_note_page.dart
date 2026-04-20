import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:noteflow/features/folders/presentation/providers/folder_providers.dart';
import 'package:noteflow/features/notes/domain/entities/note_entity.dart';
import 'package:noteflow/features/notes/presentation/providers/note_providers.dart';
import 'package:noteflow/features/tags/presentation/providers/tag_providers.dart';
import 'package:noteflow/shared/widgets/app_confirm_dialog.dart';

class EditNotePage extends ConsumerStatefulWidget {
  final int? noteId;
  const EditNotePage({super.key, this.noteId});

  @override
  ConsumerState<EditNotePage> createState() => _EditNotePageState();
}

class _EditNotePageState extends ConsumerState<EditNotePage> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  static const _colors = [
    0xFFFFFFFF,
    0xFFE8EAF6,
    0xFFE3F2FD,
    0xFFE8F5E9,
    0xFFFFF3E0,
    0xFFFCE4EC,
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(editNoteProvider.notifier).load(widget.noteId);
      final note = ref.read(editNoteProvider).value;
      if (note != null) {
        _titleController.text = note.title;
        _contentController.text = note.content;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final folders = ref.watch(folderListProvider).value ?? [];
    final tags = ref.watch(tagListProvider).value ?? [];
    final note = ref.watch(editNoteProvider).value ??
        NoteEntity(createdAt: DateTime.now(), updatedAt: DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.noteId == null ? 'Create note' : 'Edit note'),
        actions: [
          IconButton(
            onPressed: () async {
              final picked = await showDatePicker(
                context: context,
                firstDate: DateTime.now(),
                lastDate: DateTime(2100),
                initialDate: note.reminderAt ?? DateTime.now(),
              );
              if (picked == null || !mounted) return;
              final time = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.fromDateTime(
                  note.reminderAt ?? DateTime.now(),
                ),
              );
              if (time == null) return;
              final dt = DateTime(
                picked.year,
                picked.month,
                picked.day,
                time.hour,
                time.minute,
              );
              _patch(note.copyWith(reminderAt: dt));
            },
            icon: const Icon(Icons.alarm_add_outlined),
          ),
          IconButton(onPressed: _save, icon: const Icon(Icons.save_outlined)),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Wrap(
            spacing: 8,
            children: _colors
                .map(
                  (c) => ChoiceChip(
                    label: const Text(''),
                    selected: note.color == c,
                    onSelected: (_) => _patch(note.copyWith(color: c)),
                    avatar: CircleAvatar(backgroundColor: Color(c)),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<int?>(
            value: note.folderId,
            decoration: const InputDecoration(labelText: 'Folder'),
            items: [
              const DropdownMenuItem<int?>(value: null, child: Text('No folder')),
              ...folders.map((f) => DropdownMenuItem<int?>(value: f.id, child: Text(f.name))),
            ],
            onChanged: (v) => _patch(note.copyWith(folderId: v)),
          ),
          const SizedBox(height: 12),
          Text('Tags', style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: tags
                .map(
                  (t) => FilterChip(
                    selected: note.tagIds.contains(t.id),
                    label: Text('#${t.name}'),
                    onSelected: (selected) {
                      final next = [...note.tagIds];
                      if (selected) {
                        next.add(t.id);
                      } else {
                        next.remove(t.id);
                      }
                      _patch(note.copyWith(tagIds: next));
                    },
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              FilterChip(
                selected: note.isPinned,
                label: const Text('Pinned'),
                onSelected: (v) => _patch(note.copyWith(isPinned: v)),
              ),
              const SizedBox(width: 8),
              FilterChip(
                selected: note.isArchived,
                label: const Text('Archived'),
                onSelected: (v) => _patch(note.copyWith(isArchived: v)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(hintText: 'Title (optional)'),
            onChanged: (v) => _patch(note.copyWith(title: v)),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _contentController,
            minLines: 8,
            maxLines: null,
            decoration: const InputDecoration(hintText: 'Write your note...'),
            onChanged: (v) => _patch(note.copyWith(content: v)),
          ),
          const SizedBox(height: 16),
          if (widget.noteId != null)
            OutlinedButton.icon(
              onPressed: () async {
                final ok = await showConfirmDialog(
                  context,
                  title: 'Move to trash?',
                  message: 'You can restore it later from Trash.',
                  confirmText: 'Move',
                );
                if (!ok) return;
                await ref.read(noteRepositoryProvider).softDelete(widget.noteId!);
                ref.invalidate(noteListProvider);
                if (mounted) context.pop();
              },
              icon: const Icon(Icons.delete_outline),
              label: const Text('Move to trash'),
            ),
        ],
      ),
    );
  }

  void _patch(NoteEntity next) {
    ref.read(editNoteProvider.notifier).patch(next.copyWith(updatedAt: DateTime.now()));
  }

  Future<void> _save() async {
    final current = ref.read(editNoteProvider).value;
    if (current == null) return;
    final id = await ref.read(editNoteProvider.notifier).save();
    if (mounted) {
      if (id == -1) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Empty note was ignored')),
        );
      }
      context.pop();
    }
  }
}
