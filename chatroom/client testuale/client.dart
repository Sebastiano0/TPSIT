import 'dart:io';

late Socket socket;

void main() {
  stdout.write("Inserisci un nome per la connessione\n");
  String? name = stdin.readLineSync();
  print("Hello, $name!");

  Socket.connect("localhost", 3000).then((Socket sock) {
    socket = sock;
    socket.listen(dataHandler,
        onError: errorHandler, onDone: doneHandler, cancelOnError: false);
  }, onError: (e) {
    print("Unable to connect: $e");
    exit(1);
  });

  // connect standard in to the socket
  stdin.listen((data) {
    String message = String.fromCharCodes(data).trim();
    if (message.length > 126) {
      print("Il messaggio è troppo lungo per essere inviato al server.");
    } else if (message.replaceAll(' ', '') == "") {
      print("Il messaggio deve contenere del testo!");
    } else {
      socket.write(name! + ": " + message + '\n');
    }
  });
}

void dataHandler(data) {
  print(String.fromCharCodes(data).trim());
}

void errorHandler(error, StackTrace trace) {
  print(error);
}

void doneHandler() {
  socket.destroy();
  exit(0);
}
