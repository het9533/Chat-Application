import 'dart:async';

import 'package:chat_app/features/data/entity/user.dart';
import 'package:chat_app/features/domain/repository/authentication_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthenticationRepositoryImplementation extends AuthenticationRepository{
 
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  late UserDetails user;


    Future<UserDetails?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      final User? user = userCredential.user;
      print(user);

      if (user != null) {
        return UserDetails(
          displayName: user.displayName ?? "",
          email: user.email ?? "",
          number: user.phoneNumber ?? "XXXXXXXXXX"
        );
      } else {
        return null;
      }
    } catch (e) {
      print("Error signing in with Google: $e");
      return null;
    }
  }

  // FutureOr<void> signout(BuildContext context) async{
    
  //   FirebaseAuth.instance.signOut();
  
  //       ));

  // }
  Future<void>signout() async {
     

    try {
      await _googleSignIn.signOut();
        
    } catch (e) {
      print("Error signing out: $e");
    }
  }



}