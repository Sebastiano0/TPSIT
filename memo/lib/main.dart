import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'todoModel.dart';
import 'dao.dart';
import 'database.dart';
import 'model.dart';
import 'widgets.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AppDatabase>(
      future: $FloorAppDatabase.databaseBuilder('app_database.db').build(),
      builder: (BuildContext context, AsyncSnapshot<AppDatabase> snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }
        final AppDatabase database = snapshot.data!;
        return MultiProvider(
          providers: [
            Provider<AppDatabase>(create: (_) => database),
            ProxyProvider<AppDatabase, TodoDao>(
              update: (_, db, dao) => db.todoDao,
            ),
            ChangeNotifierProvider<TodoModel>(
              create: (_) => TodoModel(),
            ),
          ],
          child: MaterialApp(
            title: 'memo',
            theme: ThemeData(
              primarySwatch: Colors.red,
            ),
            home: const MyHomePage(title: 'am023 todo list floor'),
          ),
        );
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    final todoModel = Provider.of<TodoModel>(context, listen: false);
    todoModel.initialize(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Consumer<TodoModel>(
        builder: (context, model, _) => Center(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            itemCount: model.todos.length,
            itemBuilder: (context, index) {
              return TodoItem(
                todo: model.todos[index],
                onTodoChanged: model.updateTodoItem,
                onTodoDelete: model.deleteTodoItem,
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _displayDialog(context),
        tooltip: 'Add Item',
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _displayDialog(BuildContext context) async {
    final textFieldController = TextEditingController();
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('add todo item'),
          content: TextField(
            controller: textFieldController,
            decoration: const InputDecoration(hintText: 'type here ...'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                Navigator.of(context).pop();
                Provider.of<TodoModel>(context, listen: false)
                    .addTodoItem(textFieldController.text);
                textFieldController.clear();
              },
            ),
          ],
        );
      },
    );
  }
}
