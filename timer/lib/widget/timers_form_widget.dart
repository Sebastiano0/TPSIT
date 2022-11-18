import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TimerFormWidget extends StatelessWidget {
  final String? duration;
  final String? title;
  final ValueChanged<String> onChangedDuration;
  final ValueChanged<String> onChangedTitle;

  const TimerFormWidget({
    Key? key,
    this.duration = '',
    this.title = '',
    required this.onChangedDuration,
    required this.onChangedTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildTitle(),
              const SizedBox(height: 8),
              buildDuration(),
              const SizedBox(height: 16),
            ],
          ),
        ),
      );

  Widget buildTitle() => TextFormField(
        maxLines: 1,
        initialValue: title,
        style: const TextStyle(
          color: Color.fromARGB(179, 182, 163, 163),
        ),
        decoration: const InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.greenAccent), //<-- SEE HERE
          ),
          border: InputBorder.none,
          hintText: 'Nome timer',
          hintStyle: TextStyle(color: Color.fromARGB(179, 182, 163, 163)),
        ),
        validator: (title) => title != null && title.isEmpty
            ? 'Il timer deve avere un nome'
            : null,
        onChanged: onChangedTitle,
      );

  Widget buildDuration() => TextFormField(
        maxLines: 1,
        initialValue: title,
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly
        ], // Only numbers can be entered

        style: const TextStyle(
          color: Color.fromARGB(179, 182, 163, 163),
        ),
        decoration: const InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.greenAccent), //<-- SEE HERE
          ),
          border: InputBorder.none,
          hintText: 'Durata(hhmmss)',
          hintStyle: TextStyle(color: Color.fromARGB(179, 182, 163, 163)),
        ),
        validator: (duration) => duration.toString().replaceAll("0", "") ==
                    "" ||
                duration.toString().length != 6 ||
                (int.parse(duration.toString()[1]) > 3 &&
                    int.parse(duration.toString()[0]) == 2) ||
                (int.parse(duration.toString()[1]) > 9 &&
                    int.parse(duration.toString()[0]) == 1) ||
                int.parse(duration.toString()[2]) > 5 ||
                int.parse(duration.toString()[4]) > 5 ||
                int.parse(duration.toString()[3]) > 9 ||
                int.parse(duration.toString()[5]) > 9
            ? 'La durata compresa tra 000001 e 235959, nel formato richiesto'
            : null,
        onChanged: onChangedDuration,
      );
}
