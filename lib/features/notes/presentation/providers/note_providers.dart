import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noteflow/features/notes/data/repositories/checklist_repository_impl.dart';
import 'package:noteflow/features/notes/data/repositories/note_repository_impl.dart';
import 'package:noteflow/features/notes/domain/entities/checklist_item_entity.dart';
import 'package:noteflow/features/notes/domain/entities/note_entity.dart';
import 'package:noteflow/features/notes/domain/repositories/checklist_repository.dart';
import 'package:noteflow/features/notes/domain/repositories/note_repository.dart';
import 'package:noteflow/shared/enums/note_sort.dart';

final noteRepositoryProvider = Provider<NoteRepository>((ref) => NoteRepositoryImpl());
final checklistRepositoryProvider =
    Provider<ChecklistRepository>((ref) => ChecklistRepositoryImpl());

final noteSortProvider = StateProvider<NoteSort>((ref) => NoteSort.updatedDesc);
final selectedFolderFilterProvider = StateProvider<int?>((ref) => null);
final selectedTagFilterProvider = StateProvider<int?>((ref) => null);

final noteListProvider = FutureProvider<List<NoteEntity>>((ref) async {
  final repo = ref.watch(noteRepositoryProvider);
  final sort = ref.watch(noteSortProvider);
  final folderId = ref.watch(selectedFolderFilterProvider);
  final tagId = ref.watch(selectedTagFilterProvider);

  var notes = await repo.getActiveNotes();
  if (folderId != null) {
    notes = notes.where((n) => n.folderId == folderId).toList();
  }
  if (tagId != null) {
    notes = notes.where((n) => n.tagIds.contains(tagId)).toList();
  }

  notes.sort((a, b) {
    return switch (sort) {
      NoteSort.updatedDesc => b.updatedAt.compareTo(a.updatedAt),
      NoteSort.createdDesc => b.createdAt.compareTo(a.createdAt),
      NoteSort.titleAsc => a.title.toLowerCase().compareTo(b.title.toLowerCase()),
    };
  });
  return notes;
});

final archivedNotesProvider = FutureProvider<List<NoteEntity>>((ref) {
  return ref.watch(noteRepositoryProvider).getArchivedNotes();
});

final trashNotesProvider = FutureProvider<List<NoteEntity>>((ref) {
  return ref.watch(noteRepositoryProvider).getTrashNotes();
});

final reminderNotesProvider = FutureProvider<List<NoteEntity>>((ref) {
  return ref.watch(noteRepositoryProvider).getReminderNotes();
});

class SearchQueryNotifier extends AutoDisposeNotifier<String> {
  Timer? _debounce;

  @override
  String build() {
    ref.onDispose(() => _debounce?.cancel());
    return '';
  }

  void setQuery(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 250), () {
      state = value;
    });
  }
}

final searchQueryProvider =
    AutoDisposeNotifierProvider<SearchQueryNotifier, String>(
      SearchQueryNotifier.new,
    );

final searchNotesProvider = FutureProvider<List<NoteEntity>>((ref) async {
  final query = ref.watch(searchQueryProvider);
  if (query.isEmpty) return [];
  return ref.watch(noteRepositoryProvider).searchNotes(query);
});

class EditNoteNotifier extends AutoDisposeAsyncNotifier<NoteEntity> {
  @override
  Future<NoteEntity> build() async =>
      NoteEntity(createdAt: DateTime.now(), updatedAt: DateTime.now());

  Future<void> load(int? id) async {
    if (id == null) return;
    final note = await ref.read(noteRepositoryProvider).getById(id);
    if (note != null) state = AsyncData(note);
  }

  void patch(NoteEntity note) => state = AsyncData(note);

  Future<int> save() async {
    final note = state.value;
    if (note == null) return -1;
    final id = await ref.read(noteRepositoryProvider).save(note);
    ref.invalidate(noteListProvider);
    ref.invalidate(archivedNotesProvider);
    ref.invalidate(trashNotesProvider);
    ref.invalidate(reminderNotesProvider);
    return id;
  }
}

final editNoteProvider =
    AutoDisposeAsyncNotifierProvider<EditNoteNotifier, NoteEntity>(
      EditNoteNotifier.new,
    );

final checklistItemsProvider =
    FutureProvider.family<List<ChecklistItemEntity>, int>((ref, noteId) {
      return ref.watch(checklistRepositoryProvider).getByNoteId(noteId);
    });
