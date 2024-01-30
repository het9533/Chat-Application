import 'package:chat_app/features/data/entity/user.dart';

abstract class AuthenticationEvent {}

class AuthenticationStarted extends AuthenticationEvent {}

class GoogleSignInRequested extends AuthenticationEvent {}

class EmailSignInRequested extends AuthenticationEvent {
  final UserDetails user;
  EmailSignInRequested(this.user);
}

class OTPSignInRequested extends AuthenticationEvent {
  final String otp;

  OTPSignInRequested(this.otp);
}

class SignUpRequested extends AuthenticationEvent {
  final UserDetails user;
  SignUpRequested(this.user);
}

class LogoutRequested extends AuthenticationEvent {}
