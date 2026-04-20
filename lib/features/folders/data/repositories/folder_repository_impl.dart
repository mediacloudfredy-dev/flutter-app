import 'package:noteflow/core/services/database_service.dart';
import 'package:noteflow/features/folders/data/models/folder_model.dart';
import 'package:noteflow/features/folders/domain/repositories/folder_repository.dart';

class FolderRepositoryImpl implements FolderRepository {
  final _isar = DatabaseService.instance.isar;

  @override
  Future<List<FolderModel>> getFolders() => _isar.folderModels.where().sortByName().findAll();

  @override
  Future<void> save(String name, {int? id}) async {
    final folder = FolderModel()..name = name.trim();
    if (id != null) folder.id = id;
    await _isar.writeTxn(() => _isar.folderModels.put(folder));
  }

  @override
  Future<void> delete(int id) async {
    await _isar.writeTxn(() async {
      await _isar.folderModels.delete(id);
      final notes = await _isar.noteModels.filter().folderIdEqualTo(id).findAll();
      for (final n in notes) {
        n.folderId = null;
      }
      await _isar.noteModels.putAll(notes);
    });
  }
}
