import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noteflow/features/folders/presentation/providers/folder_providers.dart';

class FoldersPage extends ConsumerWidget {
  const FoldersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final folders = ref.watch(folderListProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Folders')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showEditDialog(context, ref),
        child: const Icon(Icons.create_new_folder_outlined),
      ),
      body: folders.when(
        data: (items) => ListView.builder(
          itemCount: items.length,
          itemBuilder: (_, i) => ListTile(
            title: Text(items[i].name),
            trailing: PopupMenuButton<String>(
              onSelected: (v) async {
                if (v == 'edit') _showEditDialog(context, ref, id: items[i].id, initial: items[i].name);
                if (v == 'delete') {
                  await ref.read(folderRepositoryProvider).delete(items[i].id);
                  ref.invalidate(folderListProvider);
                }
              },
              itemBuilder: (_) => const [
                PopupMenuItem(value: 'edit', child: Text('Rename')),
                PopupMenuItem(value: 'delete', child: Text('Delete')),
              ],
            ),
          ),
        ),
        error: (_, __) => const SizedBox.shrink(),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Future<void> _showEditDialog(BuildContext context, WidgetRef ref, {int? id, String initial = ''}) async {
    final c = TextEditingController(text: initial);
    await showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(id == null ? 'New folder' : 'Rename folder'),
        content: TextField(controller: c),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(
            onPressed: () async {
              if (c.text.trim().isEmpty) return;
              await ref.read(folderRepositoryProvider).save(c.text, id: id);
              ref.invalidate(folderListProvider);
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
