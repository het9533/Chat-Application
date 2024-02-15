// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Message _$MessageFromJson(Map<String, dynamic> json) => Message(
      messageId: json['messageId'] as String?,
      content: json['content'] as String?,
      seenby:
          (json['seenby'] as List<dynamic>?)?.map((e) => e as String).toList(),
      sender: json['sender'] as String?,
      timeStamp: json['timeStamp'] == null
          ? null
          : DateTime.parse(json['timeStamp'] as String),
    );

Map<String, dynamic> _$MessageToJson(Message instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('messageId', instance.messageId);
  writeNotNull('content', instance.content);
  writeNotNull('seenby', instance.seenby);
  writeNotNull('sender', instance.sender);
  writeNotNull('timeStamp', instance.timeStamp?.toIso8601String());
  return val;
}
