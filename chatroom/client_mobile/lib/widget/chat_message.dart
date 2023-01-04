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
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        title: Row(
          mainAxisAlignment: sender == AppData.username
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: sender == AppData.username
                    ? Colors.green[100]
                    : Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Container(
                constraints: const BoxConstraints(minWidth: 50),
                child: Column(
                  children: [
                    Text(sender,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 158, 158, 158))),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: sender == AppData.username
                            ? Colors.green[100]
                            : Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(text),
                    ),
                    Text(timeStamp,
                        style: const TextStyle(
                            color: Color.fromARGB(255, 158, 158, 158))),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
