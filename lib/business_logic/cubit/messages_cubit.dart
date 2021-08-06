import 'package:bloc/bloc.dart';
import 'package:islamic_chat_app/data/models/message.dart';
import 'package:islamic_chat_app/data/repository/messages_repository.dart';
import 'package:meta/meta.dart';

part 'messages_state.dart';

class MessagesCubit extends Cubit<MessagesState> {
  late MessagesRepository messagesRepository;
  List<Message> messages = [];
  MessagesCubit({
    required this.messagesRepository,
  }) : super(MessagesInitial());
  List<Message> getAllMessages() {
    messagesRepository.getAllMessages().then((messages) {
      emit(MessagesListState(messages: messages));
      this.messages = messages;
    });
    return messages;
  }
}
