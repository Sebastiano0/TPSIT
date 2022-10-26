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
  int _selectedIndex = 0;
  GameColors color;
  _SettingsState(this.color);

  @override
  void initState() {
    super.initState();
    //_appState = ScopedModel.of<AppState>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Text(
            ('Permetti colori duplicati'),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          Switch(
            inactiveTrackColor: Colors.white,
            value: color.multipleColorAllow,
            onChanged: (newValue) async {
              setState(() => color.multipleColorAllow = newValue);
              color.reset();
              widget.reset();
            },
          ),
        ],
      ),
      Row(children: [
        Text(
          ('Combinazioni: ${color.rows.toInt().toString()}'),
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        Slider(
          activeColor: Colors.white,
          inactiveColor: const Color(0xFF9E9E9E),
          min: 1,
          max: 50,
          value: color.rows.toDouble(),
          onChanged: (newValue) {
            setState(() => color.rows = newValue.toInt());
            
            color.logic.createArrays(newValue.toInt());
            color.reset();
            widget.reset();
          },
        ),
      ])
    ]);
  }
}
