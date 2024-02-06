
import 'package:chat_app/common/constants/color_constants.dart';
import 'package:chat_app/features/data/entity/user.dart';
import 'package:chat_app/features/dependencyInjector/injector.dart';
import 'package:chat_app/features/domain/usecase/firebase_firestore_usecase.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatHomePage extends StatefulWidget {
  static const chatHomePage = 'ChatHomePage';
  const ChatHomePage({super.key});

  @override
  State<ChatHomePage> createState() => _ChatHomePageState();
}

class _ChatHomePageState extends State<ChatHomePage> {
  late final UserDetails userDetails;
    final FirebaseFirestoreUseCase firebaseFirestoreUseCase =
        sl<FirebaseFirestoreUseCase>();
    final user = FirebaseAuth.instance.currentUser!;
  @override
  void initState() {
    getdata();
    super.initState();
  }
  void getdata() async{

    userDetails = await firebaseFirestoreUseCase.getCurrentUserDetails(user.uid);
    setState(() {
      
    });
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorAssets.neomCream,
        automaticallyImplyLeading: false,
        leading: Container(
          margin: EdgeInsets.only(left: 20),
          decoration: BoxDecoration(
            image: DecorationImage(image: NetworkImage(userDetails.imagepath!), fit: BoxFit.cover),
            shape: BoxShape.circle
          ),
          
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
          IconButton(onPressed: (){}, icon: Icon(Icons.add_box_rounded))
        ],
      ),
    );
  }
}
