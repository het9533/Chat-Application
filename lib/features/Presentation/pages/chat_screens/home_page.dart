import 'package:chat_app/features/Presentation/pages/chat_screens/chat_home.dart';
import 'package:chat_app/features/Presentation/pages/chat_screens/favourite.dart';
import 'package:chat_app/features/Presentation/pages/chat_screens/settings.dart';
import 'package:chat_app/features/Presentation/pages/user_profile/profile_page.dart';
import 'package:chat_app/features/data/entity/user.dart';
import 'package:chat_app/features/data/entity/user_session.dart';
import 'package:chat_app/features/dependencyInjector/injector.dart';
import 'package:flutter/material.dart';

class ChatMainScreen extends StatefulWidget {
  static const chatMainScreen = 'chatMainScreen';

  const ChatMainScreen({super.key});

  @override
  State<ChatMainScreen> createState() => _MyButtomNavBarState();
}

class _MyButtomNavBarState extends State<ChatMainScreen> {
  final _userSession = sl<UserSession>();

  int myCurrentIndex = 0;

  @override
  Widget build(BuildContext context) {
    List pages = [
      ChatHomePage(),
      FavouritePage(),
      SettingPage(),
    ];
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 25,
                    offset: const Offset(8, 20))
              ]),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: BottomNavigationBar(
                    // backgroundColor: Colors.transparent,
                    selectedItemColor: Colors.redAccent,
                    unselectedItemColor: Colors.black,
                    currentIndex: myCurrentIndex,
                    onTap: (index) {
                      setState(() {
                        myCurrentIndex = index;
                      });
                    },
                    items: const [
                      BottomNavigationBarItem(
                          icon: Icon(Icons.home), label: "Home"),
                      BottomNavigationBarItem(
                          icon: Icon(Icons.favorite), label: "Favorite"),
                      BottomNavigationBarItem(
                          icon: Icon(Icons.settings), label: "Setting"),
                      
                    ]),
              ),
            ),
        
      body: pages[myCurrentIndex],
    );
  }
}
