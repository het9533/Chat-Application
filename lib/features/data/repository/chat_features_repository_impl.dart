import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chat_app/features/data/model/chat_model.dart';
import 'package:chat_app/features/data/model/message_model.dart';
import 'package:chat_app/features/domain/repository/chat_features_repository.dart';

class ChatFeaturesRepositoryImplementation extends ChatFeaturesRepository {
  @override
  String chatRoomId(String user1, String user2) {
    if (user1.hashCode<=
        user2.hashCode) {
      return "$user1$user2";
    } else {
      return "$user2$user1";
    }
  }

  @override
  Future<void> sendMessage(
      String chatId, Chat chat, Message message) async {
    try {
      await FirebaseFirestore.instance
          .collection('chats')
          .doc(chatId)
          .set(chat.toJson());
      await FirebaseFirestore.instance
          .collection('chats')
          .doc(chatId)
          .collection('messages').doc(message.messageId).set(message.toJson());
          
    } catch (e) {
      print('Error sending message: $e');
      throw Exception('Failed to send message');
    }
  }
    
  @override
  Stream<List<Message>> getMessages(String chatId) {
    try {
      return FirebaseFirestore.instance
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .orderBy('timeStamp', descending: true)
          .snapshots()
          .map((snapshot) =>
              snapshot.docs.map((doc) => Message.fromJson(doc.data())).toList());
    } catch (e) {
      print('Error getting messages: $e');
      throw Exception('Failed to get messages');
    }
  }

  @override
  Future<void> updateMessage(
      String chatId, String messageId, String newMessage) async {
    try {
      await FirebaseFirestore.instance
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .doc(messageId)
          .update({'content': newMessage});
    } catch (e) {
      print('Error updating message: $e');
      throw Exception('Failed to update message');
    }
  }

  @override
  Future<void> deleteMessage(String chatId, String messageId) async {
    try {
      await FirebaseFirestore.instance
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .doc(messageId)
          .delete();
    } catch (e) {
      print('Error deleting message: $e');
      throw Exception('Failed to delete message');
    }
  }
}
