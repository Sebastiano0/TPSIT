import 'package:flutter/material.dart';
import 'package:timer/db/timer_database.dart';
import 'package:timer/model/timers.dart';
import 'package:timer/widget/timers_form_widget.dart';

class AddEditTimerPage extends StatefulWidget {
  final Timers? timer;

  const AddEditTimerPage({
    Key? key,
    this.timer,
  }) : super(key: key);
  @override
  AddEditTimerPageState createState() => AddEditTimerPageState();
}

class AddEditTimerPageState extends State<AddEditTimerPage> {
  final _formKey = GlobalKey<FormState>();
  late String duration;
  late String title;

  @override
  void initState() {
    super.initState();

    duration = widget.timer?.duration ?? '';
    title = widget.timer?.title ?? '';
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          actions: [buildButton()],
          backgroundColor: Colors.black,
        ),
        backgroundColor: Colors.black,
        body: Form(
          key: _formKey,
          child: TimerFormWidget(
            duration: duration,
            title: title,
            onChangedDuration: (duration) =>
                setState(() => this.duration = duration),
            onChangedTitle: (title) => setState(() => this.title = title),
          ),
        ),
      );

  Widget buildButton() {
    final isFormValid = title.isNotEmpty && duration.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: const Color.fromARGB(179, 182, 163, 163),
          backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        ),
        onPressed: addOrUpdateNote,
        child: const Text('Save'),
      ),
    );
  }

  void addOrUpdateNote() async {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      final isUpdating = widget.timer != null;

      if (isUpdating) {
        await updateNote();
      } else {
        await addNote();
      }

      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
    }
  }

  Future updateNote() async {
    final timer = widget.timer!.copy(
      duration: duration,
      title: title,
    );

    await TimerDatabase.instance.update(timer);
  }

  Future addNote() async {
    final note = Timers(
      title: title,
      duration: duration,
    );

    await TimerDatabase.instance.create(note);
  }
}
