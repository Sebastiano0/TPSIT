import 'package:client_mobile/logic/connection.dart';
import 'package:flutter/material.dart';
import 'package:client_mobile/widget/chat_screen.dart';
import 'package:client_mobile/logic/app_data.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  Connection connection = Connection();

  Future<void> _login() async {
    // Simula il login asincrono
    await Future.delayed(const Duration(seconds: 1));
    // Salva l'username nei dati dell'applicazione
    // (in questo esempio, utilizzo una semplice variabile statica)
    AppData.username = _usernameController.text;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<void>(
        // future: _login(),
        builder: (context, snapshot) {
          if (AppData.username == "") {
            // Mostra la schermata di login finché l'utente non ha inserito il proprio username
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Inserisci il tuo username:"),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _usernameController,
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: _login,
                    child: const Text("Accedi"),
                  ),
                ],
              ),
            );
          } else {
            // Mostra la schermata principale dell'applicazione
            connection.createConnection();
            return ChatScreen(connection);
          }
        },
      ),
    );
  }
}
