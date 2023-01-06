import 'package:flutter/material.dart';
import 'package:client_mobile/logic/app_data.dart';

class ChatMessage extends StatelessWidget {
  const ChatMessage(
      {super.key,
      required this.sender,
      required this.text,
      required this.timeStamp});

  final String sender;
  final String text;
  final String timeStamp;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 2),
      child: Row(
        mainAxisAlignment: sender == AppData.username
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          Flexible(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 200),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: sender == AppData.username
                    ? Colors.purple[700]
                    : Colors.deepPurple[300],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(sender,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      )),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: sender == AppData.username
                          ? Colors.purple[700]
                          : Colors.deepPurple[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(text),
                  ),
                  Text(
                    timeStamp,
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
