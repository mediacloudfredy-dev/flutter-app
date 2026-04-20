import 'package:isar/isar.dart';
import 'package:noteflow/features/folders/data/models/folder_model.dart';
import 'package:noteflow/features/notes/data/models/checklist_item_model.dart';
import 'package:noteflow/features/notes/data/models/note_model.dart';
import 'package:noteflow/features/tags/data/models/tag_model.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseService {
  DatabaseService._();
  static final instance = DatabaseService._();

  late final Isar isar;

  Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open(
      [NoteModelSchema, ChecklistItemModelSchema, FolderModelSchema, TagModelSchema],
      directory: dir.path,
    );
  }
}
