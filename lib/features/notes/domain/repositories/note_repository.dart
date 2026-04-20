import 'package:noteflow/features/notes/domain/entities/note_entity.dart';

abstract class NoteRepository {
  Future<List<NoteEntity>> getActiveNotes();
  Future<List<NoteEntity>> getArchivedNotes();
  Future<List<NoteEntity>> getTrashNotes();
  Future<List<NoteEntity>> getReminderNotes();
  Future<List<NoteEntity>> searchNotes(String query);
  Future<NoteEntity?> getById(int id);
  Future<int> save(NoteEntity note);
  Future<void> softDelete(int id);
  Future<void> deletePermanent(int id);
  Future<void> toggleArchive(int id, bool archived);
  Future<void> togglePin(int id, bool pinned);
  Future<void> restore(int id);
  Future<void> emptyTrash();
}
