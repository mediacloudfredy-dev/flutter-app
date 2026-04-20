import 'package:noteflow/features/tags/data/models/tag_model.dart';

abstract class TagRepository {
  Future<List<TagModel>> getTags();
  Future<void> save(String name, {int? id});
  Future<void> delete(int id);
}
