import 'package:flutter/material.dart';
import 'dart:math';
import 'package:collection/collection.dart';
import 'package:mastermind/widgets/message.dart';

class GameColors {
  GameColors();

  int _selectedIndex = 0;
  final List<Color> colors = <Color>[
    Colors.red,
    Colors.yellow.shade800,
    Colors.green,
    Colors.blue,
    Colors.purple,
    Colors.white,
  ];

  List<Color> colorSequenceToGuess = [];

  createColorSequence() {
    Color temp;
    for (int i = 0; i < 4;) {
      temp = colors[Random().nextInt(6)];
      if (!colorSequenceToGuess.contains(temp)) {
        colorSequenceToGuess.add(temp);
        i++;
      }
    }
    print(colorSequenceToGuess.toString());
  }

  List<Color> colorSequence = [
    Colors.transparent,
    Colors.transparent,
    Colors.transparent,
    Colors.transparent
  ];

  List<Color> guessedSequence = [
    Colors.transparent,
    Colors.transparent,
    Colors.transparent,
    Colors.transparent
  ];

  late int correctPlace;
  late int wrongPlace;

  checkSequence(context) {
    if (colorSequence.contains(Colors.transparent)) {
      Message().completeCombination(context);
      return -1;
    }
    guessedSequence.clear();
    correctPlace = 0;
    wrongPlace = 0;
    List<Color> tempListColor = [];
    for (int i = 0; i < 4; i++) {
      tempListColor.add(colorSequence[i]);
      if (colorSequenceToGuess.contains(tempListColor[i])) {
        Color actualColor = tempListColor[i];
        if (colorSequenceToGuess[i] == actualColor) {
          correctPlace++;
          guessedSequence.add(Colors.red);
        } else {
          tempListColor[i] = Colors.transparent;
          if (!colorSequence.contains(actualColor)) {
            wrongPlace++;
          }
        }
      }
    }
    while (guessedSequence.length < 4) {
      for (int i = 0; i < wrongPlace; i++) {
        guessedSequence.add(Colors.white);
      }
      guessedSequence.add(Colors.blueGrey);
    }
    if (correctPlace == 4) {
      Message().win(context, colorSequenceToGuess);
      print(true);
    }
    // Function eq = const ListEquality().equals;
    // print(eq(colorSequenceToGuess, colorSequence));
    // return eq(colorSequenceToGuess, colorSequence);
    return;
  }

  getColorSequence([int? i]) {
    if (i != null) {
      return colorSequence[i];
    }
  }

  setColorSequence(int i) {
    colorSequence[i] = colors[_selectedIndex];
  }

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
