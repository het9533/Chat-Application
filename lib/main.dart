// main.dart
import 'package:chat_app/common/constants/color_constants.dart';
import 'package:chat_app/common/constants/routes.dart';
import 'package:chat_app/features/Presentation/Bloc/authbloc/authentication_bloc.dart';
import 'package:chat_app/features/Presentation/Bloc/phone_authentication_bloc/phone_authentication_bloc.dart';
import 'package:chat_app/features/Presentation/pages/auth_screens/login_screen.dart';
import 'package:chat_app/features/Presentation/pages/auth_screens/signup_page.dart';
import 'package:chat_app/features/Presentation/pages/email_verification/account_success_screen.dart';
import 'package:chat_app/features/Presentation/pages/email_verification/email_verification_screen.dart';
import 'package:chat_app/features/Presentation/pages/homepage.dart';
import 'package:chat_app/features/Presentation/pages/user_profile/profile_page.dart';
import 'package:chat_app/features/Presentation/pages/auth_screens/welcome_screen.dart';
import 'package:chat_app/features/data/entity/user.dart';
import 'package:chat_app/features/dependencyInjector/injector.dart';
import 'package:chat_app/features/domain/usecase/firebase_firestore_usecase.dart';
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
        BlocProvider<PhoneAuthenticationBloc>(
          create: (BuildContext context) => sl(),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(
          scaffoldBackgroundColor: ColorAssets.neomCream,
        ),
        initialRoute: '/',
        routes: {
      
          initialRoute: (context) => WelcomeScreen(),
          LoginPageRoute: (context) => LoginPage(),
          SignUpPageRoute : (context) => SignUpPage(firebaseFirestoreUseCase: sl<FirebaseFirestoreUseCase>()),
          UserProfileScreenRoute:(context) => ProfilePage(userDetails: UserDetails(),),
          VerifyEmailScreenRoute : (context) => VerifyEmailScreen(firebaseFirestoreUseCase: sl<FirebaseFirestoreUseCase>(),),
          AccountCreatedSuccessScreenRoute : (context)=>AccountCreatedSuccessScreen(),
          HomeScreenRoute : (context) => HomePage()
        },
      ),
    );
  }
}
