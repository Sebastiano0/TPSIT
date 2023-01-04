import 'dart:io';
import 'package:client_mobile/logic/app_data.dart';

class Connection {
  late Socket socket;

  void createConnection() {
    Socket.connect("localhost", 3000).then((Socket sock) {
      socket = sock;
      socket.listen(dataHandler,
          onError: errorHandler, onDone: doneHandler, cancelOnError: false);
      print("Connected");
    }, onError: (e) {
      print("Unable to connect: $e");
      exit(1);
    });

    // connect standard in to the socket
    // stdin.listen((data) {
    //   String message = String.fromCharCodes(data).trim();
    //   if (message.length > 126) {
    //     print("Il messaggio è troppo lungo per essere inviato al server.");
    //   }
    //   socket.write(AppData.username+ ": " + message + '\n');
    // });
  }

  void sendMessage(message) {
    socket.write(AppData.username + ": " + message + '\n');
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
}
