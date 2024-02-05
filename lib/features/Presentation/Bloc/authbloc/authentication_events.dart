import 'package:chat_app/features/data/entity/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthenticationEvent {}

class AuthenticationStartedEvent extends AuthenticationEvent {}

class AuthentticatedUserEvent extends AuthenticationEvent {}

class GoogleSignInRequestedEvent extends AuthenticationEvent {}

class EmailSignInRequestedEvent extends AuthenticationEvent {
  final UserDetails user;
  EmailSignInRequestedEvent(this.user);
}

class OTPSignInRequestedEvent extends AuthenticationEvent {
  final String otp;

  OTPSignInRequestedEvent(this.otp);
}

class EmailSignUpRequestedEvent extends AuthenticationEvent {
  final UserDetails user;
  EmailSignUpRequestedEvent(this.user);
}

class LogoutRequestedEvent extends AuthenticationEvent {}
