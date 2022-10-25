import 'package:flutter/material.dart';

class Logic {
  List<Color> borderContainerColor = [
    Colors.green,
    Colors.transparent,
    Colors.transparent,
    Colors.transparent,
    Colors.transparent,
    Colors.transparent,
    Colors.transparent,
    Colors.transparent,
    Colors.transparent,
    Colors.transparent
  ];

  List<bool> enterVisibility = [
    true,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];

  List<bool> resultVisibility = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];

  List<bool?> checkboxValues = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];

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
