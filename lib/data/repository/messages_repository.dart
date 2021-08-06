import 'package:islamic_chat_app/data/models/message.dart';
import 'package:islamic_chat_app/data/web_services/messages_from_the_realtime_database.dart';

class MessagesRepository {
  final MessagesFromTheDatabase messagesFromTheDatabase;
  MessagesRepository(
      {required this.messagesFromTheDatabase, required String messageKey});
  Future<List<Message>> getAllMessages() async {
    Map<String, dynamic> messages =
        await messagesFromTheDatabase.getAllMessages();
    return messages.entries
        .map((element) => Message.fromJson(element.value))
        .toList();
  }
}
