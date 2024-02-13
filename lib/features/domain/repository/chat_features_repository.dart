import 'package:chat_app/features/data/model/chat_model.dart';
import 'package:chat_app/features/data/model/message_model.dart';

abstract class ChatFeaturesRepository {
  String chatRoomId(String user1, String user2);

  Future<void> sendMessage(String chatId, Chat chat, Message message);
  
  Stream<List<Message>> getMessages(String chatId);
  
  Future<void> updateMessage(
      String chatId, String messageId, String newMessage);
  
  Future<void> deleteMessage(String chatId, String messageId);
}
