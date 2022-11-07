import 'package:flutter/material.dart';
import 'widget/timer.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Countdown app',
      theme:
          ThemeData(primarySwatch: Colors.green, backgroundColor: Colors.black),
      home: Timer(),
    );
  }
}
