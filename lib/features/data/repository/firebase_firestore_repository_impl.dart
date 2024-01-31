import 'package:chat_app/features/data/entity/user.dart';
import 'package:chat_app/features/domain/repository/firebase_firestore_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseFirestoreRepositoryImplement extends FirebaseFirestoreRepository {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<void> addUser(UserDetails userDetails) async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      final userID = user.uid; // Get the authenticated user's UID

      users
          .doc(userID) // Set the document ID as the user's UID
          .set({
            // Add user data
            'Full Name': userDetails.displayName,
            'email': userDetails.email,
            'PhoneNumber': userDetails.number,
          })
          .then((value) => print("User Added : ${users.doc(userID).toString()}"))
          .catchError((error) => print("Failed to add user: $error"));
    } catch (error) {
      print("Error adding user: $error");
    }
  }
}
