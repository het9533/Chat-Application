import 'package:chat_app/features/data/model/message_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chat_model.g.dart';

// Assuming you have a ChatType enum defined somewhere
enum ChatType {
  private,
  group,  // Add other types as necessary
}

@JsonSerializable()
class Chat {
  Message? message;
  String? chatId;
  DateTime? createdAt;
  String? groupImage;
  String? groupName;
  Map<dynamic, dynamic>? lastMessage;
  List? users;
  ChatType? type; // Use ChatType instead of Enum

  Chat({
    this.message,
    this.chatId,
    this.createdAt,
    this.groupImage,
    this.groupName,
    this.lastMessage,
    this.type,
    this.users,
  });

  factory Chat.fromJson(Map<String, dynamic> json) => _$ChatFromJson(json);

  Map<dynamic, dynamic> toJson() => _$ChatToJson(this);
}
