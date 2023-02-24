import 'package:floor/floor.dart';

@entity
class Todo {
  Todo({required this.id, required this.name, this.checked = false});

  @primaryKey
  final int? id;

  final String name;
  bool checked;
}
