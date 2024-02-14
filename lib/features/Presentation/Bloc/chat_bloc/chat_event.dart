import 'package:chat_app/features/data/model/chat_model.dart';
import 'package:chat_app/features/data/model/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class ChatEvent {}

class InitialChatEvent extends ChatEvent {}

class AddChatEvent extends ChatEvent {
  final String chatId;
  final Chat chat;
  final Message message;
  AddChatEvent({ required this.chatId, required this.chat, required this.message});
}

class LoadChatEvent extends ChatEvent {
  final String chatId;
  LoadChatEvent({required this.chatId});
}

class DeleteChatEvent extends ChatEvent {}

class AddMessageEvent extends ChatEvent {
  final Chat chat;
  final Message message;
  final String chatId;
  AddMessageEvent({required this.chat,required this.message, required this.chatId});
}

class LoadMessageEvent extends ChatEvent {}

class UpdateMessageEvent extends ChatEvent {
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> docs;
  UpdateMessageEvent({required this.docs});
}

class DeleteMessageEvent extends ChatEvent {}
