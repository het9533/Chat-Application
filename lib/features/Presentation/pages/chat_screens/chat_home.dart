import 'package:chat_app/common/constants/color_constants.dart';
import 'package:chat_app/features/Presentation/Bloc/profile_page_bloc/profile_page_bloc.dart';
import 'package:chat_app/features/Presentation/Bloc/profile_page_bloc/profile_page_states.dart';
import 'package:chat_app/features/Presentation/pages/chat_screens/chat_screen.dart';
import 'package:chat_app/features/Presentation/pages/user_profile/profile_page.dart';
import 'package:chat_app/features/Presentation/widgets/my_chat_card.dart';
import 'package:chat_app/features/data/entity/user.dart';
import 'package:chat_app/features/data/entity/user_session.dart';
import 'package:chat_app/features/dependencyInjector/injector.dart';
import 'package:chat_app/features/domain/usecase/authentication_usecase.dart';
import 'package:chat_app/features/domain/usecase/firebase_firestore_usecase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ChatHomePage extends StatefulWidget {
  static const chatHomePage = 'ChatHomePage';
  ChatHomePage({super.key});

  @override
  State<ChatHomePage> createState() => _ChatHomePageState();
}

class _ChatHomePageState extends State<ChatHomePage>
    with TickerProviderStateMixin {
  final FirebaseFirestoreUseCase firebaseFirestoreUseCase =
      sl<FirebaseFirestoreUseCase>();
  final user = FirebaseAuth.instance.currentUser;
  int currentIndex = 0;
  AuthenticationUseCase authenticationUseCase = sl<AuthenticationUseCase>();
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  bool isPopUpMenuOn = false;

  late AnimationController controller;
  late Animation<double> animation;
  final _userSession = sl<UserSession>();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    animation = Tween<double>(begin: 0.0, end: 1.0).animate(controller);
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
    return BlocBuilder<ProfilePageBloc, ProfilePageState>(
        buildWhen: (previous, current) {
          if (current is ChangesSavedState) {
            return true;
          } else {
            return false;
          }
        },
        builder: (context, state) {
          return Scaffold(
          appBar: AppBar(
              backgroundColor: ColorAssets.neomCream,
              automaticallyImplyLeading: false,
              leading: _userSession.userDetails?.imagepath != null
                  ? GestureDetector(
                      onTap: () => Navigator.pushNamed(
                        context,
                        ProfilePage.profilepage,
                        arguments: UserDetails(
                          userName: _userSession.userDetails?.userName ?? "",
                          userId: _userSession.userDetails?.userId ?? "",
                          email: _userSession.userDetails?.email ?? "",
                          firstName: _userSession.userDetails?.firstName ?? "",
                          imagepath: _userSession.userDetails?.imagepath ?? "",
                          lastName: _userSession.userDetails?.lastName ?? "",
                          number: _userSession.userDetails?.number ?? "",
                        ),
                      ),
                      child: Container(
                        margin: EdgeInsets.only(left: 20),
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(
                                    _userSession.userDetails!.imagepath ?? ""),
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
              ]),
          body:  StreamBuilder(
                  stream:
                      FirebaseFirestore.instance.collection('users').snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.hasError) {
                      return Center(
                        child: Text("error"),
                      );
                    }
                    return ListView.builder(
                        itemCount: snapshot.data?.docs.length,
                        itemBuilder: (BuildContext context, int index) {
                          DocumentSnapshot document = snapshot.data!.docs[index];
    
                          return UserChatCard(
                            ontap: () {
                              Navigator.pushNamed(context, ChatScreen.chatScreen,
                            arguments: [
                              _userSession.userDetails!.userId.toString(),
                              document['firstName'].toString(),
                              document['imagepath'].toString(),
                            ]
                              
                              );
                            },
                            image: document['imagepath'] ?? "",
                            username: document['userName'] ?? "",
                          );
                        });
                  }),
          );
      },
    );
  }
}
