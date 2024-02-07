import 'package:chat_app/common/constants/color_constants.dart';
import 'package:chat_app/features/Presentation/pages/chat_screens/add_chat_screen.dart';
import 'package:chat_app/features/Presentation/pages/chat_screens/chat_home.dart';
import 'package:chat_app/features/Presentation/pages/chat_screens/favourite.dart';
import 'package:chat_app/features/Presentation/pages/chat_screens/settings.dart';
import 'package:chat_app/features/data/entity/user_session.dart';
import 'package:chat_app/features/dependencyInjector/injector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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
      AddChatScreen(),
      FavouritePage(),
      SettingPage(),
    ];
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              decoration: BoxDecoration(),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: BottomNavigationBar(
                  type: BottomNavigationBarType.shifting,
                    // backgroundColor: Colors.transparent,
                    selectedItemColor: ColorAssets.neomGold,
                    unselectedItemColor: Colors.black,
                    currentIndex: myCurrentIndex,
                    onTap: (index) {
                      setState(() {
                        myCurrentIndex = index;
                      });
                    },
                    items:  [
                      BottomNavigationBarItem(
                          icon: Icon(Icons.home), label: "Home"),
                          BottomNavigationBarItem(
                          icon: SvgPicture.asset("assets/icons/add_square.svg"), label: "Add Chat"),
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
