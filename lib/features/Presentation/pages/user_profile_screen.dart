// presentation/user_profile/user_profile_screen.dart
import 'package:chat_app/features/Presentation/authbloc/authentication_bloc.dart';
import 'package:chat_app/features/Presentation/authbloc/authentication_events.dart';
import 'package:chat_app/features/Presentation/pages/sample.dart';
import 'package:chat_app/features/domain/usecase/authentication_usecase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserProfileScreen extends StatelessWidget {
  final User? user;
  final AuthenticationUseCase authenticationUseCase;

  UserProfileScreen({required this.user, required this.authenticationUseCase});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Name: ${user?.displayName ?? "N/A"}'),
            Text('Email: ${user?.email ?? "N/A"}'),
            Text('Number: ${user?.phoneNumber ?? "N/A"}'),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () async {
                  context.read<AuthenticationBloc>().add(LogoutRequested());
                 
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AuthenticationScreen()));
                },
                child: Text("SignOut"))
          ],
        ),
      ),
    );
  }
}
