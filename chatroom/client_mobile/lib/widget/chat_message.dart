import 'package:flutter/material.dart';
import 'package:client_mobile/logic/app_data.dart';

class ChatMessage extends StatelessWidget {
  ChatMessage({required this.sender, required this.text});

  final String sender;
  final String text;
  // Crea un'istanza della classe Connection



  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        leading: sender == AppData.username
            ? SizedBox()
            : CircleAvatar(
                backgroundColor: Colors.grey,
                child: Text(sender[0], style: TextStyle(color: Colors.white)),
              ),
        title: Row(
          mainAxisAlignment: sender == AppData.username
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: sender == AppData.username
                      ? Colors.green[100]
                      : Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(text),
              ),
            ),
            SizedBox(width: 10),
            sender == AppData.username
                ? SizedBox()
                : CircleAvatar(
                    backgroundColor: Colors.grey,
                    child:
                        Text(sender[0], style: TextStyle(color: Colors.white)),
                  ),
          ],
        ),
      ),
    );
  }
}
