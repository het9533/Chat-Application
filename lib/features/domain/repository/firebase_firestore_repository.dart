import 'package:chat_app/features/data/entity/user.dart';

abstract class FirebaseFirestoreRepository{
  Future<void> addUser(UserDetails userDetails);
  Future<void> updateUser(UserDetails userDetails);
  Future<bool> checkIfDocExists(String docId);
  Future<UserDetails> getCurrentUserDetails(String docID);
}