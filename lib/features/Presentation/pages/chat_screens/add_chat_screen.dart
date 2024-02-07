import 'package:chat_app/common/constants/color_constants.dart';
import 'package:chat_app/features/Presentation/widgets/my_chat_card.dart';
import 'package:chat_app/features/data/entity/user_session.dart';
import 'package:chat_app/features/dependencyInjector/injector.dart';
import 'package:chat_app/features/domain/usecase/firebase_firestore_usecase.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddChatScreen extends StatefulWidget {
  static const addChatScreen = 'AddChatScreen';
  const AddChatScreen({super.key});

  @override
  State<AddChatScreen> createState() => _AddChatScreenState();
}

class _AddChatScreenState extends State<AddChatScreen> {
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
            pinned: true,
            backgroundColor: ColorAssets.neomCream,
            title: Text(
              "New Conversation",
              style: GoogleFonts.roboto(
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
            centerTitle: true,
            bottom: PreferredSize(
                preferredSize: Size(double.infinity, 50),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: SearchBar(
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                    elevation: MaterialStateProperty.all(0.0),
                    leading: Icon(Icons.search),
                    hintText: "Search",
                    hintStyle: MaterialStateProperty.all(GoogleFonts.roboto(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    )),
                  ),
                )),
          ),
          SliverList(
              delegate:
                  SliverChildBuilderDelegate(childCount: 7, (context, index) {
            return UserChatCard(
              image: _userSession.userDetails?.imagepath ?? "",
              username: _userSession.userDetails?.firstName ?? "",
            );
          }))
        ],
      ),
    );
  }
}
