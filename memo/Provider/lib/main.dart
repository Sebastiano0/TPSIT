import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'model.dart';
import 'widgets.dart';
import 'todoProvider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TodoProvider>(
        create: (_) => TodoProvider(),
        child: MaterialApp(
          title: 'am032 todo list',
          theme: ThemeData(
            primarySwatch: Colors.red,
          ),
          home: const MyHomePage(title: 'am032 todo list'),
        ));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _textFieldController = TextEditingController();
  //final List<Todo> _todos = <Todo>[];

  void _handleTodoChange(Todo todo) {
    Provider.of<TodoProvider>(context, listen: false).toggleTodo(todo);
    // setState(() {
    //   todo.checked = !todo.checked;
    // });
  }

  void _handleTodoDelete(Todo todo) {
    Provider.of<TodoProvider>(context, listen: false).deleteTodo(todo);
    // setState(() {
    //   _todos.remove(todo);
    // });
  }

  Future<void> _displayDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('add todo item'),
          content: TextField(
            controller: _textFieldController,
            decoration: const InputDecoration(hintText: 'type here ...'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                Navigator.of(context).pop();
                _addTodoItem(_textFieldController.text);
              },
            ),
          ],
        );
      },
    );
  }

  void _addTodoItem(String name) {
    Provider.of<TodoProvider>(context, listen: false)
        .addTodo(Todo(name: name, checked: false));
    // setState(() {
    //   _todos.add(Todo(name: name, checked: false));
    // });
    _textFieldController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            itemCount: Provider.of<TodoProvider>(context).todos.length,
            itemBuilder: (context, index) {
              return TodoItem(
                todo: Provider.of<TodoProvider>(context).todos[index],
                onTodoChanged: _handleTodoChange,
                onTodoDelete: _handleTodoDelete,
              );
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _displayDialog(),
        tooltip: 'Add Item',
        child: const Icon(Icons.add),
      ),
    );
  }
}
