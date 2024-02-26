import 'package:chat_app/features/Presentation/pages/auth_screens/login_screen.dart';
import 'package:chat_app/features/Presentation/pages/auth_screens/signup_page.dart';
import 'package:chat_app/features/Presentation/pages/auth_screens/welcome_screen.dart';
import 'package:chat_app/features/Presentation/pages/chat_screens/add_chat_screen.dart';
import 'package:chat_app/features/Presentation/pages/chat_screens/add_group_chat_screen.dart';
import 'package:chat_app/features/Presentation/pages/chat_screens/add_group_detail_screen.dart';
import 'package:chat_app/features/Presentation/pages/chat_screens/chat_home.dart';
import 'package:chat_app/features/Presentation/pages/chat_screens/chat_screen.dart';
import 'package:chat_app/features/Presentation/pages/chat_screens/edit_message_screen.dart';
import 'package:chat_app/features/Presentation/pages/chat_screens/home_page.dart';
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
        return MaterialPageRoute(builder: (context) => ProfilePage());
      case VerifyEmailScreen.verifyemailscreen:
        return MaterialPageRoute(
          builder: (context) => VerifyEmailScreen(
              firebaseFirestoreUseCase: sl<FirebaseFirestoreUseCase>()),
        );

      case AccountCreatedSuccessScreen.accountCreatedSuccessScreen:
        return MaterialPageRoute(
          builder: (context) => AccountCreatedSuccessScreen(),
        );
      case ChatHomePage.chatHomePage:
        return MaterialPageRoute(
          builder: (context) => ChatHomePage(),
        );
      case ChatMainScreen.chatMainScreen:
        return MaterialPageRoute(
          builder: (context) => ChatMainScreen(),
        );
      case ChatScreen.chatScreen:
        var args = settings.arguments as List<dynamic>;
        return MaterialPageRoute(
            builder: (context) => ChatScreen(
                  chatModel: args[0],
                  chatType: args[1],
                  
                ),
            settings: settings);
      case AddChatScreen.addChatScreen:
        return MaterialPageRoute(
          builder: (context) => AddChatScreen(),
        );
        case CreateGroupScreen.createGroupScreen:
        return MaterialPageRoute(
          builder: (context) => CreateGroupScreen(),
        );
        case CreateGroupDetailScreen.createGroupDetailScreen:
        var args = settings.arguments as List<UserDetails>;
        return MaterialPageRoute(
          builder: (context) => CreateGroupDetailScreen(
            groupParticipants: args,
          ),
          settings: settings
        );
      case EditMessageScreen.editMessageScreen:
        var args = settings.arguments as List<dynamic>;
        return MaterialPageRoute(
            builder: (context) => EditMessageScreen(
                  newMessage: args[0],
                  chatId: args[1],
                  messageId: args[2],
                  message: args[3],
                  timeStampMessage: args[4],
                ),
            settings: settings);

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
