// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Message _$MessageFromJson(Map<String, dynamic> json) => Message(
      messageId: json['messageId'] as String?,
      content: json['content'] as String?,
      seenby: json['seenby'] as List<dynamic>?,
      sender: json['sender'] as String?,
      timeStamp: json['timeStamp'] == null
          ? null
          : DateTime.parse(json['timeStamp'] as String),
    );

Map<String, dynamic> _$MessageToJson(Message instance) => <String, dynamic>{
      'messageId': instance.messageId,
      'content': instance.content,
      'seenby': instance.seenby,
      'sender': instance.sender,
      'timeStamp': instance.timeStamp?.toIso8601String(),
    };
