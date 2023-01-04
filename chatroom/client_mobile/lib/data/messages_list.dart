class MessagesList {
  static final List<Message> messages = [];
}

class Message {
  final String timestamp;
  final String sender;
  final String text;

  Message(this.timestamp, this.sender, this.text);
}
