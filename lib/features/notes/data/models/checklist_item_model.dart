import 'package:isar/isar.dart';

part 'checklist_item_model.g.dart';

@collection
class ChecklistItemModel {
  Id id = Isar.autoIncrement;
  late int noteId;
  String text = '';
  bool isChecked = false;
  int position = 0;
}
