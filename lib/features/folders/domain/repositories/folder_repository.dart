import 'package:noteflow/features/folders/data/models/folder_model.dart';

abstract class FolderRepository {
  Future<List<FolderModel>> getFolders();
  Future<void> save(String name, {int? id});
  Future<void> delete(int id);
}
