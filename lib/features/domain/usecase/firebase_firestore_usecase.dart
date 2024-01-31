import 'package:chat_app/features/data/entity/user.dart';
import 'package:chat_app/features/domain/repository/firebase_firestore_repository.dart';

class FirebaseFirestoreUseCase{

final FirebaseFirestoreRepository firebaseFirestoreRepository;

FirebaseFirestoreUseCase({required this.firebaseFirestoreRepository});

Future<void> addUser(UserDetails params)async{
  return await firebaseFirestoreRepository.addUser(params); 
}



}