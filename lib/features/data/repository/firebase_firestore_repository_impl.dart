import 'package:chat_app/features/data/entity/user.dart';
import 'package:chat_app/features/domain/repository/firebase_firestore_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// class FirebaseFirestoreRepositoryImplement extends FirebaseFirestoreRepository {
//   FirebaseFirestore firestore = FirebaseFirestore.instance;
//   CollectionReference users = FirebaseFirestore.instance.collection('users');

//   Future<void> addUser(UserDetails userDetails) async {
//     try {
//       final user = FirebaseAuth.instance.currentUser!;
//       final userID = user.uid;
//       users
//           .doc(userID)
//           .set({
//             // Add user data
//             'firstName': "${userDetails.firstName}",
//             'lastName': "${userDetails.lastName}",
//             'email': userDetails.email,
//             'phoneNumber': userDetails.number,
//             'profilePhoto': userDetails.imagepath,
//           })
//           .then(
//               (value) => print("User Added : ${users.doc(userID).toString()}"))
//           .catchError((error) => print("Failed to add user: $error"));
//     } catch (error) {
//       print("Error adding user: $error");
//     }
//   }

//   Future<void> updateUser(UserDetails userDetails) async {
//     try {
//       final user = FirebaseAuth.instance.currentUser!;
//       final userID = user.uid;
//       users
//           .doc(userID)
//           .update({
//             'firstName': userDetails.firstName,
//             'lastName': userDetails.lastName,
//             'email': userDetails.email,
//             'phoneNumber': userDetails.number,
//             'profilePhoto': userDetails.imagepath,
//           })
//           .then(
//               (value) => print("User Added : ${users.doc(userID).toString()}"))
//           .catchError((error) => print("Failed to add user: $error"));
//     } catch (error) {
//       print("Error adding user: $error");
//     }
//   }

//   Future<UserDetails> getCurrentUserDetails(String docID) {
//     try {
//       return users.doc(docID).get().then((value) {
//         return UserDetails(
//           email: value['email'],
//           firstName: value['firstName'],
//           lastName: value['lastName'],
//           number: value['phoneNumber'],
//           imagepath: value['profilePhoto'],
//         );
//       }).catchError((error) {
//         return error;
//       });
//     } catch (error) {
//       throw error;
//     }
//   }

//   Future<bool> checkIfDocExists(String? docId) async {
//     try {
//       var doc = await users.doc(docId).get();
//       return doc.exists;
//     } catch (e) {
//       throw e;
//     }
//   }
// }
class FirebaseFirestoreRepositoryImplement extends FirebaseFirestoreRepository {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<void> addUser(UserDetails userDetails) async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      final userID = user.uid;
      users
          .doc(userID)
          .set(userDetails.toJson()) // Using toJson method here
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
          .update(userDetails.toJson()) // Using toJson method here
          .then(
              (value) => print("User Added : ${users.doc(userID).toString()}"))
          .catchError((error) => print("Failed to add user: $error"));
    } catch (error) {
      print("Error adding user: $error");
    }
  }

  Future<UserDetails> getCurrentUserDetails(String docID) async {
    try {
      return users.doc(docID).get().then((value) {
        return UserDetails.fromJson(value.data() as Map<String, dynamic>); // Using fromJson method here
      }).catchError((error) {
        return error;
      });
    } catch (error) {
      throw error;
    }
  }

  Future<bool> checkIfDocExists(String? docId) async {
    try {
      var doc = await users.doc(docId).get();
      return doc.exists;
    } catch (e) {
      throw e;
    }
  }
  Future<bool>doesUserNameUserExist(String currentUserName, String docId ) async {
    try {

// if the size of value is greater then 0 then that doc exist. 
      var userNameUser = await users
          .where('userName', isEqualTo: currentUserName)
          .where(FieldPath.documentId, isNotEqualTo:docId)
          .get()
          .then((value) => value.size > 0 ? true : false);
      
      if(userNameUser){
        return true;
      }
      return false;
          
    } catch (e) {
      throw(e.toString());
     
    }
  }
  Future<bool>doesUserEmailExist(String email ) async {
    try {

// if the size of value is greater then 0 then that doc exist. 
      var userNameUser = await users
          .where('email', isEqualTo: email)
          .get()
          .then((value) => value.size > 0 ? true : false);
      
      if(userNameUser){
        return true;
      }
      return false;
          
    } catch (e) {
      throw(e.toString());
     
    }
  }


}
