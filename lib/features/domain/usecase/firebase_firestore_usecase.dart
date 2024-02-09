import 'package:chat_app/features/data/entity/user.dart';
import 'package:chat_app/features/domain/repository/firebase_firestore_repository.dart';

class FirebaseFirestoreUseCase{

final FirebaseFirestoreRepository firebaseFirestoreRepository;

FirebaseFirestoreUseCase({required this.firebaseFirestoreRepository});

Future<void> addUser(UserDetails params)async{
  return await firebaseFirestoreRepository.addUser(params); 
}

Future<void> updateUser(UserDetails params)async{
  return await firebaseFirestoreRepository.updateUser(params); 
}
Future<bool> checkIfDocExists(String docId) async{
  return await firebaseFirestoreRepository.checkIfDocExists(docId);
}
Future<UserDetails> getCurrentUserDetails(String docID) {
  return firebaseFirestoreRepository.getCurrentUserDetails(docID);
}
Future<bool>doesUserNameUserExist(String currentUserName , String docID) async{
  return await firebaseFirestoreRepository.doesUserNameUserExist(currentUserName, docID);
}


}