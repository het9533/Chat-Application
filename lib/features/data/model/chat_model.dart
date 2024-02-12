import 'package:json_annotation/json_annotation.dart';

part 'chat_model.g.dart';

enum ChatType {
  private,
  group,  
}

@JsonSerializable()
class Chat {
  String? chatId;
  DateTime? createdAt;
  String? groupImage;
  String? groupName;
  Map<String, dynamic>? lastMessage;
  List? users;
  ChatType? type; // Use ChatType instead of Enum

  Chat({
   
    this.chatId,
    this.createdAt,
    this.groupImage,
    this.groupName,
    this.lastMessage,
    this.type,
    this.users,
  });

  factory Chat.fromJson(Map<String, dynamic> json) => _$ChatFromJson(json);

  Map<String, dynamic> toJson() => _$ChatToJson(this);
}
