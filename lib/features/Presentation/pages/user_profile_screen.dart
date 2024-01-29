// presentation/user_profile/user_profile_screen.dart
import 'package:chat_app/features/Presentation/pages/authentication_screen.dart';
import 'package:chat_app/features/data/entity/user.dart';
import 'package:chat_app/features/domain/usecase/authentication_usecase.dart';
import 'package:flutter/material.dart';

class UserProfileScreen extends StatelessWidget {
  final UserDetails? user;
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
            Text('Number: ${user?.number ?? "N/A"}'),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () async {
                  authenticationUseCase.signout();
                  await Future.delayed(Duration(seconds: 1));
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
