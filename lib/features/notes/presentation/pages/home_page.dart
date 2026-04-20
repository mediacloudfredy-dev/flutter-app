import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:noteflow/app/router/app_routes.dart';
import 'package:noteflow/features/folders/presentation/providers/folder_providers.dart';
import 'package:noteflow/features/notes/presentation/providers/note_providers.dart';
import 'package:noteflow/features/notes/presentation/widgets/note_action_sheet.dart';
import 'package:noteflow/features/notes/presentation/widgets/note_card.dart';
import 'package:noteflow/features/settings/presentation/providers/settings_provider.dart';
import 'package:noteflow/features/tags/presentation/providers/tag_providers.dart';
import 'package:noteflow/shared/enums/note_sort.dart';
import 'package:noteflow/shared/widgets/empty_state_widget.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notes = ref.watch(noteListProvider);
    final settings = ref.watch(settingsProvider);
    final sort = ref.watch(noteSortProvider);
    final folders = ref.watch(folderListProvider).value ?? [];
    final tags = ref.watch(tagListProvider).value ?? [];
    final selectedFolder = ref.watch(selectedFolderFilterProvider);
    final selectedTag = ref.watch(selectedTagFilterProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('NoteFlow'),
        actions: [
          PopupMenuButton<NoteSort>(
            icon: const Icon(Icons.sort),
            initialValue: sort,
            onSelected: (v) => ref.read(noteSortProvider.notifier).state = v,
            itemBuilder: (_) => const [
              PopupMenuItem(value: NoteSort.updatedDesc, child: Text('Updated newest')),
              PopupMenuItem(value: NoteSort.createdDesc, child: Text('Created newest')),
              PopupMenuItem(value: NoteSort.titleAsc, child: Text('Title A-Z')),
            ],
          ),
          IconButton(
            onPressed: () => context.push(AppRoutes.search),
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () => context.push(AppRoutes.archive),
            icon: const Icon(Icons.archive_outlined),
          ),
          IconButton(
            onPressed: () => context.push(AppRoutes.settings),
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(child: Text('NoteFlow')),
            ListTile(
              title: const Text('Folders'),
              onTap: () => context.push(AppRoutes.folders),
            ),
            ListTile(
              title: const Text('Tags'),
              onTap: () => context.push(AppRoutes.tags),
            ),
            ListTile(
              title: const Text('Reminders'),
              onTap: () => context.push(AppRoutes.reminders),
            ),
            ListTile(
              title: const Text('Trash'),
              onTap: () => context.push(AppRoutes.trash),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(AppRoutes.createNote),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              children: [
                FilterChip(
                  selected: selectedFolder == null,
                  label: const Text('All folders'),
                  onSelected: (_) =>
                      ref.read(selectedFolderFilterProvider.notifier).state = null,
                ),
                const SizedBox(width: 8),
                ...folders.map(
                  (f) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      selected: selectedFolder == f.id,
                      label: Text(f.name),
                      onSelected: (_) =>
                          ref.read(selectedFolderFilterProvider.notifier).state =
                              selectedFolder == f.id ? null : f.id,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Row(
              children: [
                FilterChip(
                  selected: selectedTag == null,
                  label: const Text('All tags'),
                  onSelected: (_) =>
                      ref.read(selectedTagFilterProvider.notifier).state = null,
                ),
                const SizedBox(width: 8),
                ...tags.map(
                  (t) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      selected: selectedTag == t.id,
                      label: Text('#${t.name}'),
                      onSelected: (_) =>
                          ref.read(selectedTagFilterProvider.notifier).state =
                              selectedTag == t.id ? null : t.id,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: notes.when(
              data: (items) {
                if (items.isEmpty) {
                  return const EmptyStateWidget(
                    icon: Icons.sticky_note_2_outlined,
                    title: 'No notes yet',
                    subtitle: 'Tap + to create your first note',
                  );
                }
                if (settings.useGridLayout) {
                  return GridView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: items.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1.1,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                    itemBuilder: (_, i) => NoteCard(
                      note: items[i],
                      onTap: () => context.push('/notes/${items[i].id}'),
                      onLongPress: () =>
                          showNoteActionSheet(context, ref, items[i]),
                    ),
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (_, i) => NoteCard(
                    note: items[i],
                    onTap: () => context.push('/notes/${items[i].id}'),
                    onLongPress: () =>
                        showNoteActionSheet(context, ref, items[i]),
                  ),
                );
              },
              error: (_, __) => const Center(child: Text('Failed to load notes')),
              loading: () => const Center(child: CircularProgressIndicator()),
            ),
          ),
        ],
      ),
    );
  }
}
