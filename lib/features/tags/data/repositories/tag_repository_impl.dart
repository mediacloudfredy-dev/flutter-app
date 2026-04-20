import 'package:noteflow/core/services/database_service.dart';
import 'package:noteflow/features/tags/data/models/tag_model.dart';
import 'package:noteflow/features/tags/domain/repositories/tag_repository.dart';

class TagRepositoryImpl implements TagRepository {
  final _isar = DatabaseService.instance.isar;

  @override
  Future<List<TagModel>> getTags() => _isar.tagModels.where().sortByName().findAll();

  @override
  Future<void> save(String name, {int? id}) async {
    final tag = TagModel()..name = name.trim();
    if (id != null) tag.id = id;
    await _isar.writeTxn(() => _isar.tagModels.put(tag));
  }

  @override
  Future<void> delete(int id) async {
    await _isar.writeTxn(() async {
      await _isar.tagModels.delete(id);
      final notes = await _isar.noteModels.where().findAll();
      for (final n in notes) {
        n.tagIds = n.tagIds.where((tagId) => tagId != id).toList();
      }
      await _isar.noteModels.putAll(notes);
    });
  }
}
