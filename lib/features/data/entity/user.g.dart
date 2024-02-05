// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserDetails _$UserDetailsFromJson(Map<String, dynamic> json) => UserDetails(
      displayName: json['displayName'] as String?,
      email: json['email'] as String?,
      number: json['number'] as String?,
      password: json['password'] as String?,
      imagepath: json['imagepath'] as String?,
    );

Map<String, dynamic> _$UserDetailsToJson(UserDetails instance) =>
    <String, dynamic>{
      'displayName': instance.displayName,
      'email': instance.email,
      'number': instance.number,
      'password': instance.password,
      'imagepath': instance.imagepath,
    };
