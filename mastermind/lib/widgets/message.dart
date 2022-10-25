import 'package:flutter/material.dart';
import 'package:mastermind/widgets/gameColors.dart';

class Message {
  completeCombination(context) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              side: BorderSide(color: Colors.yellow),
              borderRadius: BorderRadius.all(Radius.circular(32.0))),
          contentPadding: const EdgeInsets.only(top: 10.0),
          backgroundColor: Colors.black,
          title: const Text(
            ('Ti manca qualcosa!'),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.yellow,
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Expanded(
                  child: Text(
                    ('Inserisci tutti e 4 i colori per la combinazione'),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                    ),
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

  endGame(context, List<Color> guessedSequence, Color messageColor, message) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              side: BorderSide(color: messageColor),
              borderRadius: const BorderRadius.all(Radius.circular(32.0))),
          contentPadding: const EdgeInsets.only(top: 10.0),
          backgroundColor: Colors.black,
          title: Text(
            (message),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: messageColor,
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(Icons.circle, color: guessedSequence[0], size: 30),
                    Icon(Icons.circle, color: guessedSequence[1], size: 30),
                    Icon(Icons.circle, color: guessedSequence[2], size: 30),
                    Icon(Icons.circle, color: guessedSequence[3], size: 30),
                  ],
                )
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Chiudi'),
              onPressed: () {
                GameColors().reset();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
