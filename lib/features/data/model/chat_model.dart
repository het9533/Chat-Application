import 'package:chat_app/features/data/entity/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chat_model.g.dart';

enum ChatType {
  private,
  group,  
}

@JsonSerializable(explicitToJson: true)
class Chat {
  String? chatId;
  DateTime? createdAt;
  String? groupImage;
  String? groupName;
  Map<String, dynamic>? lastMessage;
  List<String>? users;
  ChatType? type;
  Map<String,UserDetails>? usersInfo;
  String? readby;

  Chat({
    this.readby,
    this.usersInfo,
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
