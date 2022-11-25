# Timer

Questa cartella di progetto contiene il sorgente di un timer, conto alla rovescia, realizzato con al gestione degli stream nel seguente modo:
- E`richiesta la gestione della *subscription* degli *stream*.
- Lo studente realizzerà un opprotuno `StreamController` che, come un oscillatore, genererà i *tick* (eventi di trigger).
- Lo *stream* di *tick* servirà per gestire, possibilmente trasformandolo in un altro *stream* di numeri, l'avanzamento del conto alla rovescia.
- Pausa, stop e scelta della partenza - minuti e secondi - sono obbligatori.

## Aggiunte personali

Oltre alle funzionalità base come della consegna è stata aggiunta la possibilità di salvare dei timer che si usano di frequente.
Un timer di lunghezza zero non verrà eseguito.

## Dettagli implementativi
Risultano significative le seguenti scelte implementative

### Stream
```dart
    controller = StreamController<int>(
      onPause: () => hasBeenPaused = true,
      onResume: () => print('Resumed'),
      onCancel: () => {hasBeenPaused = false, progress = 1.0},
      onListen: () => print('Listens'),
    );

    sub = controller.stream.listen((int data) async {
      setState(() {
          ...../codice per cambio del tempo/.....
      });
    }, onError: (error) {}, onDone: () {});

    if (!controller.isClosed) {
      final stream = Stream.periodic(const Duration(milliseconds: 100), (x) {
        return x;
      }).take(count * 10);

      await controller.addStream(stream);//aggiungo lo stream al controller
    }
    ...../altre istruzioni /.....
  }

  pause() {
    sub.pause();
    paused = true;
  }

stop() {
    sub.cancel();
    /.....altre istruzioni...../
  }
```
Lo stream controller viene ascoltato da una ``StreamSubscription`` che ogni 100 millisecondi genera un tic grazie ad uno ``Stream.Periodic``.

La scelta di generare un tic ogni 100 millisecondi è per rendere più fluido lo scorrimento della ``CircularProgressIndicator`` nonostante nel conto alla rovescia non tengo conto dei millisecondi.

Il metodo ``stop`` ,quando chiamato (con la pressione del bottone corrispondente), resetta tutte le variabili e cancella la ``StreamSubscription``

### NumberPicker
Viene usato il [numberPicker](https://pub.dev/documentation/numberpicker/latest/numberpicker/NumberPicker-class.html) per una scelta più fluida del tempo.

### Database
Lo schema del database è:
```dart
  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';

    await db.execute('''
        CREATE TABLE $tableTimers (
        ${TimerFields.id} $idType,
        ${TimerFields.title} $textType,
        ${TimerFields.duration} $textType
        )''');
  }
```
L'unica tabella presente  nel database è ``tableTimers`` che ha 3 attributi: *Id, Titolo, Durata*.

*Id* è di tipo intero mentre gli latri due sono delle stringhe.

Ho utilizzato il *model* che è una classe che rappresenta la tabella ``Timer``.

Attraverso la libreria e alla classe ho potuto appplicare il pattern dell'orm.
## Riferimenti

[Salvataggio timer (database)](https://www.youtube.com/watch?v=UpKrhZ0Hppk)

[Notifiche](https://m.youtube.com/watch?v=g2V7y0eTTSE)
