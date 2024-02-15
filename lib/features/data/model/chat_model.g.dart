// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Chat _$ChatFromJson(Map<String, dynamic> json) => Chat(
      readby: json['readby'] as String?,
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

Map<String, dynamic> _$ChatToJson(Chat instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('chatId', instance.chatId);
  writeNotNull('createdAt', instance.createdAt?.toIso8601String());
  writeNotNull('groupImage', instance.groupImage);
  writeNotNull('groupName', instance.groupName);
  writeNotNull('lastMessage', instance.lastMessage);
  writeNotNull('users', instance.users);
  writeNotNull('type', _$ChatTypeEnumMap[instance.type]);
  writeNotNull(
      'usersInfo', instance.usersInfo?.map((k, e) => MapEntry(k, e.toJson())));
  writeNotNull('readby', instance.readby);
  return val;
}

const _$ChatTypeEnumMap = {
  ChatType.private: 'private',
  ChatType.group: 'group',
};
