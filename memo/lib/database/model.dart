import 'package:floor/floor.dart';

@entity
class Todo {
  Todo({
    required this.id,
    required this.name,
    this.checked = false,
    required this.dueDate,
  });

  @primaryKey
  final int? id;

  final String name;
  bool checked;
  String dueDate;
}
