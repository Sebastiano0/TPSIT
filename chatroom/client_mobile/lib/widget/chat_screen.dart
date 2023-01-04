import 'package:client_mobile/data/messages_list.dart';
import 'package:client_mobile/logic/connection.dart';
import 'package:client_mobile/widget/alert_message.dart';
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

  _ChatScreenState(this.connection);

  @override
  void initState() {
    super.initState();
    widget.connection.messageController.stream.listen((message) {
      setState(() {
        MessagesList.messages.add(Message(connection.getTimestamp(message),
            connection.getSender(message), connection.getMessage(message)));
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    });
  }

  void _sendMessage() {
    String message = _textController.text;
    if (message.length <= 126) {
      // Aggiungi il nuovo messaggio alla lista
      setState(() {
        MessagesList.messages.add(Message(
            DateTime.now().toString().split('.')[0],
            AppData.username,
            message));
      });
      // Invia il messaggio al server tramite la connessione
      connection.sendMessage(message);
      // Pulisci il campo di testo
      _textController.clear();
      // Fai scorrere la lista fino all'ultimo messaggio
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    } else {
      AlerMessage().exceededMaxLength(context);
      setState(() {});
    }
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
              itemCount: MessagesList.messages.length,
              itemBuilder: (context, index) {
                return ChatMessage(
                    sender: MessagesList.messages[index].sender,
                    text: MessagesList.messages[index].text,
                    timeStamp: MessagesList.messages[index].timestamp);
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
