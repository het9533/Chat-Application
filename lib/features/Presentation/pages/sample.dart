import 'package:chat_app/features/Presentation/authbloc/authentication_bloc.dart';
import 'package:chat_app/features/Presentation/authbloc/authentication_events.dart';
import 'package:chat_app/features/Presentation/authbloc/authentication_states.dart';
import 'package:chat_app/features/Presentation/pages/user_profile_screen.dart';
import 'package:chat_app/features/dependencyInjector/injector.dart';
import 'package:chat_app/features/domain/repository/authentication_repository.dart';
import 'package:chat_app/features/domain/usecase/authentication_usecase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthenticationScreen extends StatefulWidget {
  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: 
          BlocListener<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          if (state is AuthenticationInitial) {
             buildInitialUI(); // Replace with your initial UI
          } else if (state is AuthenticationLoading) {
             buildLoadingUI(); // Replace with your loading UI
          } else if (state is AuthenticationSuccess) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => UserProfileScreen(
                    authenticationUseCase:
                        AuthenticationUseCase(sl<AuthenticationRepository>()),
                    user: state.user,
                  ),
                )); // Replace with your success UI
          } else if (state is AuthenticationFailure) {
            buildFailureUI(state.error); // Replace with your failure UI
          } 
          
        },
        child: AuthenticationBody(),
      ),
        
      ),
    );
  }
}



  // Replace these methods with your actual UI components
  Widget buildInitialUI() {
    return Scaffold(
      appBar: AppBar(
        title: Text('Authentication Screen'),
      ),
      body: AuthenticationBody(),
    );
  }

  Widget buildLoadingUI() {
    return Center(child: CircularProgressIndicator());
  }

  Widget buildSuccessUI(User user) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Welcome, ${user.displayName}'),
          // Other success UI components...
        ],
      ),
    );
  }

  Widget buildFailureUI(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Authentication Failed: $error'),
          // Other failure UI components...
        ],
      ),
    );
  }


class AuthenticationBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
   
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
             context.read<AuthenticationBloc>().add(GoogleSignInRequested());
             
            },
            child: Text('Login with Google'),
          ),
          SizedBox(
            height: 10,
          ),
          ElevatedButton(
            onPressed: () {
              context.read<AuthenticationBloc>().add(LogoutRequested());
            },
            child: Text('SignOut'),
          ),
          // Other buttons...
        ],
      ),
    );
  }
}
