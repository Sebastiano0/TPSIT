import 'package:flutter/material.dart';
import 'dart:math';
import 'package:mastermind/widgets/message.dart';
import 'logic.dart';

class GameColors {
  GameColors();

  Logic logic = Logic();

  Color mainColor = Colors.black;
  Color secondaryColor = Colors.white;
  Color lastBackgroundColorBottomNavigation = Colors.grey.shade300;

  bool lightModeOn = false;
  bool multipleColorAllow = false;

  int rows = 10;

  int _selectedIndex = 0;
  final List<Color> colors = <Color>[
    Colors.red,
    Colors.yellow.shade800,
    Colors.green,
    Colors.blue,
    Colors.purple,
    Colors.white,
  ];

  lightMode() {
    mainColor = Colors.white;
    secondaryColor = Colors.black;
    colors[5] = Colors.black;
    lightModeOn = true;
    lastBackgroundColorBottomNavigation = Colors.grey.shade900;
    changeColorAlreadySet(Colors.white, Colors.black);
  }

  changeColorAlreadySet(Color toCanghe, Color changed) {
    for (int y = 0; y < logic.colorSequence.length; y++) {
      for (int x = 0; x < logic.colorSequence[y].length; x++) {
        if (logic.colorSequence[y][x] == toCanghe) {
          logic.colorSequence[y][x] = changed;
        }
      }
    }
  }

  darktMode() {
    mainColor = Colors.black;
    secondaryColor = Colors.white;
    colors[5] = Colors.white;
    lightModeOn = false;
    lastBackgroundColorBottomNavigation = Colors.grey.shade300;
    changeColorAlreadySet(Colors.black, Colors.white);
  }

  int chance = 0;

  List<Color> colorSequenceToGuess = [];

  createColorSequence() {
    if (rows == 0) {
      rows = 10;
    }
    Color temp;
    colorSequenceToGuess.clear();
    for (int i = 0; i < 4;) {
      temp = colors[Random().nextInt(6)];
      if (!colorSequenceToGuess.contains(temp) || multipleColorAllow) {
        colorSequenceToGuess.add(temp);
        i++;
      }
    }
    print(colorSequenceToGuess.toString());
    logic.createArrays(rows);
  }

  late int correctPlace;
  late int wrongPlace;

  checkSequence(context) {
    if (logic.colorSequence[chance].contains(Colors.transparent)) {
      Message().completeCombination(context, this);
      return -1;
    }
    logic.guessedSequence[chance].clear();
    correctPlace = 0;
    wrongPlace = 0;
    List<Color> tempListColor = List.from(logic.colorSequence[chance]);
    for (int i = 0; i < 4; i++) {
      if (colorSequenceToGuess.contains(tempListColor[i])) {
        Color actualColor = tempListColor[i];

        if (colorSequenceToGuess[i] == actualColor) {
          correctPlace++;
          logic.guessedSequence[chance].add(Colors.green);
        } else {
          tempListColor[i] = Colors.transparent;
          if (!tempListColor.contains(actualColor) ||
              (multipleColorAllow &&
                  ((colorSequenceToGuess.where((e) => e == actualColor).length >
                      tempListColor.where((e) => e == actualColor).length)))) {
            wrongPlace++;
          }
        }
      }
    }
    for (int i = 0; i < wrongPlace; i++) {
      logic.guessedSequence[chance].add(Colors.yellow);
    }
    while (logic.guessedSequence[chance].length < 4) {
      logic.guessedSequence[chance].add(Colors.blueGrey);
    }
    if (correctPlace == 4) {
      Message().endGame(
          context, colorSequenceToGuess, Colors.green, "Hai vinto", this);
      return 1;
    }
    chance++;
    if (chance == rows) {
      Message().endGame(
          context, colorSequenceToGuess, Colors.red, "Hai perso", this);
      return;
    }
    return;
  }

  getColorSequence(int y, int x) {
    return logic.colorSequence[y][x];
  }

  setColorSequence(int y, int x) {
    logic.colorSequence[y][x] = colors[_selectedIndex];
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
    for (int y = 0; y < logic.colorSequence.length; y++) {
      for (int x = 0; x < logic.colorSequence[y].length; x++) {
        logic.colorSequence[y][x] = Colors.transparent;
        logic.guessedSequence[y][x] = Colors.transparent;
      }
    }
    logic.resetVariables();
  }
}
