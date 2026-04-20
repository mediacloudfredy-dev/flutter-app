import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noteflow/features/notes/data/repositories/note_repository_impl.dart';
import 'package:noteflow/features/notes/domain/entities/note_entity.dart';
import 'package:noteflow/features/notes/domain/repositories/note_repository.dart';

final noteRepositoryProvider = Provider<NoteRepository>((ref) => NoteRepositoryImpl());

final noteListProvider = FutureProvider<List<NoteEntity>>((ref) {
  return ref.watch(noteRepositoryProvider).getActiveNotes();
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

final searchQueryProvider = StateProvider<String>((ref) => '');

final searchNotesProvider = FutureProvider<List<NoteEntity>>((ref) async {
  final query = ref.watch(searchQueryProvider);
  if (query.isEmpty) return [];
  return ref.watch(noteRepositoryProvider).searchNotes(query);
});

class EditNoteNotifier extends AutoDisposeAsyncNotifier<NoteEntity> {
  @override
  Future<NoteEntity> build() async => NoteEntity(createdAt: DateTime.now(), updatedAt: DateTime.now());

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

final editNoteProvider = AutoDisposeAsyncNotifierProvider<EditNoteNotifier, NoteEntity>(EditNoteNotifier.new);
