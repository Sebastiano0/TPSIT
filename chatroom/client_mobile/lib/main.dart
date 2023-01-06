import 'package:flutter/material.dart';
import 'package:client_mobile/widget/login_screen.dart';

void main() {
  runApp(
    MaterialApp(
      home: MyHomePage(),
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    ),
  );
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/background_login.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: const LoginScreen(),
    );
  }
}
