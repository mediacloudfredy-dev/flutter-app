import 'package:isar/isar.dart';

part 'tag_model.g.dart';

@collection
class TagModel {
  Id id = Isar.autoIncrement;
  late String name;
  DateTime createdAt = DateTime.now();
}
