import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noteflow/features/tags/presentation/providers/tag_providers.dart';

class TagsPage extends ConsumerWidget {
  const TagsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tags = ref.watch(tagListProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Tags')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showDialogTag(context, ref),
        child: const Icon(Icons.sell_outlined),
      ),
      body: tags.when(
        data: (items) => ListView.builder(
          itemCount: items.length,
          itemBuilder: (_, i) => ListTile(
            title: Text('#${items[i].name}'),
            trailing: PopupMenuButton<String>(
              onSelected: (v) async {
                if (v == 'edit') _showDialogTag(context, ref, id: items[i].id, initial: items[i].name);
                if (v == 'delete') {
                  await ref.read(tagRepositoryProvider).delete(items[i].id);
                  ref.invalidate(tagListProvider);
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

  Future<void> _showDialogTag(BuildContext context, WidgetRef ref, {int? id, String initial = ''}) async {
    final c = TextEditingController(text: initial);
    await showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(id == null ? 'New tag' : 'Rename tag'),
        content: TextField(controller: c),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(
            onPressed: () async {
              if (c.text.trim().isEmpty) return;
              await ref.read(tagRepositoryProvider).save(c.text, id: id);
              ref.invalidate(tagListProvider);
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
