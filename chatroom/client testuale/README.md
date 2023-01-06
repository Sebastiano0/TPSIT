# Chatroom Client 

Questa è un **client** di una chatroom che consente agli utenti di connettersi a un [server locale](https://github.com/Sebastiano0/TPSIT/tree/main/chatroom/server) per inviare e ricevere messaggi di testo.


## Come usare

Per avviare il client, eseguire il seguente comando:


```bash
dart client.dart

```
Inserire un nome per la connessione. Una volta connesso al server, è possibile inviare e ricevere messaggi digitando testo nella console.

## Funzionamento

Il client si connette al server utilizzando l'indirizzo "localhost" e la porta 3000. Una volta stabilita la connessione, viene richiesto all'utente di inserire un nome per la connessione, che viene poi utilizzato per identificare il mittente dei messaggi inviati al server.

Il client quindi inizia a ascoltare sia l'input dell'utente che i dati in arrivo dal server. Quando l'utente digita un messaggio nella console, viene inviato al server insieme al nome dell'utente. I messaggi ricevuti dal server vengono stampati nella console.

Se si verifica un errore durante la connessione o il trasferimento dei dati, viene visualizzato un messaggio di errore. Quando la connessione viene chiusa, il client viene chiuso.
## Commenti sul codice
La funzione `main()` chiede all'utente di inserire un nome per la connessione e poi si connette al server utilizzando il metodo `Socket.connect()`. Una volta stabilita la connessione, viene impostato il valore di socket e viene impostato un ascoltatore su di esso per gestire i dati in arrivo, gli errori e la chiusura della connessione.


## Riferimetni
[Codice](https://gitlab.com/divino.marchese/zuccante_src/-/blob/master/dart/netowrking_io/es006_chatroom_client.dart)