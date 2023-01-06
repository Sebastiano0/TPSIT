import 'dart:async';
import 'dart:io';
import 'package:client_mobile/logic/app_data.dart';

class Connection {
  late Socket socket;
  StreamController<String> messageController = StreamController<String>();

  void createConnection() {
    Socket.connect("192.168.56.1", 3000).then((Socket sock) {
      socket = sock;
      socket.listen(dataHandler,
          onError: errorHandler, onDone: doneHandler, cancelOnError: false);
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
    // socket.write(AppData.username + ": " + message + '\n');
    socket.write("${AppData.username}: $message\n");
  }

  void dataHandler(data) {
    String message = String.fromCharCodes(data).trim();
    messageController.add(message);
  }

  void errorHandler(error, StackTrace trace) {
    print(error);
  }

  void doneHandler() {
    socket.destroy();
    exit(0);
  }

  String getTimestamp(String input) {
    List<String> words = input.split(' ');
    return '${words[0]} ${words[1]}';
  }

  String getSender(String input) {
    List<String> words = input.split(' ');
    return words[4];
  }

  String getMessage(String input) {
    String words = input.substring(input.indexOf(">") + 1);
    return words;
  }
}
