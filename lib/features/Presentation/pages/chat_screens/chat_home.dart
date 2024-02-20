import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chat_app/common/constants/color_constants.dart';
import 'package:chat_app/features/Presentation/Bloc/chat_bloc/chat_bloc.dart';
import 'package:chat_app/features/Presentation/Bloc/chat_bloc/chat_event.dart';
import 'package:chat_app/features/Presentation/Bloc/chat_bloc/chat_state.dart';
import 'package:chat_app/features/Presentation/Bloc/profile_page_bloc/profile_page_bloc.dart';
import 'package:chat_app/features/Presentation/Bloc/profile_page_bloc/profile_page_states.dart';
import 'package:chat_app/features/Presentation/pages/auth_screens/welcome_screen.dart';
import 'package:chat_app/features/Presentation/pages/chat_screens/chat_screen.dart';
import 'package:chat_app/features/Presentation/pages/user_profile/profile_page.dart';
import 'package:chat_app/features/Presentation/widgets/my_chat_card.dart';
import 'package:chat_app/features/data/entity/user.dart';
import 'package:chat_app/features/data/entity/user_session.dart';
import 'package:chat_app/features/dependencyInjector/injector.dart';
import 'package:chat_app/features/domain/usecase/authentication_usecase.dart';
import 'package:chat_app/features/domain/usecase/firebase_firestore_usecase.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatHomePage extends StatefulWidget {
  static const chatHomePage = 'ChatHomePage';
  ChatHomePage({Key? key}) : super(key: key);

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

  final _userSession = sl<UserSession>();
  final TextEditingController searchController = TextEditingController();
  bool _isLoading = false; // Local variable to track loading state

  @override
  void dispose() {
    _chatBloc.chatstreamSubscription?.cancel();
    _chatBloc.countSubscriptions?.forEach((element) => element?.cancel());

    super.dispose();
  }

  late ChatBloc _chatBloc;

  @override
  void initState() {
    super.initState();
    getdata();
    _chatBloc = context.read<ChatBloc>();
    _chatBloc.add(LoadChatEvent());
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
              PopupMenuButton<int>(
                surfaceTintColor: Colors.white,
                icon: Icon(Icons.more_vert),
                offset: Offset(0, 10),
                position: PopupMenuPosition.under,
                onOpened: () {
                  setState(() {
                    isPopUpMenuOn = true;
                  });
                },
                onCanceled: () {
                  setState(() {
                    isPopUpMenuOn = false;
                  });
                },
                onSelected: (item) async {
                  if (item == 0) {
                     _googleSignIn.signOut();

                    // Clear Firestore persistence
                     FirebaseFirestore.instance.clearPersistence();

                    // Sign out from FirebaseAuth
                     FirebaseAuth.instance.signOut();

                    // Navigate to the welcome screen after sign-out
                    Navigator.pushReplacementNamed(
                        context, WelcomeScreen.welcomescreen);
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem<int>(value: 0, child: Text('Logout')),
                  PopupMenuItem<int>(value: 1, child: Text('Settings')),
                ],
              )
            ],
          ),
          body: BlocConsumer<ChatBloc, ChatState>(
            listener: (context, state) {
              if (state is ChatUpdatedState) {}
            },
            buildWhen: (previous, current) {
              return current is ChatUpdatedState ||
                  current is InitialChatState ||
                  current is ChatErrorState ||
                  current is UpdateUnreadCountState ||
                  current is LoadChatEvent;
            },
            builder: (context, state) {
              if (state is InitialChatState) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is ChatErrorState) {
                return Center(
                  child: Text(state.error),
                );
              }
              return Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: SearchBar(
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      )),
                      controller: searchController,
                      onChanged: (value) {
                        setState(() {});
                      },
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                      elevation: MaterialStateProperty.all(0.0),
                      padding: MaterialStateProperty.all(
                        EdgeInsets.symmetric(horizontal: 10),
                      ),
                      leading: Icon(Icons.search),
                      hintText: "Search",
                      hintStyle: MaterialStateProperty.all(
                        GoogleFonts.roboto(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  _userSession.chats!.isEmpty
                      ? Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/noChat.png',
                                height: 300,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                "Tap + for new chat",
                                style: GoogleFonts.roboto(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(
                                height: 100,
                              )
                            ],
                          ),
                        )
                      : Expanded(
                          child: ListView.builder(
                            itemCount: _userSession.chats?.length,
                            itemBuilder: (BuildContext context, int index) {
                              List<String> otherUserId =
                                  _userSession.chats![index].users!;
                              otherUserId.remove(user!.uid);

                              UserDetails anotherUser = _userSession
                                  .chats![index].usersInfo![otherUserId.first]!;

                              return _userSession.chats![index].lastMessage !=
                                      null
                                  ? UserChatCard(
                                      unseenCount: _userSession.unReadCount[
                                                      _userSession.chats![index]
                                                          .chatId] !=
                                                  0 &&
                                              _userSession.chats![index]
                                                      .lastMessage!['sender'] !=
                                                  _userSession
                                                      .userDetails?.userId
                                          ? _userSession.unReadCount[
                                                  _userSession
                                                      .chats![index].chatId]
                                              .toString()
                                          : '',
                                      ontap: () {
                                        Navigator.pushNamed(
                                          context,
                                          ChatScreen.chatScreen,
                                          arguments: [
                                            _userSession.userDetails,
                                            anotherUser
                                          ],
                                        );
                                      },
                                      image: anotherUser.imagepath ?? "",
                                      username: anotherUser.userName ?? "",
                                      lastMessage: _userSession.chats![index]
                                              .lastMessage!['content'] ??
                                          '',
                                    )
                                  : Container();
                            },
                          ),
                        ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Future<void> signOut() async {
    try {
      setState(() {
        // Set a loading state while signing out
        _isLoading = true;
      });

      // Sign out from Google SignIn
      await _googleSignIn.signOut();

      // Clear Firestore persistence
      await FirebaseFirestore.instance.clearPersistence();

      // Sign out from FirebaseAuth
      await FirebaseAuth.instance.signOut();

      // Navigate to the welcome screen after sign-out
      Navigator.pushReplacementNamed(context, WelcomeScreen.welcomescreen);
    } catch (e) {
      print("Error signing out: $e");
    } finally {
      setState(() {
        // Reset loading state after sign-out attempt
        _isLoading = false;
      });
    }
  }
}
