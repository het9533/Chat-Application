import 'package:chat_app/features/Presentation/pages/auth_screens/login_screen.dart';
import 'package:chat_app/features/Presentation/pages/auth_screens/signup_page.dart';
import 'package:chat_app/features/Presentation/pages/auth_screens/welcome_screen.dart';
import 'package:chat_app/features/Presentation/pages/chat_screens/chat_home_page.dart';
import 'package:chat_app/features/Presentation/pages/email_verification/account_success_screen.dart';
import 'package:chat_app/features/Presentation/pages/email_verification/email_verification_screen.dart';
import 'package:chat_app/features/Presentation/pages/user_profile/profile_page.dart';
import 'package:chat_app/features/data/entity/user.dart';
import 'package:chat_app/features/dependencyInjector/injector.dart';
import 'package:chat_app/features/domain/usecase/firebase_firestore_usecase.dart';
import 'package:flutter/material.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class AppNavigator {
  static GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static Route<dynamic> materialAppsRoute(RouteSettings settings) {
    switch (settings.name) {
      case WelcomeScreen.welcomescreen:
        return MaterialPageRoute(builder: (context) => const WelcomeScreen());
      case LoginPage.loginpage:
        return MaterialPageRoute(builder: (context) => const LoginPage());
      case SignUpPage.signuppage:
        return MaterialPageRoute(
          builder: (context) => SignUpPage(
              firebaseFirestoreUseCase: sl<FirebaseFirestoreUseCase>()),
        );
      case ProfilePage.profilepage:
        var args = settings.arguments as UserDetails;

        return MaterialPageRoute<UserDetails>(
          builder: (context) => ProfilePage(
              userDetails: args),
              settings: settings
      
        );
      case VerifyEmailScreen.verifyemailscreen:
        return MaterialPageRoute(
          builder: (context) => VerifyEmailScreen(
              firebaseFirestoreUseCase: sl<FirebaseFirestoreUseCase>()),
        );

        case AccountCreatedSuccessScreen.accountCreatedSuccessScreen:
        return MaterialPageRoute(
          builder: (context) => AccountCreatedSuccessScreen(
              ),
        );
        case ChatHomePage.chatHomePage:
        return MaterialPageRoute(
          builder: (context) => ChatHomePage(
              ),
        );


      default:
        return MaterialPageRoute(
          builder: (context) =>
              UndefinedView(name: settings.name ?? 'undefined name'),
        );
    }
  }
}

class UndefinedView extends StatelessWidget {
  final String name;

  const UndefinedView({
    required this.name,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Route for $name is not defined!'),
      ),
    );
  }
}
