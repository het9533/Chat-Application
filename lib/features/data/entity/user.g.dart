// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserDetails _$UserDetailsFromJson(Map<String, dynamic> json) => UserDetails(
      userName: json['userName'] as String?,
      userId: json['userId'] as String?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      email: json['email'] as String?,
      number: json['number'] as String?,
      password: json['password'] as String?,
      imagepath: json['imagepath'] as String?,
      signUpType: $enumDecodeNullable(_$SignUpTypeEnumMap, json['signUpType']),
    );

Map<String, dynamic> _$UserDetailsToJson(UserDetails instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('userName', instance.userName);
  writeNotNull('userId', instance.userId);
  writeNotNull('firstName', instance.firstName);
  writeNotNull('lastName', instance.lastName);
  writeNotNull('email', instance.email);
  writeNotNull('number', instance.number);
  writeNotNull('password', instance.password);
  writeNotNull('imagepath', instance.imagepath);
  writeNotNull('signUpType', _$SignUpTypeEnumMap[instance.signUpType]);
  return val;
}

const _$SignUpTypeEnumMap = {
  SignUpType.google: 'google',
  SignUpType.email: 'email',
};
