import 'package:flutter/material.dart';
import 'package:mastermind/widgets/gameColors.dart';
import 'package:mastermind/widgets/settings.dart';

class Message {
  completeCombination(context, color) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              side: BorderSide(color: Colors.yellow),
              borderRadius: BorderRadius.all(Radius.circular(25.0))),
          contentPadding: const EdgeInsets.only(top: 10.0),
          backgroundColor: color.mainColor,
          title: const Text(
            ('Ti manca qualcosa!'),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.yellow,
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  ('Inserisci tutti e 4 i colori per la combinazione'),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: color.secondaryColor,
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

  endGame(context, List<Color> guessedSequence, Color messageColor, message,
      color) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              side: BorderSide(color: messageColor),
              borderRadius: const BorderRadius.all(Radius.circular(25.0))),
          contentPadding: const EdgeInsets.only(top: 10.0),
          backgroundColor: color.mainColor,
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
                color.reset();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  settings(context, color, reset) {
    return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return Settings(color, reset);
        });
  }

  info(context, GameColors color) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              side: BorderSide(color: color.secondaryColor),
              borderRadius: const BorderRadius.all(Radius.circular(32.0))),
          contentPadding: const EdgeInsets.only(top: 10.0),
          backgroundColor: color.mainColor,
          title: Text(
            ("Regole e istruzioni"),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: color.secondaryColor,
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                SizedBox(
                    height: 200,
                    child: SingleChildScrollView(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          children: [
                            Text(
                              (''' REGOLE\n
Mastermind è un gioco di crittoanalisi nel quale il giocatore deve indovinare un codice di 4 colori tra 6 a scelta. \n
Ad ogni tentativo in risposta visualizzerà degli aiuti che comunicano:\n
\u2022Il numero di cifre giuste al posto giusto, cioè le cifre del tentativo che sono effettivamente presenti nel codice al posto tentato, con pioli verdi.\n
\u2022Il numero di cifre giuste al posto sbagliato, cioè le cifre del tentativo che sono effettivamente presenti nel codice, ma non al posto tentato, con pioli gialli.\n
Non saranno comunicate quali cifre sono giuste o sbagliate ma solo quante. Se si riesce ad indovinare il codice entro 10 tentativi allora quest'ultimo vince la partita.\n\n
ISTRUZIONI:\n
Per poter giocare occorre creare una sequenza di colori, che si possono selezionare da menù in basso, inserendone uno in ogni cerchio della riga visualizzata in verde.
Una volta creata la sequenza andrà premuto invio per visualizzare gli aiuti del sistema.\n
'''),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: color.secondaryColor,
                              ),
                            ),
                            Image.asset('assets/inserimento.gif'),
                            Text(
                              ('\nÉ possibile modificare la sequenza quante volte si vuole fino alla pressione del bottone invio.\n'),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: color.secondaryColor,
                              ),
                            ),
                            Image.asset('assets/inserimentoConModifica.gif'),
                            Text(
                              ("\nPer poter iniziare una nuova partita basta selezionare l'apposito comando."),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: color.secondaryColor,
                              ),
                            ),
                            Text(
                              ('Nella casella impostazioni si possono permettere sequenze con colori uguali ripetuti e passare alla modalità light(bianca).'),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: color.secondaryColor,
                              ),
                            ),
                            Image.asset('assets/impostazioni.gif'),
                          ],
                        )))
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Chiudi',
              ),
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
