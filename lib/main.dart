// main.dart
import 'package:chat_app/common/constants/color_constants.dart';
import 'package:chat_app/features/Presentation/Bloc/authbloc/authentication_bloc.dart';
import 'package:chat_app/features/Presentation/Bloc/chat_bloc/chat_bloc.dart';
import 'package:chat_app/features/Presentation/Bloc/phone_authentication_bloc/phone_authentication_bloc.dart';
import 'package:chat_app/features/Presentation/Bloc/profile_page_bloc/profile_page_bloc.dart';
import 'package:chat_app/features/Presentation/pages/auth_screens/welcome_screen.dart';
import 'package:chat_app/features/Presentation/pages/chat_screens/home_page.dart';
import 'package:chat_app/features/dependencyInjector/injector.dart';
import 'package:chat_app/firebase_options.dart';
import 'package:chat_app/common/constants/routes.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
    appleProvider: AppleProvider.debug,
  );
  
  await setup();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthenticationBloc>(
          create: (BuildContext context) => sl<AuthenticationBloc>(),
        ),
        BlocProvider<PhoneAuthenticationBloc>(
          create: (BuildContext context) => sl<PhoneAuthenticationBloc>(),
        ),
        BlocProvider<ProfilePageBloc>(
          create: (BuildContext context) => sl<ProfilePageBloc>(),
        ),
        BlocProvider<ChatBloc>(
          create: (BuildContext context) => sl<ChatBloc>(),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(
          scaffoldBackgroundColor: ColorAssets.neomCream,
        ),
        onGenerateRoute: AppNavigator.materialAppsRoute,
        initialRoute: user != null ? ChatMainScreen.chatMainScreen : WelcomeScreen.welcomescreen,
      ),
    );
  }
}
