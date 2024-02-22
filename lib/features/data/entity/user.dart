import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

enum SignUpType {
  google,
  email,
}

@JsonSerializable()
class UserDetails {
  String? userName;
  String? userId;
  String? firstName;
  String? lastName;
  String? email;
  String? number;
  String? password;
  String? imagepath;
  SignUpType? signUpType;

  UserDetails(
      {this.userName,
      this.userId,
      this.firstName,
      this.lastName,
      this.email,
      this.number,
      this.password,
      this.imagepath,
      required this.signUpType
      });

  factory UserDetails.fromJson(Map<String, dynamic> json) =>
      _$UserDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$UserDetailsToJson(this);
}
