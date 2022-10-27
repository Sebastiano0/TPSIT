import 'package:flutter/material.dart';

class Logic {
  List<Color> borderContainerColor = [];

  List<bool> enterVisibility = [];

  List<bool> resultVisibility = [];

  List<bool?> checkboxValues = [];

  List<List<Color>> guessedSequence = [];

  List<List<Color>> colorSequence = [];

  createArrays(rows) {
    checkboxValues.clear();
    resultVisibility.clear();
    enterVisibility.clear();
    borderContainerColor.clear();
    guessedSequence.clear();
    colorSequence.clear();
    for (int i = 0; i < rows; i++) {
      guessedSequence.add([
        Colors.transparent,
        Colors.transparent,
        Colors.transparent,
        Colors.transparent
      ]);
      colorSequence.add([
        Colors.transparent,
        Colors.transparent,
        Colors.transparent,
        Colors.transparent
      ]);
      for (int y = 0; y < 4; y++) {
        checkboxValues.add(false);
      }
      if (i != 0) {
        resultVisibility.add(false);
        borderContainerColor.add(Colors.transparent);
        enterVisibility.add(false);
      } else {
        resultVisibility.add(false);
        borderContainerColor.add(Colors.green);
        enterVisibility.add(true);
      }
    }
  }

  resetVariables() {
    for (int i = 0; i < 40; i++) {
      checkboxValues[i] = false;
      if (i < 10) {
        if (i == 0) {
          enterVisibility[i] = true;
          borderContainerColor[i] = Colors.green;
        } else {
          enterVisibility[i] = false;
          borderContainerColor[i] = Colors.transparent;
        }
        resultVisibility[i] = false;
      }
    }
  }
}
