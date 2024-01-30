import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthenticationState {}

class AuthenticationInitial extends AuthenticationState {}

class AuthenticationLoading extends AuthenticationState {}

class AuthenticationSuccess extends AuthenticationState {
  final User user;

  AuthenticationSuccess(this.user);
}

class AuthenticationFailure extends AuthenticationState {
  final String error;

  AuthenticationFailure(this.error);
}
