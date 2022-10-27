import 'package:flutter/material.dart';
import 'gameColors.dart';

class Settings extends StatefulWidget {
  var color;
  var reset;
  Settings(this.color, this.reset, {super.key});

  @override
  _SettingsState createState() => _SettingsState(color);
}

class _SettingsState extends State<Settings> {
  GameColors color;
  _SettingsState(this.color);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          side: BorderSide(color: color.secondaryColor),
          borderRadius: const BorderRadius.all(Radius.circular(25.0))),
      contentPadding: const EdgeInsets.only(top: 10.0),
      backgroundColor: color.mainColor,
      title: Text(
        ("Impostazioni"),
        textAlign: TextAlign.center,
        style: TextStyle(
          color: color.secondaryColor,
        ),
      ),
      content: SingleChildScrollView(
        child: ListBody(children: <Widget>[
          Column(children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  ('Permetti colori duplicati'),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: color.secondaryColor,
                  ),
                ),
                Switch(
                  inactiveTrackColor: color.secondaryColor,
                  value: color.multipleColorAllow,
                  onChanged: (newValue) async {
                    setState(() => color.multipleColorAllow = newValue);
                    color.reset();
                    widget.reset();
                  },
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  ('Light mode'),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: color.secondaryColor,
                  ),
                ),
                Switch(
                  inactiveTrackColor: color.secondaryColor,
                  value: color.lightModeOn,
                  onChanged: (newValues) async {
                    setState(() => color.lightModeOn = newValues);
                    if (color.mainColor == Colors.black) {
                      color.lightMode();
                    } else {
                      color.darktMode();
                    }
                    widget.reset();
                  },
                ),
              ],
            ),
          ]),
        ]),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text(
            'Chiudi',
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
