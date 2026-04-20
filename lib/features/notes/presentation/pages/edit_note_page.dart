import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:noteflow/features/notes/domain/entities/note_entity.dart';
import 'package:noteflow/features/notes/presentation/providers/note_providers.dart';

class EditNotePage extends ConsumerStatefulWidget {
  final int? noteId;
  const EditNotePage({super.key, this.noteId});

  @override
  ConsumerState<EditNotePage> createState() => _EditNotePageState();
}

class _EditNotePageState extends ConsumerState<EditNotePage> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

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
    final note = ref.watch(editNoteProvider).value ?? NoteEntity(createdAt: DateTime.now(), updatedAt: DateTime.now());
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.noteId == null ? 'Create note' : 'Edit note'),
        actions: [IconButton(onPressed: _save, icon: const Icon(Icons.save_outlined))],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(hintText: 'Title (optional)'),
              onChanged: (v) => _patch(note.copyWith(title: v)),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: TextField(
                controller: _contentController,
                maxLines: null,
                expands: true,
                decoration: const InputDecoration(hintText: 'Write your note...'),
                onChanged: (v) => _patch(note.copyWith(content: v)),
              ),
            ),
          ],
        ),
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
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Empty note was ignored')));
      }
      context.pop();
    }
  }
}
