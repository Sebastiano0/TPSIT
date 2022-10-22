import 'package:flutter/material.dart';

class GameColors {
  GameColors();
  int _selectedIndex = 0;
  final List<Color> colors = <Color>[
    Colors.red,
    Colors.green,
    Colors.purple,
    Colors.white,
    Colors.black,
    Colors.blue
  ];

  Color getColor([int? i]) {
    if (i != null) {
      return colors[i];
    }
    return colors[_selectedIndex];
  }

  setColor(int index) {
    _selectedIndex = index;
  }
}
