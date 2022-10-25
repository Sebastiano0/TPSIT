import 'package:flutter/material.dart';
import 'dart:math';
import 'package:mastermind/widgets/message.dart';
import 'logic.dart';

class GameColors {
  GameColors();

  Logic logic = Logic();

  int _selectedIndex = 0;
  final List<Color> colors = <Color>[
    Colors.red,
    Colors.yellow.shade800,
    Colors.green,
    Colors.blue,
    Colors.purple,
    Colors.white,
  ];

  int chance = 0;

  List<Color> colorSequenceToGuess = [];

  createColorSequence() {
    Color temp;
    colorSequenceToGuess.clear();
    for (int i = 0; i < 4;) {
      temp = colors[Random().nextInt(6)];
      if (!colorSequenceToGuess.contains(temp)) {
        colorSequenceToGuess.add(temp);
        i++;
      }
    }
    print(colorSequenceToGuess.toString());
  }

  List<List<Color>> colorSequence = [
    [
      Colors.transparent,
      Colors.transparent,
      Colors.transparent,
      Colors.transparent
    ],
    [
      Colors.transparent,
      Colors.transparent,
      Colors.transparent,
      Colors.transparent
    ],
    [
      Colors.transparent,
      Colors.transparent,
      Colors.transparent,
      Colors.transparent
    ],
    [
      Colors.transparent,
      Colors.transparent,
      Colors.transparent,
      Colors.transparent
    ],
    [
      Colors.transparent,
      Colors.transparent,
      Colors.transparent,
      Colors.transparent
    ],
    [
      Colors.transparent,
      Colors.transparent,
      Colors.transparent,
      Colors.transparent
    ],
    [
      Colors.transparent,
      Colors.transparent,
      Colors.transparent,
      Colors.transparent
    ],
    [
      Colors.transparent,
      Colors.transparent,
      Colors.transparent,
      Colors.transparent
    ],
    [
      Colors.transparent,
      Colors.transparent,
      Colors.transparent,
      Colors.transparent
    ],
    [
      Colors.transparent,
      Colors.transparent,
      Colors.transparent,
      Colors.transparent
    ]
  ];

  List<List<Color>> guessedSequence = [
    [
      Colors.transparent,
      Colors.transparent,
      Colors.transparent,
      Colors.transparent
    ],
    [
      Colors.transparent,
      Colors.transparent,
      Colors.transparent,
      Colors.transparent
    ],
    [
      Colors.transparent,
      Colors.transparent,
      Colors.transparent,
      Colors.transparent
    ],
    [
      Colors.transparent,
      Colors.transparent,
      Colors.transparent,
      Colors.transparent
    ],
    [
      Colors.transparent,
      Colors.transparent,
      Colors.transparent,
      Colors.transparent
    ],
    [
      Colors.transparent,
      Colors.transparent,
      Colors.transparent,
      Colors.transparent
    ],
    [
      Colors.transparent,
      Colors.transparent,
      Colors.transparent,
      Colors.transparent
    ],
    [
      Colors.transparent,
      Colors.transparent,
      Colors.transparent,
      Colors.transparent
    ],
    [
      Colors.transparent,
      Colors.transparent,
      Colors.transparent,
      Colors.transparent
    ],
    [
      Colors.transparent,
      Colors.transparent,
      Colors.transparent,
      Colors.transparent
    ]
  ];

  late int correctPlace;
  late int wrongPlace;

  checkSequence(context) {
    if (colorSequence[chance].contains(Colors.transparent)) {
      Message().completeCombination(context);
      return -1;
    }
    guessedSequence[chance].clear();
    correctPlace = 0;
    wrongPlace = 0;
    List<Color> tempListColor = List.from(colorSequence[chance]);
    for (int i = 0; i < 4; i++) {
      // tempListColor.add(colorSequence[i]);
      if (colorSequenceToGuess.contains(tempListColor[i])) {
        Color actualColor = tempListColor[i];
        if (colorSequenceToGuess[i] == actualColor) {
          correctPlace++;
          guessedSequence[chance].add(Colors.green);
        } else {
          tempListColor[i] = Colors.transparent;
          if (!tempListColor.contains(actualColor)) {
            wrongPlace++;
          }
        }
      }
    }
    for (int i = 0; i < wrongPlace; i++) {
      guessedSequence[chance].add(Colors.white);
    }
    while (guessedSequence[chance].length < 4) {
      guessedSequence[chance].add(Colors.blueGrey);
    }
    if (correctPlace == 4) {
      Message()
          .endGame(context, colorSequenceToGuess, Colors.green, "Hai vinto");
      return;
    }
    chance++;
    if (chance == 10) {
      Message().endGame(context, colorSequenceToGuess, Colors.red, "Hai perso");
      return;
    }
    return;
  }

  getColorSequence(int y, int x) {
    return colorSequence[y][x];
  }

  setColorSequence(int y, int x) {
    colorSequence[y][x] = colors[_selectedIndex];
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

  reset() {
    //colorSequence-guessedSequence
    createColorSequence();
    chance = 0;
    for (int y = 0; y < colorSequence.length; y++) {
      for (int x = 0; x < colorSequence[y].length; x++) {
        colorSequence[y][x] = Colors.transparent;
        guessedSequence[y][x] = Colors.transparent;
      }
    }
    logic.resetVariables();
  }
}
