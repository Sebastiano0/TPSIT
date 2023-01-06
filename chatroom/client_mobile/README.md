# Client mobile

Un'applicazione di chat mobile che include una schermata di chat che visualizza i messaggi inviati e ricevuti, una barra di inserimento testo per l'invio di nuovi messaggi e una barra superiore per il titolo dell'applicazione.

## Dettagli implementativi
Risultano significative le seguenti scelte implementative:

- La connessione alla chat viene gestita da un oggetto `Connection`, che fornisce i metodi per inviare e ricevere messaggi dal server.

- La lista dei messaggi viene mantenuta in una classe statica `MessagesList`. Ogni volta che viene ricevuto un nuovo messaggio dal server, viene aggiunto alla lista e viene aggiornato lo stato del widget `ChatScreen` per far sì che venga ricostruita la lista visualizzata.

## Codice significativo

### Invio messaggi

```dart
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
```
Questo è il codice che viene eseguito quando l'utente invia un nuovo messaggio. Prima viene verificato che il messaggio non sia vuoto o troppo lungo.
In caso contrario, il messaggio viene aggiunto alla lista dei messaggi e inviato al server tramite il metodo **connection.sendMessage**. 

Infine, il campo di testo viene pulito e la lista viene fatta scorrere fino all'ultimo messaggio.


### Flexible

Viene usato il widget **Flexible** per avere la possibilità di mostrare il testo del messaggio su più righe.

### Connessione al server

Altro codice significativo è quello della classe `Connection`.

Il modo per effetturare una connessione è medesimo a quello del **client testuale**, quindi la speigazione di tale classe si puà trovare [qui](https://github.com/Sebastiano0/TPSIT/tree/main/chatroom/client%20testuale)

## Riferimenti

[Connessione](https://gitlab.com/divino.marchese/zuccante_src/-/blob/master/dart/netowrking_io/es006_chatroom_client.dart)

[Grafica](https://fluttergems.dev/chat/)
