import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'database/todoModel.dart';
import 'database/dao.dart';
import 'database/database.dart';
import 'noti.dart';
import 'widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() async {
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
            home: MyHomePage(title: 'Todo'),
          ),
        );
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final _dateController = TextEditingController();
  DateTime? _selectedDateTime;
  TimeOfDay? selectedTime;
  NotificationHelper noti = NotificationHelper();
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
          title: const Text('Add Todo Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: textFieldController,
                decoration: const InputDecoration(hintText: 'Type here...'),
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  const Icon(Icons.calendar_today),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Due Date',
                      ),
                      controller: _dateController,
                      onTap: () => _selectDate(context),
                      readOnly: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Date cannot be blank';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                noti.initializeNotification();
                Navigator.of(context).pop();
                print(_dateController.text);
                final time = selectedTime!;
                print(time);
                final hour = int.parse(time.toString().substring(
                    time.toString().indexOf("(") + 1,
                    time.toString().indexOf(":")));
                final minutes = int.parse(time.toString().substring(
                    time.toString().indexOf(":") + 1,
                    time.toString().indexOf(")")));
                final id = Random().nextInt(1000000);

                const sound = 'sound'; // nome del file audio della notifica

                noti.scheduleNotification(
                    hour: hour,
                    minutes: minutes,
                    id: id,
                    sound: sound,
                    title: textFieldController.text,
                    body: "Il tuo todo ti aspetta");
                Provider.of<TodoModel>(context, listen: false).addTodoItem(
                    textFieldController.text, _dateController.text);
                textFieldController.clear();
                _dateController.clear();
              },
            ),
          ],
        );
      },
    );
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null) {
      _selectedDateTime = picked;
      _dateController.text = "${picked.day}/${picked.month}/${picked.year}";
      _selectTime(context);
    }
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      selectedTime = picked;
      print(selectedTime);
      var hour = picked.hour.toString();
      var minute = picked.minute.toString();
      var time = '    $hour:$minute';
      _dateController.text += time;
    }
  }

  Future<void> sendNotification(Widget widget) async {}
}
