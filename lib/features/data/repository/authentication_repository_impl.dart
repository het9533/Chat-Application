import 'dart:async';

import 'package:chat_app/features/data/entity/user.dart';
import 'package:chat_app/features/domain/repository/authentication_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthenticationRepositoryImplementation extends AuthenticationRepository {


  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  User? user;

  // signin with google 
  @override
  Future<Either<User, String>> signInWithGoogle() async {
    final GoogleSignInAccount? googleSignInAccount =
        await _googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final UserCredential userCredential =
            await _auth.signInWithCredential(credential);

        user = userCredential.user!;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          return Right(e.code);
          // handle the error here
        } else if (e.code == 'invalid-credential') {
          return Right(e.code);
          // handle the error here
        }
      } catch (e) {
        return Right(e.toString());
        // handle the error here
      }
    }
    return Left(user!);
  }

// create account with email and password
  @override
  Future<Either<User, String>> createAccountWithEmail(
      UserDetails userDetails) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: userDetails.email!,
        password: userDetails.password!,
      );
      user = credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return const Right("Weak-Password");
        // print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        return const Right("The account already exists for that email.");
        // print('The account already exists for that email.');
      }
    } catch (e) {
      return Right(e.toString());
      // print(e);
    }
    return Left(user!);
  }

   //signinwith email function

  @override
  Future<Either<User, String>> signInWithEmail(UserDetails userDetails) async {
    try {
      print(userDetails.email);
      final credential = await _auth.signInWithEmailAndPassword(
        email: userDetails.email!,
        password: userDetails.password!,
      );
      user = credential.user!;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        return const Right('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        return const Right('Wrong password provided for that user.');
      }
    }
    return Left(user!);
  }
  //signout function

  @override
  Future<bool> signout() async {
    try {
      print(user?.uid);
      await _googleSignIn.signOut();
      await FirebaseAuth.instance.signOut();
    } on Exception catch (e) {
      print(e.toString());
      return false;
    }
    return true;
  }
  //get current user
  @override
  Future<Either<User, String>> getCurrentUser() async {
    user = _auth.currentUser;
    if (user != null) {
      return Left(user!);
    } else {
      return const Right('User is not signed in');
    }
  
  }

  //lOGIN With otp
  




}
