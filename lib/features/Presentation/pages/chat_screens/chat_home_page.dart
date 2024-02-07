import 'package:chat_app/common/constants/color_constants.dart';
import 'package:chat_app/features/data/entity/user.dart';
import 'package:chat_app/features/data/entity/user_session.dart';
import 'package:chat_app/features/dependencyInjector/injector.dart';
import 'package:chat_app/features/domain/usecase/firebase_firestore_usecase.dart';
import 'package:floating_navigation_bar/floating_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatHomePage extends StatefulWidget {
  static const chatHomePage = 'ChatHomePage';
  const ChatHomePage({super.key});

  @override
  State<ChatHomePage> createState() => _ChatHomePageState();
}

class _ChatHomePageState extends State<ChatHomePage> {
  final _userSession = sl<UserSession>();
  final FirebaseFirestoreUseCase firebaseFirestoreUseCase =
      sl<FirebaseFirestoreUseCase>();
  final user = FirebaseAuth.instance.currentUser;
  int currentIndex = 0;

  @override
  void initState() {
    getdata();
    super.initState();
  }

  void getdata() async {
    _userSession.userDetails =
        await firebaseFirestoreUseCase.getCurrentUserDetails(user!.uid);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: ColorAssets.neomCream,
            automaticallyImplyLeading: false,
            leading: _userSession.userDetails?.imagepath != null
                ? Container(
                    margin: EdgeInsets.only(left: 20),
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(
                                _userSession.userDetails!.imagepath ?? ""),
                            fit: BoxFit.cover),
                        shape: BoxShape.circle),
                  )
                : Container(
                    margin: EdgeInsets.only(left: 20),
                    decoration: BoxDecoration(
                        color: Colors.grey, shape: BoxShape.circle),
                  ),
            title: Text(
              "Chat",
              style: GoogleFonts.roboto(
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
            centerTitle: true,
            actions: [
              Container(
                  margin: EdgeInsets.only(right: 20),
                  child: SvgPicture.asset("assets/icons/add_square.svg")),
            ],
          ),
          SliverList(
              delegate:
                  SliverChildBuilderDelegate(childCount: 5, (context, index) {
            return UserChatCard(
                image: _userSession.userDetails?.imagepath ?? "");
          }))
        ],
      ),
      bottomNavigationBar: FloatingNavigationBar(  
        backgroundColor: Colors.white,
        barHeight: 60.0,
        barWidth: double.infinity,
        iconColor: Colors.black,
        textStyle: TextStyle(
          color: Colors.black,
          fontSize: 14.0,
        ),
        iconSize: 20.0,
        indicatorColor: Colors.black,
        indicatorHeight: 5,
        indicatorWidth: 10.0,
        items: [
          NavBarItems(
            icon: Icons.home,
            title: "Home",
          ),
          NavBarItems(
            icon: Icons.chat,
            title: "chat",
          ),
          NavBarItems(
            icon: Icons.search,
            title: "Search",
          ),
          NavBarItems(
      
            icon: Icons.scanner,
            title: "Scan",
          ),
        ],
        onChanged: (value) {
          currentIndex = value;
          setState(() {});
        },
      ),
    );
  }
}

class UserChatCard extends StatelessWidget {
  final String image;

  const UserChatCard({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      padding: EdgeInsets.all(10),
      width: double.infinity,
      height: 70,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12), color: Colors.white),
      child: Row(
        children: [
          Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(image: NetworkImage(image)))),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Anastesya Kohesi',
                  style: TextStyle(
                    color: Color(0xFF13100D),
                    fontSize: 14,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w700,
                    height: 0,
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  'Yes it’s perfect for me, that...',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w300,
                    height: 0,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 40,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Text(
                  '4:30 pm',
                  style: TextStyle(
                    color: Color(0xFF13100D),
                    fontSize: 14,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w700,
                    height: 0,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: CircleAvatar(
                  radius: 12,
                  child: Text(
                    '3',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w300,
                      height: 0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
