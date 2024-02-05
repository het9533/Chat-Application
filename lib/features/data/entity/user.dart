import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class UserDetails {
  String? displayName;
  String? email;
  String? number;
  String? password;
  String? imagepath;

  UserDetails(
      {this.displayName,
      this.email,
      this.number,
      this.password,
      this.imagepath});

  factory UserDetails.fromJson(Map<String, dynamic> json) => _$UserDetailsFromJson(json);

  Map<String,dynamic> toJson() => _$UserDetailsToJson(this);

}
