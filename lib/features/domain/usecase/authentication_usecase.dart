// domain/authentication/authentication_usecase.dart

import 'dart:async';

import 'package:chat_app/features/data/entity/user.dart';
import 'package:chat_app/features/domain/repository/authentication_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationUseCase {
  final AuthenticationRepository authenticationRepository;
  AuthenticationUseCase(this.authenticationRepository);

  

  Future<Either<User,String>> signInWithGoogle(UserDetails params) async {
    return await authenticationRepository.signInWithGoogle(params);
  }
   Future<bool> signout() async {
    return await authenticationRepository.signout();
  }

  Future<Either<User, String>> createAccountWithEmail(UserDetails params) async{
    return await authenticationRepository.createAccountWithEmail(params);
  }
  Future<Either<User, String>> signInWithEmail(UserDetails params) async{
    return await authenticationRepository.createAccountWithEmail(params);
  }
  Future<Either<User, String>> getCurrentUser() async{
    return await authenticationRepository.getCurrentUser();
  }

  // Phone authentication-related use cases...
  Future<void> verifyPhoneNumber(String phoneNumber) async{
    return await authenticationRepository.verifyPhoneNumber(phoneNumber);
  }

Future<void> verifyOTPCode(String smsCode) async{
  return await authenticationRepository.verifyOTPCode(smsCode);
}
}
