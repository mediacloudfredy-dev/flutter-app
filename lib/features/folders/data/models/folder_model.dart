import 'package:isar/isar.dart';

part 'folder_model.g.dart';

@collection
class FolderModel {
  Id id = Isar.autoIncrement;
  late String name;
  DateTime createdAt = DateTime.now();
}
