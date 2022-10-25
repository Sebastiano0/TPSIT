// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:mastermind/widgets/board.dart';
import 'gameColors.dart';

// ignore: must_be_immutable
class AppBarButton extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  var color;

  AppBarButton(this.color, {super.key});

  @override
  // ignore: library_private_types_in_public_api, no_logic_in_create_state
  _AppBarButtonState createState() => _AppBarButtonState(color);
}

class _AppBarButtonState extends State<AppBarButton> {
  GameColors color;
  _AppBarButtonState(this.color);

  @override
  void initState() {
    super.initState();
    //_appState = ScopedModel.of<AppState>(context);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.5,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(
              Icons.info_outline_rounded,
              color: Colors.white,
              size: 25,
            ),
            onPressed: () {
              print('info');
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.replay,
              color: Colors.white,
              size: 25,
            ),
            onPressed: () {
              reset();
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.settings,
              color: Colors.white,
              size: 25,
            ),
            onPressed: () {
              print('settings');
            },
          ),
        ],
      ),
    );
  }

  reset() {
    //colorSequence-guessedSequence
    color.createColorSequence();
    color.chance = 0;
    for (int y = 0; y < color.colorSequence.length; y++) {
      for (int x = 0; x < color.colorSequence[y].length; x++) {
        color.colorSequence[y][x] = Colors.transparent;
        color.guessedSequence[y][x] = Colors.transparent;
      }
    }
    for (int i = 0; i < 40; i++) {
      color.logic.checkboxValues[i] = false;
      if (i < 10) {
        if (i == 0) {
          color.logic.enterVisibility[i] = true;
          color.logic.borderContainerColor[i] = Colors.green;
        } else {
          color.logic.enterVisibility[i] = false;
          color.logic.borderContainerColor[i] = Colors.transparent;
        }
        color.logic.resultVisibility[i] = false;
      }
    }
  }
}
