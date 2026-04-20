import 'package:noteflow/core/services/database_service.dart';
import 'package:noteflow/features/notes/data/models/checklist_item_model.dart';
import 'package:noteflow/features/notes/domain/entities/checklist_item_entity.dart';
import 'package:noteflow/features/notes/domain/repositories/checklist_repository.dart';

class ChecklistRepositoryImpl implements ChecklistRepository {
  final _isar = DatabaseService.instance.isar;

  @override
  Future<List<ChecklistItemEntity>> getByNoteId(int noteId) async {
    final models = await _isar.checklistItemModels
        .filter()
        .noteIdEqualTo(noteId)
        .sortByPosition()
        .findAll();
    return models
        .map(
          (m) => ChecklistItemEntity(
            id: m.id,
            noteId: m.noteId,
            text: m.text,
            isChecked: m.isChecked,
            position: m.position,
          ),
        )
        .toList();
  }

  @override
  Future<int> save(ChecklistItemEntity item) async {
    final model = ChecklistItemModel()
      ..noteId = item.noteId
      ..text = item.text
      ..isChecked = item.isChecked
      ..position = item.position;
    if (item.id != null) model.id = item.id!;
    return _isar.writeTxn(() => _isar.checklistItemModels.put(model));
  }

  @override
  Future<void> delete(int id) async {
    await _isar.writeTxn(() => _isar.checklistItemModels.delete(id));
  }

  @override
  Future<void> reorder(int noteId, List<ChecklistItemEntity> items) async {
    await _isar.writeTxn(() async {
      final models = <ChecklistItemModel>[];
      for (var i = 0; i < items.length; i++) {
        final item = items[i];
        final model = ChecklistItemModel()
          ..noteId = noteId
          ..text = item.text
          ..isChecked = item.isChecked
          ..position = i;
        if (item.id != null) model.id = item.id!;
        models.add(model);
      }
      await _isar.checklistItemModels.putAll(models);
    });
  }
}
