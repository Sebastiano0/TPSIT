// ignore_for_file: file_names
import 'package:flutter/material.dart';
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
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.5,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(
              Icons.info_outline_rounded,
              color: color.secondaryColor,
              size: 25,
            ),
            onPressed: () {
              Message().info(context, color);
            },
          ),
          IconButton(
            icon: Icon(
              Icons.replay,
              color: color.secondaryColor,
              size: 25,
            ),
            onPressed: () {
              widget.reset();
              color.reset();
            },
          ),
          IconButton(
            icon: Icon(
              Icons.settings,
              color: color.secondaryColor,
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
