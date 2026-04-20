import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:noteflow/features/notes/presentation/providers/note_providers.dart';
import 'package:noteflow/features/notes/presentation/widgets/note_card.dart';
import 'package:noteflow/shared/widgets/app_search_field.dart';
import 'package:noteflow/shared/widgets/empty_state_widget.dart';

class SearchPage extends ConsumerWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final results = ref.watch(searchNotesProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Search')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            AppSearchField(onChanged: (v) => ref.read(searchQueryProvider.notifier).setQuery(v)),
            const SizedBox(height: 12),
            Expanded(
              child: results.when(
                data: (items) => items.isEmpty
                    ? const EmptyStateWidget(icon: Icons.search_off, title: 'No results', subtitle: 'Try another keyword')
                    : ListView.separated(
                        itemCount: items.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (_, i) => NoteCard(note: items[i], onTap: () => context.push('/notes/${items[i].id}')),
                      ),
                error: (_, __) => const Center(child: Text('Failed to search')),
                loading: () => const Center(child: CircularProgressIndicator()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
