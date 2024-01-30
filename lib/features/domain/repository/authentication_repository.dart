// data/authentication/authentication_repository.dart

import 'package:chat_app/features/data/entity/user.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthenticationRepository {

Future<Either<User, String>> signInWithGoogle();

Future<bool> signout();

Future<Either<User,String>> createAccountWithEmail(UserDetails userDetails);
Future<Either<User,String>> signInWithEmail(UserDetails userDetails);
Future<Either<User,String>> getCurrentUser();

}
