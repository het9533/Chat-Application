
import 'package:chat_app/features/Presentation/widgets/my_chat_card.dart';
import 'package:chat_app/features/Presentation/widgets/sliver_app_bar.dart';
import 'package:chat_app/features/data/entity/user_session.dart';
import 'package:chat_app/features/dependencyInjector/injector.dart';
import 'package:chat_app/features/domain/usecase/firebase_firestore_usecase.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

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
      body:   CustomScrollView(
        slivers: <Widget>[
          MySliverAppBar(userSession: _userSession),
          SliverList(
              delegate:
                  SliverChildBuilderDelegate(childCount: 7, (context, index) {
            return UserChatCard(
                image: _userSession.userDetails?.imagepath ?? "", username: _userSession.userDetails?.firstName ?? "",);
          }))
        ],
      ),
    );
  }
}