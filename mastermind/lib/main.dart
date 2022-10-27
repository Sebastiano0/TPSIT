import 'package:flutter/material.dart';
import 'widgets/gameColors.dart';
import 'widgets/graphic.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const String _title = 'Mastermind';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: _title,
      home: MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({super.key});

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  GameColors colors = GameColors();

  @override
  Widget build(BuildContext context) {
    colors.createColorSequence();
    return Graphic(colors);
  }
}
