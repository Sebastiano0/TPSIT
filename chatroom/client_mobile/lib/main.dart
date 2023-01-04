import 'package:flutter/material.dart';
import 'package:client_mobile/widget/login_screen.dart';

void main() {
  runApp(
    MaterialApp(
      home: const LoginScreen(),
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    ),
  );
}
