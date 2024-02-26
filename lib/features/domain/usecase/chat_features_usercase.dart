import 'package:chat_app/features/data/model/chat_model.dart';
import 'package:chat_app/features/data/model/message_model.dart';
import 'package:chat_app/features/domain/repository/chat_features_repository.dart';

class ChatFeaturesUseCase {
  final ChatFeaturesRepository chatFeaturesRepository;

  ChatFeaturesUseCase({required this.chatFeaturesRepository});

  String chatRoomId(String user1, String user2) {
    return chatFeaturesRepository.chatRoomId(user1, user2);
  }

  Future<void> sendMessage(String chatId, Chat chat, Message? message) async {
    return await chatFeaturesRepository.sendMessage(chatId, chat, message);
  }

  Stream<List<Message>> getMessages(String chatId) {
    return chatFeaturesRepository.getMessages(chatId);
  }

  Future<void> updateMessage(
      String chatId, String messageId, String newMessage) async {
    return await chatFeaturesRepository.updateMessage(
        chatId, messageId, newMessage);
  }

  Future<void> deleteMessage(String chatId, List<String> messageId) async {
    return await chatFeaturesRepository.deleteMessage(chatId, messageId);
  }
}
