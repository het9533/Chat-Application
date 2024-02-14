import 'package:cloud_firestore/cloud_firestore.dart';

abstract class ChatState {}

class InitialChatState extends ChatState {}

class ChatAddedState extends ChatState{}



class ChatLoadedState extends ChatState {
  List chatList;
  ChatLoadedState({required this.chatList});
}

class ChatUpdatedState extends ChatState {
  List chatList;
  ChatUpdatedState({required this.chatList});
}

class ChatErrorState extends ChatState {
  String error;
  ChatErrorState({required this.error});
}

class MessageLoadedState extends ChatState {
  List messageList;
  MessageLoadedState({required this.messageList});
}

class MessageUpdatedState extends ChatState {
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> docs;
  MessageUpdatedState({required this.docs});
}

class MessageErrorState extends ChatState {
  String error;
  MessageErrorState({required this.error});
}
