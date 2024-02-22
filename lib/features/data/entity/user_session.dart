import 'package:chat_app/features/data/entity/user.dart';
import 'package:chat_app/features/data/model/chat_model.dart';
import 'package:chat_app/features/data/model/message_model.dart';

class UserSession{

UserDetails? userDetails;
List<Chat> chats = [];
List<Message>? message;
Map<String, int> unReadCount = {};

}