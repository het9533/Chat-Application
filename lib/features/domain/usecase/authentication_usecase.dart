// domain/authentication/authentication_usecase.dart

import 'dart:async';

import 'package:chat_app/features/data/entity/user.dart';
import 'package:chat_app/features/domain/repository/authentication_repository.dart';

class AuthenticationUseCase {
  final AuthenticationRepository authenticationRepository;
  AuthenticationUseCase(this.authenticationRepository);

  

  Future<UserDetails?> signInWithGoogle() async {
    // Delegate the logic to the repository
    return authenticationRepository.signInWithGoogle();
  }
   Future<void> signout() async {
    return authenticationRepository.signout();
  }

  // Other authentication-related use cases...
}
