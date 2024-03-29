// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:mastermind/widgets/board.dart';
import 'gameColors.dart';
import 'package:mastermind/widgets/appBarButton.dart';
import 'bottomNavigation.dart';

// ignore: must_be_immutable
class Graphic extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  var color;

  Graphic(this.color, {super.key});

  @override
  // ignore: library_private_types_in_public_api, no_logic_in_create_state
  _GraphicState createState() => _GraphicState(color);
}

class _GraphicState extends State<Graphic> {
  GameColors color;
  _GraphicState(this.color);

  void reset() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: color.mainColor,
      appBar: AppBar(
          title: Text(
            'Mastermind',
            style: TextStyle(
              color: color.secondaryColor,
            ),
          ),
          backgroundColor: color.mainColor,
          actions: [AppBarButton(color, reset)]),
      body: SingleChildScrollView(
          controller: ScrollController(initialScrollOffset: (606.7)),
          child: Board(color, key: UniqueKey())),
      bottomNavigationBar: BottomNavigation(color),
    );
  }
}
