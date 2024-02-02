import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neom_demo/features/data/model/user_profile.dart';
import 'package:neom_demo/features/presentation/chat_screen/chatting_screen_bloc/chatting_bloc.dart';
import 'package:neom_demo/features/presentation/chat_screen/pages/chatting_screen.dart';
import 'package:neom_demo/features/presentation/chat_screen/pages/new_conversation.dart';
import 'package:neom_demo/features/presentation/chat_screen/pages/pagination_data.dart';
import 'package:neom_demo/features/presentation/login/pages/login_screen.dart';
import 'package:neom_demo/features/presentation/otp/pages/otp_screen.dart';
import 'package:neom_demo/features/presentation/select_language/pages/select_language_screen.dart';
import 'package:neom_demo/features/presentation/splash/pages/splash_screen.dart';
import 'package:neom_demo/features/presentation/user_profile/pages/user_profile_screen.dart';

import '../../di/injector.dart';
import '../../features/presentation/chat_screen/pages/chat.dart';
import '../../features/presentation/chat_screen/pages/random_user_data.dart';
import '../../features/presentation/chat_screen/pages/sliver_scroll_with_cupertino_refresh_indicator.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class AppNavigator {
  static GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  static Route<dynamic> materialAppsRoute(RouteSettings settings) {
    switch (settings.name) {
      case SliverScrollWithCupertinoRefreshIndicator.sliverScrollWithCupertinoRefreshIndicator:
        return MaterialPageRoute(builder: (context) => const SliverScrollWithCupertinoRefreshIndicator());
      case PaginationWithData.paginationWithDio:
        return MaterialPageRoute(builder: (context) => const PaginationWithData());
      case RandomData.randomData:
        return MaterialPageRoute(
          builder: (context) => const RandomData(),
        );
      case SplashScreen.splash:
        return MaterialPageRoute(
          builder: (context) => const SplashScreen(),
        );
      case SelectLanguage.selectLanguage:
        return MaterialPageRoute(
          builder: (context) => const SelectLanguage(),
        );
      case LoginScreen.loginScreen:
        return MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        );
      case OtpScreen.otpScreen:
        var args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (context) => OtpScreen(email: args?['email'] ?? "", phone: args?['phone'] ?? ""),
        );
      case UserProfileScreen.userProfileScreen:
        var args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
            builder: (context) => UserProfileScreen(
                  email: args?['email'] ?? "",
                  mobileNumber: args?['phone'] ?? "",
                ));
      case ChatScreen.chatScreen:
        var args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (context) => ChatScreen(userProfileDetail: args?['userProfileDetail'] ?? UserProfile()),
        );
      case SearchPage.searchPage:
        return MaterialPageRoute(
          builder: (context) => const SearchPage(),
        );
      case ChattingScreen.chattingScreen:
        var args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => ChattingBloc(chattingUseCase: sl(), getUpdateChatUseCase: sl()),
            child: ChattingScreen(userProfile: args?['userProfile'] ?? UserProfile()),
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (context) => UndefinedView(name: settings.name ?? 'undefined name'),
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

