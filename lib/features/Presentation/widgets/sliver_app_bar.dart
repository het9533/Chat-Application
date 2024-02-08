import 'package:chat_app/common/constants/color_constants.dart';
import 'package:chat_app/features/Presentation/pages/user_profile/profile_page.dart';
import 'package:chat_app/features/data/entity/user.dart';
import 'package:chat_app/features/data/entity/user_session.dart';
import 'package:chat_app/features/dependencyInjector/injector.dart';
import 'package:chat_app/features/domain/usecase/authentication_usecase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';

class MySliverAppBar extends StatefulWidget {
  MySliverAppBar({
    super.key,
    required UserSession userSession,
  }) : _userSession = userSession;

  final UserSession _userSession;

  @override
  State<MySliverAppBar> createState() => _MySliverAppBarState();
}

class _MySliverAppBarState extends State<MySliverAppBar>
    with SingleTickerProviderStateMixin {
  AuthenticationUseCase authenticationUseCase = sl<AuthenticationUseCase>();
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  bool isPopUpMenuOn = false;

  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    animation = Tween<double>(begin: 0.0, end: 1.0).animate(controller);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
        backgroundColor: ColorAssets.neomCream,
        automaticallyImplyLeading: false,
        leading: widget._userSession.userDetails?.imagepath != null
            ? GestureDetector(
                onTap: () => Navigator.pushNamed(
                  context,
                  ProfilePage.profilepage,
                  arguments: UserDetails(
                    email: widget._userSession.userDetails?.email ?? "",
                    firstName: widget._userSession.userDetails?.firstName ?? "",
                    imagepath: widget._userSession.userDetails?.imagepath ?? "",
                    lastName: widget._userSession.userDetails?.lastName ?? "",
                    number: widget._userSession.userDetails?.number ?? "",
                  ),
                ),
                child: Container(
                  margin: EdgeInsets.only(left: 20),
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(
                              widget._userSession.userDetails!.imagepath ?? ""),
                          fit: BoxFit.cover),
                      shape: BoxShape.circle),
                ),
              )
            : Container(
                margin: EdgeInsets.only(left: 20),
                decoration:
                    BoxDecoration(color: Colors.grey, shape: BoxShape.circle),
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
          //   Container(
          //       margin: EdgeInsets.only(right: 20),
          //       child: SvgPicture.asset("assets/icons/add_square.svg")),
          // ],

          PopupMenuButton<int>(
              surfaceTintColor: Colors.white,
              // color: Colors.white,
              icon: AnimatedIcon(
                  icon: AnimatedIcons.menu_close, progress: animation),
              offset: Offset(0, 10),
              // elevation: 0.0,
              position: PopupMenuPosition.under,
              onOpened: () {
                setState(() {
                  isPopUpMenuOn = true;
                  controller.forward();
                });
              },
              onCanceled: () {
                setState(() {
                  isPopUpMenuOn = false;
                  controller.reverse();
                });
              },
              onSelected: (item) async {
                if (item == 0) {
                  _googleSignIn.signOut();
                  FirebaseFirestore.instance.clearPersistence();
                  FirebaseAuth.instance.signOut();
                } else {}
              },
              itemBuilder: (context) => [
                    PopupMenuItem<int>(value: 0, child: Text('Logout')),
                    PopupMenuItem<int>(value: 1, child: Text('Settings')),
                  ])
        ]);
  }
}
