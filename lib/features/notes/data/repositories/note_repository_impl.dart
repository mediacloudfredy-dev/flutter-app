import 'package:isar/isar.dart';
import 'package:noteflow/core/services/database_service.dart';
import 'package:noteflow/core/services/notification_service.dart';
import 'package:noteflow/features/notes/data/models/note_model.dart';
import 'package:noteflow/features/notes/domain/entities/note_entity.dart';
import 'package:noteflow/features/notes/domain/repositories/note_repository.dart';

class NoteRepositoryImpl implements NoteRepository {
  final _isar = DatabaseService.instance.isar;

  @override
  Future<List<NoteEntity>> getActiveNotes() async {
    final list = await _isar.noteModels
        .filter()
        .isArchivedEqualTo(false)
        .and()
        .isDeletedEqualTo(false)
        .sortByIsPinnedDesc()
        .thenByUpdatedAtDesc()
        .findAll();
    return list.map((e) => e.toEntity()).toList();
  }

  @override
  Future<List<NoteEntity>> getArchivedNotes() async {
    final list = await _isar.noteModels.filter().isArchivedEqualTo(true).and().isDeletedEqualTo(false).findAll();
    return list.map((e) => e.toEntity()).toList();
  }

  @override
  Future<List<NoteEntity>> getTrashNotes() async {
    final list = await _isar.noteModels.filter().isDeletedEqualTo(true).sortByUpdatedAtDesc().findAll();
    return list.map((e) => e.toEntity()).toList();
  }

  @override
  Future<List<NoteEntity>> getReminderNotes() async {
    final list = await _isar.noteModels.filter().isDeletedEqualTo(false).and().reminderAtIsNotNull().sortByReminderAt().findAll();
    return list.map((e) => e.toEntity()).toList();
  }

  @override
  Future<List<NoteEntity>> searchNotes(String query) async {
    final q = query.trim();
    final list = await _isar.noteModels
        .filter()
        .isDeletedEqualTo(false)
        .and()
        .group((x) => x.titleContains(q, caseSensitive: false).or().contentContains(q, caseSensitive: false))
        .findAll();
    return list.map((e) => e.toEntity()).toList();
  }

  @override
  Future<NoteEntity?> getById(int id) async => (await _isar.noteModels.get(id))?.toEntity();

  @override
  Future<int> save(NoteEntity note) async {
    if (note.title.trim().isEmpty && note.content.trim().isEmpty) return -1;
    final model = NoteModel.fromEntity(note.copyWith(updatedAt: DateTime.now()));
    final id = await _isar.writeTxn(() => _isar.noteModels.put(model));
    if (model.reminderAt != null && !model.isDeleted) {
      await NotificationService.instance.schedule(
        id: id,
        title: model.title.isEmpty ? 'Note reminder' : model.title,
        body: model.content,
        when: model.reminderAt!,
      );
    }
    return id;
  }

  @override
  Future<void> softDelete(int id) async {
    await _isar.writeTxn(() async {
      final model = await _isar.noteModels.get(id);
      if (model == null) return;
      model
        ..isDeleted = true
        ..isArchived = false
        ..updatedAt = DateTime.now()
        ..reminderAt = null;
      await _isar.noteModels.put(model);
    });
    await NotificationService.instance.cancel(id);
  }

  @override
  Future<void> deletePermanent(int id) async {
    await _isar.writeTxn(() => _isar.noteModels.delete(id));
    await NotificationService.instance.cancel(id);
  }

  @override
  Future<void> toggleArchive(int id, bool archived) async {
    await _isar.writeTxn(() async {
      final model = await _isar.noteModels.get(id);
      if (model == null || model.isDeleted) return;
      model
        ..isArchived = archived
        ..updatedAt = DateTime.now();
      await _isar.noteModels.put(model);
    });
  }

  @override
  Future<void> togglePin(int id, bool pinned) async {
    await _isar.writeTxn(() async {
      final model = await _isar.noteModels.get(id);
      if (model == null || model.isDeleted) return;
      model
        ..isPinned = pinned
        ..updatedAt = DateTime.now();
      await _isar.noteModels.put(model);
    });
  }

  @override
  Future<void> restore(int id) async {
    await _isar.writeTxn(() async {
      final model = await _isar.noteModels.get(id);
      if (model == null) return;
      model
        ..isDeleted = false
        ..updatedAt = DateTime.now();
      await _isar.noteModels.put(model);
    });
  }

  @override
  Future<void> emptyTrash() async {
    final trash = await _isar.noteModels.filter().isDeletedEqualTo(true).findAll();
    await _isar.writeTxn(() => _isar.noteModels.deleteAll(trash.map((e) => e.id).toList()));
  }
}
