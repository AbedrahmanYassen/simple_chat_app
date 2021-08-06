class Message {
  String content;
  String from;
  String date;

  Message({required this.content, required this.from, required this.date});
  factory Message.fromJson(Map<String, dynamic> jsonObejct) {
    return Message(
        content: jsonObejct['content'],
        from: jsonObejct['from'],
        date: jsonObejct['date']);
  }
}
