import 'package:client_mobile/logic/connection.dart';
import 'package:flutter/material.dart';
import 'package:client_mobile/widget/chat_message.dart';
import 'package:client_mobile/logic/app_data.dart';

class ChatScreen extends StatefulWidget {
  final Connection connection;

  const ChatScreen(this.connection, {super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState(connection);
}

class _ChatScreenState extends State<ChatScreen> {
  final Connection connection;
  final _textController = TextEditingController();
  final _scrollController = ScrollController();
  final List<String> _messages = [];

  _ChatScreenState(this.connection);

  void _sendMessage() {
    // Aggiungi il nuovo messaggio alla lista
    setState(() {
      _messages.add(_textController.text);
    });
    // Invia il messaggio al server tramite la connessione
    connection.sendMessage(_textController.text);
    // Pulisci il campo di testo
    _textController.clear();
    // Fai scorrere la lista fino all'ultimo messaggio
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return ChatMessage(
                    sender: AppData.username, text: _messages[index]);
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 8.0),
            child: Row(
              children: [
                Flexible(
                  child: TextField(
                    controller: _textController,
                    decoration: const InputDecoration.collapsed(
                      hintText: "Invia un messaggio",
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    _sendMessage();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
