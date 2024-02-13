// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Chat _$ChatFromJson(Map<String, dynamic> json) => Chat(
      usersInfo: (json['usersInfo'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, UserDetails.fromJson(e as Map<String, dynamic>)),
      ),
      chatId: json['chatId'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      groupImage: json['groupImage'] as String?,
      groupName: json['groupName'] as String?,
      lastMessage: json['lastMessage'] as Map<String, dynamic>?,
      type: $enumDecodeNullable(_$ChatTypeEnumMap, json['type']),
      users: json['users'] as List<dynamic>?,
    );

Map<String, dynamic> _$ChatToJson(Chat instance) => <String, dynamic>{
      'chatId': instance.chatId,
      'createdAt': instance.createdAt?.toIso8601String(),
      'groupImage': instance.groupImage,
      'groupName': instance.groupName,
      'lastMessage': instance.lastMessage,
      'users': instance.users,
      'type': _$ChatTypeEnumMap[instance.type],
      'usersInfo': instance.usersInfo?.map((k, e) => MapEntry(k, e.toJson())),
    };

const _$ChatTypeEnumMap = {
  ChatType.private: 'private',
  ChatType.group: 'group',
};
