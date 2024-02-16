import 'package:chat_app/features/data/model/chat_model.dart';
import 'package:chat_app/features/data/model/message_model.dart';

abstract class ChatEvent {}

class InitialChatEvent extends ChatEvent {}

class AddChatEvent extends ChatEvent {
  final String chatId;
  final Chat chat;
  final Message message;
  AddChatEvent({ required this.chatId, required this.chat, required this.message});
}





class LoadMessageEvent extends ChatEvent {
  final String chatId;
  LoadMessageEvent({required this.chatId});
}

class DeleteChatEvent extends ChatEvent {}

class AddMessageEvent extends ChatEvent {
  final Chat chat;
  final Message message;
  final String chatId;
  AddMessageEvent({required this.chat,required this.message, required this.chatId});
}



class EditedMessageEvent extends ChatEvent{
  final String chatId ;
  final String messageId;
  final String newMessage;

  EditedMessageEvent({required this.chatId, required this.messageId, required this.newMessage});


}
class LoadChatEvent extends ChatEvent{

}

class UpdateMessageEvent extends ChatEvent {
  final List<Message> docs;
  UpdateMessageEvent({required this.docs});
}

class DeleteMessageEvent extends ChatEvent {
  final String chatId;
  final List<String> MessageId;

  DeleteMessageEvent(this.MessageId, {required this.chatId});

}
class UpdateUnreadCountEvent extends ChatEvent{

}