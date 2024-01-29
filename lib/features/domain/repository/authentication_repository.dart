// data/authentication/authentication_repository.dart

import 'package:chat_app/features/data/entity/user.dart';

abstract class AuthenticationRepository {

Future<UserDetails?> signInWithGoogle();

Future<void> signout();

}
