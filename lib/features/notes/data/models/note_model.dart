import 'package:isar/isar.dart';
import 'package:noteflow/features/notes/domain/entities/note_entity.dart';
import 'package:noteflow/shared/enums/note_type.dart';

part 'note_model.g.dart';

@collection
class NoteModel {
  Id id = Isar.autoIncrement;
  String title = '';
  String content = '';
  @enumerated
  NoteType type = NoteType.text;
  int color = 0xFFFFFFFF;
  int? folderId;
  List<int> tagIds = [];
  bool isPinned = false;
  bool isArchived = false;
  bool isDeleted = false;
  DateTime? reminderAt;
  DateTime createdAt = DateTime.now();
  DateTime updatedAt = DateTime.now();

  NoteEntity toEntity() => NoteEntity(
        id: id,
        title: title,
        content: content,
        type: type,
        color: color,
        folderId: folderId,
        tagIds: tagIds,
        isPinned: isPinned,
        isArchived: isArchived,
        isDeleted: isDeleted,
        reminderAt: reminderAt,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

  static NoteModel fromEntity(NoteEntity entity) {
    final m = NoteModel()
      ..title = entity.title
      ..content = entity.content
      ..type = entity.type
      ..color = entity.color
      ..folderId = entity.folderId
      ..tagIds = entity.tagIds
      ..isPinned = entity.isPinned
      ..isArchived = entity.isArchived
      ..isDeleted = entity.isDeleted
      ..reminderAt = entity.reminderAt
      ..createdAt = entity.createdAt
      ..updatedAt = entity.updatedAt;
    if (entity.id != null) m.id = entity.id!;
    return m;
  }
}
