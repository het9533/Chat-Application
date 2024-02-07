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
      final userID = user.uid;
      users
          .doc(userID)
          .set({
            // Add user data
            'First Name': "${userDetails.firstName}",
            'Last Name': "${userDetails.lastName}",
            'email': userDetails.email,
            'PhoneNumber': userDetails.number,
            'Profile Photo': userDetails.imagepath,
          })
          .then(
              (value) => print("User Added : ${users.doc(userID).toString()}"))
          .catchError((error) => print("Failed to add user: $error"));
    } catch (error) {
      print("Error adding user: $error");
    }
  }

  Future<void> updateUser(UserDetails userDetails) async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      final userID = user.uid;
      users
          .doc(userID)
          .update({
            'First Name': "${userDetails.firstName}",
            'Last Name': "${userDetails.lastName}",
            'email': userDetails.email,
            'PhoneNumber': userDetails.number,
            'Profile Photo': userDetails.imagepath,
          })
          .then(
              (value) => print("User Added : ${users.doc(userID).toString()}"))
          .catchError((error) => print("Failed to add user: $error"));
    } catch (error) {
      print("Error adding user: $error");
    }
  }

  Future<UserDetails> getCurrentUserDetails(String docID) {
    try {
      return users.doc(docID).get().then((value) {
        return UserDetails(
          email: value['email'],
          firstName: value['First Name'],
          lastName: value['Last Name'],
          number: value['PhoneNumber'],
          imagepath: value['Profile Photo'],
        );
      }).catchError((error) {
        return error;
      });
    } catch (error) {
      throw error;
    }
  }

  Future<bool> checkIfDocExists(String docId) async {
    try {
      var collectionRef = FirebaseFirestore.instance.collection('users');

      var doc = await collectionRef.doc(docId).get();
      return doc.exists;
    } catch (e) {
      throw e;
    }
  }
}
