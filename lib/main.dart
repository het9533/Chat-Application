// main.dart
import 'package:chat_app/common/constants/color_constants.dart';
import 'package:chat_app/features/Presentation/authbloc/authentication_bloc.dart';
import 'package:chat_app/features/Presentation/pages/login_screen.dart';
import 'package:chat_app/features/Presentation/pages/signup_page.dart';
import 'package:chat_app/features/dependencyInjector/injector.dart';
import 'package:chat_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await setup();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthenticationBloc>(
          create: (BuildContext context) => sl(),
        ),
        
      ],
      child: MaterialApp(
        theme: ThemeData(
          scaffoldBackgroundColor: ColorAssets.neomCream,
        ),
        home: LoginPage(),
        ),
       
    
    );
  }
}
