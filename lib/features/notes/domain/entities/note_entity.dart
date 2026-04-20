import 'package:noteflow/shared/enums/note_type.dart';

class NoteEntity {
  final int? id;
  final String title;
  final String content;
  final NoteType type;
  final int color;
  final int? folderId;
  final List<int> tagIds;
  final bool isPinned;
  final bool isArchived;
  final bool isDeleted;
  final DateTime? reminderAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  const NoteEntity({
    this.id,
    this.title = '',
    this.content = '',
    this.type = NoteType.text,
    this.color = 0xFFFFFFFF,
    this.folderId,
    this.tagIds = const [],
    this.isPinned = false,
    this.isArchived = false,
    this.isDeleted = false,
    this.reminderAt,
    required this.createdAt,
    required this.updatedAt,
  });

  NoteEntity copyWith({
    int? id,
    String? title,
    String? content,
    NoteType? type,
    int? color,
    int? folderId,
    List<int>? tagIds,
    bool? isPinned,
    bool? isArchived,
    bool? isDeleted,
    DateTime? reminderAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return NoteEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      type: type ?? this.type,
      color: color ?? this.color,
      folderId: folderId ?? this.folderId,
      tagIds: tagIds ?? this.tagIds,
      isPinned: isPinned ?? this.isPinned,
      isArchived: isArchived ?? this.isArchived,
      isDeleted: isDeleted ?? this.isDeleted,
      reminderAt: reminderAt ?? this.reminderAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
