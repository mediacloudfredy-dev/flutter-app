import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noteflow/features/notes/domain/entities/checklist_item_entity.dart';
import 'package:noteflow/features/notes/presentation/providers/note_providers.dart';

class ChecklistNotePage extends ConsumerStatefulWidget {
  final int? noteId;
  const ChecklistNotePage({super.key, this.noteId});

  @override
  ConsumerState<ChecklistNotePage> createState() => _ChecklistNotePageState();
}

class _ChecklistNotePageState extends ConsumerState<ChecklistNotePage> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final noteId = widget.noteId;
    if (noteId == null) {
      return const Scaffold(body: Center(child: Text('Checklist note id is required')));
    }
    final itemsAsync = ref.watch(checklistItemsProvider(noteId));

    return Scaffold(
      appBar: AppBar(title: const Text('Checklist Note')),
      body: itemsAsync.when(
        data: (items) {
          final done = items.where((e) => e.isChecked).length;
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                LinearProgressIndicator(value: items.isEmpty ? 0 : done / items.length),
                const SizedBox(height: 8),
                Text('$done/${items.length} completed'),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: const InputDecoration(hintText: 'Add checklist item'),
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        final text = _controller.text.trim();
                        if (text.isEmpty) return;
                        await ref.read(checklistRepositoryProvider).save(
                          ChecklistItemEntity(noteId: noteId, text: text, position: items.length),
                        );
                        _controller.clear();
                        ref.invalidate(checklistItemsProvider(noteId));
                      },
                      icon: const Icon(Icons.add_circle_outline),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: ReorderableListView.builder(
                    itemCount: items.length,
                    onReorder: (oldIndex, newIndex) async {
                      final copied = [...items];
                      if (newIndex > oldIndex) newIndex--;
                      final item = copied.removeAt(oldIndex);
                      copied.insert(newIndex, item);
                      await ref.read(checklistRepositoryProvider).reorder(noteId, copied);
                      ref.invalidate(checklistItemsProvider(noteId));
                    },
                    itemBuilder: (_, i) {
                      final item = items[i];
                      return CheckboxListTile(
                        key: ValueKey(item.id),
                        value: item.isChecked,
                        title: Text(item.text),
                        onChanged: (v) async {
                          await ref.read(checklistRepositoryProvider).save(item.copyWith(isChecked: v ?? false));
                          ref.invalidate(checklistItemsProvider(noteId));
                        },
                        secondary: IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () async {
                            if (item.id == null) return;
                            await ref.read(checklistRepositoryProvider).delete(item.id!);
                            ref.invalidate(checklistItemsProvider(noteId));
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
        error: (_, __) => const Center(child: Text('Failed to load checklist')),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
