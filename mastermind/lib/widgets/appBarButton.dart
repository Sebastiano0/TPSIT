// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:mastermind/main.dart';
import 'package:mastermind/widgets/board.dart';
import 'package:mastermind/widgets/graphic.dart';
import 'package:mastermind/widgets/message.dart';
import 'gameColors.dart';

// ignore: must_be_immutable
class AppBarButton extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  var color;
  var reset;
  AppBarButton(this.color, this.reset, {super.key});

  @override
  // ignore: library_private_types_in_public_api, no_logic_in_create_state
  _AppBarButtonState createState() => _AppBarButtonState(color, reset);
}

class _AppBarButtonState extends State<AppBarButton> {
  GameColors color;
  var reset;
  _AppBarButtonState(this.color, this.reset);
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
              Message().info(context);
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.replay,
              color: Colors.white,
              size: 25,
            ),
            onPressed: () {
              widget.reset();
              color.reset();
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.settings,
              color: Colors.white,
              size: 25,
            ),
            onPressed: () {
              Message().settings(context, color, reset);
            },
          ),
        ],
      ),
    );
  }
}
