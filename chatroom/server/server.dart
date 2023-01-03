import 'dart:io';

// USE ALSO netcat 127.0.0.1 3000

// global variables

late ServerSocket server;
List<ChatClient> clients = [];

void main() {
  ServerSocket.bind(InternetAddress.anyIPv4, 3000).then((ServerSocket socket) {
    server = socket;
    server.listen((client) {
      handleConnection(client);
    });
  });
}

void handleConnection(Socket client) {
  print('Connection from '
      '${client.remoteAddress.address}:${client.remotePort}');

  clients.add(ChatClient(client));

  client.write("Welcome to dart-chat! "
      "There are ${clients.length - 1} other clients\n");
}

void removeClient(ChatClient client) {
  clients.remove(client);
}

void distributeMessage(ChatClient client, String message) {
  for (ChatClient c in clients) {
    if (c != client) {
      c.write(message + "\n");
    }
  }
}

// ChatClient class for server

class ChatClient {
  late Socket _socket;
  String get _address => _socket.remoteAddress.address;
  int get _port => _socket.remotePort;

  ChatClient(Socket s) {
    _socket = s;
    _socket.listen(messageHandler,
        onError: errorHandler, onDone: finishedHandler);
  }

  void messageHandler(data) {
    String message = new String.fromCharCodes(data).trim();
    String name = message.split(":")[0];
    String messageContent = message.substring(message.indexOf(":") + 1);
    String time = getTime();
    if (messageContent.length > 126) {
      distributeMessage(this,
          '$time Messaggio da $name non supportato, supera la lunghezza massima.');
    } else {
      distributeMessage(this, '$time Messaggio da $name -->$messageContent');
    }
  }

  void errorHandler(error) {
    print('${_address}:${_port} Error: $error');
    removeClient(this);
    _socket.close();
  }

  void finishedHandler() {
    print('${_address}:${_port} Disconnected');
    removeClient(this);
    _socket.close();
  }

  void write(String message) {
    _socket.write(message);
  }
}

String getTime() {
  DateTime now = DateTime.now();
  String formattedDate = now.toString().split('.')[0];
  return formattedDate;
}
