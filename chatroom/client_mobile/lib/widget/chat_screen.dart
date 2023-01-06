import 'dart:async';

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
        Timer(const Duration(milliseconds: 500), () {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        });
      });
    });
  }

  void _sendMessage() {
    String message = _textController.text;
    if (message.replaceAll(' ', '') == "") {
      AlerMessage().emptyMessage(context);
      setState(() {});
      return;
    }
    if (message.length > 126) {
      AlerMessage().exceededMaxLength(context);
      setState(() {});
      return;
    }
    setState(() {
      MessagesList.messages.add(Message(
          DateTime.now().toString().split('.')[0], AppData.username, message));
    });
    connection.sendMessage(message);
    // Pulisci il campo di testo
    _textController.clear();
    // Fai scorrere la lista fino all'ultimo messaggio
    Timer(const Duration(milliseconds: 500), () {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text(
            "Chatroom",
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          elevation: 0.0,
          backgroundColor: Colors.indigo[800],
        ),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/background_chat.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: MessagesList.messages.length,
                  itemBuilder: (context, index) {
                    return ChatMessage(
                      sender: MessagesList.messages[index].sender,
                      text: MessagesList.messages[index].text,
                      timeStamp: MessagesList.messages[index].timestamp,
                    );
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
                        onTap: () {
                          Timer(const Duration(milliseconds: 500), () {
                            _scrollController.jumpTo(
                                _scrollController.position.maxScrollExtent);
                          });
                        },
                        decoration: InputDecoration(
                          hintText: "Invia un messaggio",
                          hintStyle: TextStyle(
                            fontSize: 16.0,
                            color: Colors.grey[400],
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey[200],
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.indigo[800],
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.send,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          _sendMessage();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
