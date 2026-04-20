import 'package:noteflow/features/notes/domain/entities/checklist_item_entity.dart';

abstract class ChecklistRepository {
  Future<List<ChecklistItemEntity>> getByNoteId(int noteId);
  Future<int> save(ChecklistItemEntity item);
  Future<void> delete(int id);
  Future<void> reorder(int noteId, List<ChecklistItemEntity> items);
}
