import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'dao.dart';
import 'model.dart';

class TodoModel extends ChangeNotifier {
  late final TodoDao _dao;
  late List<Todo> _todos = [];

  List<Todo> get todos => _todos;

  Future<void> initialize(BuildContext context) async {
    _dao = Provider.of<TodoDao>(context, listen: false);
    _todos = await _dao.getTodos();
  }

  void addTodoItem(String name, String due) {
    final todo = Todo(id: null, name: name, checked: false, dueDate: due);
    _dao.insertTodo(todo).then((value) {
      _todos.insert(0, todo);
      notifyListeners();
    });
  }

  void updateTodoItem(Todo todo) {
    todo.checked = !todo.checked;
    _dao.updateTodo(todo).then((value) {
      final existingTodoIndex =
          _todos.indexWhere((element) => element.id == todo.id);
      _todos[existingTodoIndex] = todo;
      notifyListeners();
    });
  }

  void deleteTodoItem(Todo todo) {
    _dao.deleteTodo(todo).then((value) {
      _todos.remove(todo);
      notifyListeners();
    });
  }
}
