import 'package:chat_app/features/Presentation/Bloc/authbloc/authentication_bloc.dart';
import 'package:chat_app/features/Presentation/Bloc/authbloc/authentication_events.dart';
import 'package:chat_app/features/Presentation/pages/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserProfileScreen extends StatelessWidget {
  final User? user;

  UserProfileScreen({required this.user});

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
                  context.read<AuthenticationBloc>().add(LogoutRequestedEvent());
                 
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => WelcomeScreen()));
                },
                child: Text("SignOut"))
          ],
        ),
      ),
    );
  }
}
