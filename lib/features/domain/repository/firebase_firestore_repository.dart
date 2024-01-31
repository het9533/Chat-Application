import 'package:chat_app/features/data/entity/user.dart';

abstract class FirebaseFirestoreRepository{
  Future<void> addUser(UserDetails userDetails);
}