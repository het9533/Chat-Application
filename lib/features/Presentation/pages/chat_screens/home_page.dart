import 'package:chat_app/common/constants/color_constants.dart';
import 'package:chat_app/features/Presentation/pages/chat_screens/add_chat_screen.dart';
import 'package:chat_app/features/Presentation/pages/chat_screens/add_group_chat_screen.dart';
import 'package:chat_app/features/Presentation/pages/chat_screens/chat_home.dart';
import 'package:chat_app/features/Presentation/pages/chat_screens/favourite.dart';
import 'package:chat_app/features/Presentation/pages/chat_screens/settings.dart';
import 'package:chat_app/features/data/entity/user_session.dart';
import 'package:chat_app/features/dependencyInjector/injector.dart';
import 'package:chat_app/features/domain/usecase/firebase_firestore_usecase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatMainScreen extends StatefulWidget {
  static const chatMainScreen = 'chatMainScreen';

  const ChatMainScreen({super.key});

  @override
  State<ChatMainScreen> createState() => _MyButtomNavBarState();
}

class _MyButtomNavBarState extends State<ChatMainScreen> {
  final FirebaseFirestoreUseCase firebaseFirestoreUseCase =
      sl<FirebaseFirestoreUseCase>();
  final UserSession _userSession = sl<UserSession>();
  int myCurrentIndex = 0;
  @override
  void initState() {
    super.initState();
    getdata();
  }

  void getdata() async {
    final user = FirebaseAuth.instance.currentUser;
    _userSession.userDetails =
        await firebaseFirestoreUseCase.getCurrentUserDetails(user!.uid);
    setState(() {});
  }

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
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
        clipBehavior: Clip.hardEdge,
        child: BottomNavigationBar(
            type: BottomNavigationBarType.shifting,
            // backgroundColor: Colors.transparent,
            selectedLabelStyle:
                GoogleFonts.roboto(fontSize: 13, fontWeight: FontWeight.w900),
            selectedItemColor: ColorAssets.neomBlue,
            unselectedItemColor: Colors.black,
            currentIndex: myCurrentIndex,
            onTap: (index) {
              setState(() {
                myCurrentIndex = index;
              });
            },
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
              BottomNavigationBarItem(icon: Icon(Icons.call), label: "Call"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.data_saver_on), label: "Status"),
            ]),
      ),
      body: pages[myCurrentIndex],
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        elevation: 0.0,
        backgroundColor: ColorAssets.neomBlue,
        onPressed: () {
          showModalBottomSheet(
            backgroundColor: Colors.white,
            elevation: 0.0,
            context: context,
            builder: (context) {
              return Wrap(
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.chat),
                    title: Text('New Chat'),
                    subtitle: Text('Join with your Friend'),
                    onTap: () {
                      Navigator.pushReplacementNamed(context, AddChatScreen.addChatScreen);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.group),
                    title: Text('New group'),
                    subtitle: Text('Join the Friends around you'),
                    onTap: () {
                      Navigator.pushReplacementNamed(context, CreateGroupScreen.createGroupScreen);
                      // Do something for 'New Community' option
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.cancel),
                    title: Text('Cancel'),
                    onTap: () {
                      Navigator.pop(context); // Close the bottom sheet
                    },
                  ),
                ],
              );
            },
          );
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
