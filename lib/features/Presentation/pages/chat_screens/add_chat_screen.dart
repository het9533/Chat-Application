import 'package:chat_app/features/Presentation/widgets/custom_row_icon_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chat_app/common/constants/color_constants.dart';
import 'package:chat_app/features/Presentation/pages/chat_screens/chat_screen.dart';
import 'package:chat_app/features/Presentation/widgets/my_chat_card.dart';
import 'package:chat_app/features/data/entity/user_session.dart';
import 'package:chat_app/features/dependencyInjector/injector.dart';
import 'package:chat_app/features/domain/usecase/firebase_firestore_usecase.dart';

class AddChatScreen extends StatefulWidget {
  static const addChatScreen = 'AddChatScreen';
  const AddChatScreen({Key? key}) : super(key: key);

  @override
  State<AddChatScreen> createState() => _AddChatScreenState();
}

class _AddChatScreenState extends State<AddChatScreen> {
  final _userSession = sl<UserSession>();
  final FirebaseFirestoreUseCase firebaseFirestoreUseCase =
      sl<FirebaseFirestoreUseCase>();
  final user = FirebaseAuth.instance.currentUser;
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorAssets.neomCream,
        title: Text(
          "New Conversation",
          style: GoogleFonts.roboto(
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: SearchBar(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12))),
                    controller: searchController,
                    onChanged: (value) {
                      setState(() {});
                    },
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                    elevation: MaterialStateProperty.all(0.0),
                    padding: MaterialStateProperty.all(
                        EdgeInsets.symmetric(horizontal: 10)),
                    leading: Icon(Icons.search),
                    hintText: "Search",
                    hintStyle: MaterialStateProperty.all(GoogleFonts.roboto(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ))),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    AppTextIconButton(
                      icon: Icons.group,
                      text: "New group",
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    AppTextIconButton(
                      icon: Icons.person_add,
                      text: "New Contact",
                    ),
                  ],
                ),
              )
            ],
          ),
          if (searchController.text.isEmpty)
            SizedBox()
          else
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection('users').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text("Error"),
                    );
                  }
              
                  final filteredUsers = snapshot.data!.docs.where((document) {
                    final userName =
                        document['userName'].toString().toLowerCase();
                    final searchKey = searchController.text.toLowerCase();
                    return userName.contains(searchKey);
                  }).toList();
              
                  return ListView.builder(
                    itemCount: filteredUsers.length,
                    itemBuilder: (context, index) {
                      final document = filteredUsers[index];
                      return UserChatCard(
                        ontap: () {
                          Navigator.pushNamed(
                            context,
                            ChatScreen.chatScreen,
                            arguments: [
                              _userSession.userDetails!.userId.toString(),
                              document['firstName'].toString(),
                              document['imagepath'].toString(),
                            ],
                          );
                        },
                        image: document['imagepath'] ?? "",
                        username: document['userName'] ?? "",
                      );
                    },
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
