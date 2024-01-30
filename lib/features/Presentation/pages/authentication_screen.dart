// // presentation/authentication/authentication_screen.dart
// import 'package:chat_app/features/Presentation/pages/user_profile_screen.dart';
// import 'package:chat_app/features/data/entity/user.dart';
// import 'package:chat_app/features/dependencyInjector/injector.dart';
// import 'package:chat_app/features/domain/usecase/authentication_usecase.dart';
// import 'package:flutter/material.dart';




// class AuthenticationScreen extends StatelessWidget {
//   final authenticationUseCase =sl<AuthenticationUseCase>();

  

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Authentication Screen'),
//       ),
//       body: AuthenticationBody(authenticationUseCase: authenticationUseCase,user: user,),
//     );
//   }
// }

// class AuthenticationBody extends StatelessWidget {
// final AuthenticationUseCase authenticationUseCase;
// final UserDetails user;

//   const AuthenticationBody({super.key, required this.authenticationUseCase, required this.user});


  
  
//   @override
//   Widget build(BuildContext context) {
     
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           ElevatedButton(
//             onPressed: () async {
//               var user = await authenticationUseCase.signInWithGoogle();
            
//               await  Future.delayed(Duration(seconds: 2));
//               Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => UserProfileScreen(
//                       authenticationUseCase: authenticationUseCase,
//                       user:  user,
//                     ),
//                   ));

//               // instead of directly calling signInWithGoogle method
//               // from the _AuthenticationScreenState
//               // Handle navigation in the use case or via callback
//             },
//             child: Text('Login with Google'),
//           ),
//           // Other buttons...
//         ],
//       ),
//     );
//   }
// }

// // Other authentication related screens (SignUp, SignIn) can be similarly refactored.
