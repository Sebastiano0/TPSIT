# Server chatroom

L'applicazione permette a più utenti di connettersi al server tramite una socket e di inviare e ricevere messaggi in tempo reale.


## Come usare

Per utilizzare l'applicazione, segui questi passaggi:
- Avviare il server eseguendo il file `server.dart` utilizzando il comando **dart server.dart**.
- Utilizzare un [client di chat](https://github.com/Sebastiano0/TPSIT/tree/main/chatroom/client%20testuale) per connettersi al server specificando l'indirizzo IP del server e la porta su cui il server è in ascolto (in questo caso, 127.0.0.1 e 3000).
- Inviare i messaggi al server inserendo un nome, seguito da una doppia barra e il messaggio desiderato, ad esempio: **Nome:Ciao a tutti**.
- I messaggi inviati verranno visualizzati da tutti i client connessi, insieme al nome del mittente e all'ora in cui sono stati inviati.
- Per disconnettersi, chiudere il client o digitare il comando **exit**.


## Funzionamento

Il server ascolta le richieste di connessione su una determinata porta e quando viene stabilita una connessione, crea un nuovo oggetto `ChatClient `per gestire il client connesso. Quando il client invia un messaggio, questo viene distribuito a tutti gli altri client connessi al server.


## Codice significativo

Il codice significativo dell'applicazione include la classe `ChatClient` e la funzione `distributeMessage`.

La classe `ChatClient` rappresenta un client connesso al server e gestisce le operazioni di invio e ricezione dei messaggi. Contiene i metodi **messageHandler**, **errorHandler** e **finishedHandler** per gestire rispettivamente i messaggi ricevuti dal client, gli errori e la disconnessione del client.

La funzione `distributeMessage` viene chiamata quando un client invia un messaggio al server. Prende in input il client mittente e il messaggio e lo invia a tutti gli altri client connessi, tranne il mittente.


## Scelte implementative

Per l'implementazione del server, è stata scelta la classe `ServerSocket` di Dart, che fornisce un modo semplice per creare un server di socket che ascolta le connessioni su una determinata porta.

Per gestire i client connessi, è stata creata la classe `ChatClient`, che rappresenta un client connesso e gestisce le operazioni di invio e ricezione dei messaggi.

È stata inoltre implementata la funzione `distributeMessage` per distribuire i messaggi a tutti gli altri client connessi, tranne il mittente. In questo modo, ogni client può ricevere i messaggi inviati da tutti gli altri client connessi.

## Riferimenti

[Codice](https://gitlab.com/divino.marchese/zuccante_src/-/blob/master/dart/netowrking_io/es005_server_socket.dart )
