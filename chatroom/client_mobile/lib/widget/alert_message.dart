import 'package:flutter/material.dart';

class AlerMessage {
  exceededMaxLength(context) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              side: BorderSide(color: Colors.yellow),
              borderRadius: BorderRadius.all(Radius.circular(25.0))),
          contentPadding: const EdgeInsets.only(top: 10.0),
          backgroundColor: Colors.blue,
          title: const Text(
            ('Troppo lungo!'),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.yellow,
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text(
                  ('Il messaggio supera la lunghezza massima di 126 caratteri, accrocialo per inviarlo!'),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
