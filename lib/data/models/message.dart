class Message {
  late String content;
  late String from;
  late String date;

  Message.fromJson(Map<String, dynamic> jsonObejct) {
    content = jsonObejct['content'];
    from = jsonObejct['from'];
    date = jsonObejct['date'];
  }
}
