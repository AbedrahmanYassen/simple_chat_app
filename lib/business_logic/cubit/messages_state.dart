part of 'messages_cubit.dart';

@immutable
abstract class MessagesState {}

class MessagesInitial extends MessagesState {}

class MessagesListState extends MessagesState {
  final List<Message> messages;
  MessagesListState({required this.messages});
}
