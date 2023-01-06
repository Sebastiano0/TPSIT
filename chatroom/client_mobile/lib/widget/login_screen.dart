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
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      // Simula il login asincrono
      await Future.delayed(const Duration(seconds: 1));
      // Salva l'username nei dati dell'applicazione
      // (in questo esempio, utilizzo una semplice variabile statica)
      AppData.username = _usernameController.text;
      connection.createConnection();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => ChatScreen(connection),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Benvenuto in Chat App',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo[800],
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        labelText: 'Username',
                        hintText: 'Inserisci il tuo username',
                        hintStyle: TextStyle(color: Colors.indigo[800]),
                        labelStyle: TextStyle(color: Colors.indigo[800]),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.indigo),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Per favore, inserisci il tuo username';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _login,
                      child: const Text("Accedi"),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo[800]),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
