import 'dart:async';
import 'dart:ui';

import 'package:chat_app/common/constants/color_constants.dart';
import 'package:chat_app/common/constants/routes.dart';
import 'package:chat_app/features/dependencyInjector/injector.dart';
import 'package:chat_app/features/domain/usecase/firebase_firestore_usecase.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  late AnimationController controller;
  late AnimationController chatIconController;
  final FirebaseFirestoreUseCase firebaseFirestoreUseCase = sl<FirebaseFirestoreUseCase>();

  @override
  void initState() {
    controller = AnimationController(
        duration: Duration(milliseconds: 700), vsync: this);
    chatIconController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );

    Timer(Duration(milliseconds: 300), () => controller.forward());

    // Start chat icon animation after other animations complete
    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        chatIconController.forward();
        chatIconController.repeat(reverse: true);
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    chatIconController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height / 1.7,
            child: Stack(
              children: [
                Positioned(
                  top: 300,
                  child: AnimatedBuilder(
                    animation: chatIconController,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, -10 * chatIconController.value),
                        child: child,
                      );
                    },
                    child: SlideTransition(
                      position:
                          Tween<Offset>(begin: Offset(-1, 0), end: Offset(0, 0))
                              .animate(controller),
                      child: FadeTransition(
                        opacity: controller,
                        child: Container(
                          transform: Matrix4.rotationZ(-50),
                          transformAlignment: Alignment.center,
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image:
                                    AssetImage("assets/images/man_avatar.png")),
                            color: Color(0xffe1ddbd),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 250,
                  left: 200,
                  child: AnimatedBuilder(
                    animation: chatIconController,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, -10 * chatIconController.value),
                        child: child,
                      );
                    },
                    child: SlideTransition(
                      position:
                          Tween<Offset>(begin: Offset(0, 1), end: Offset(0, 0))
                              .animate(controller),
                      child: FadeTransition(
                        opacity: controller,
                        child: Container(
                          transform: Matrix4.rotationZ(50),
                          transformAlignment: Alignment.center,
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(
                                    "assets/images/man_vr_avatar.png")),
                            color: Color(0xffe0f1ef),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 80,
                  left: 150,
                  child: AnimatedBuilder(
                    animation: chatIconController,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, 10 * chatIconController.value),
                        child: child,
                      );
                    },
                    child: SlideTransition(
                      position:
                          Tween<Offset>(begin: Offset(0, -1), end: Offset(0, 0))
                              .animate(controller),
                      child: FadeTransition(
                        opacity: controller,
                        child: Container(
                          transform: Matrix4.rotationY(0),
                          transformAlignment: Alignment.center,
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image:
                                    AssetImage("assets/images/women_avatar.png")),
                            color: Color(0xffFADDDD),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 160,
                  left: 20,
                  child: AnimatedBuilder(
                    animation: chatIconController,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, 10 * chatIconController.value),
                        child: child,
                      );
                    },
                    child: SlideTransition(
                      position: Tween<Offset>(begin: Offset(-1, 0), end: Offset(0, 0))
                            .animate(controller),
                      child: FadeTransition(
                        opacity: controller,
                        child: Container(
                          transform: Matrix4.rotationZ(6),
                          transformAlignment: Alignment.center,
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage("assets/images/chat_icon.png")),
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
        ])
            
            ),
  
          FadeTransition(
            opacity: controller,
              child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 40),
              child: SizedBox(
                width: 170,
                child: Text(
                  "Let's Get Started",
                  style: TextStyle(
                      color: ColorAssets.neomBlack2,
                      fontSize: 40,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          FadeTransition(
            opacity: controller,
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 50, top: 10),
              child: Text(
                "Connect with each other with chatting or calling.Enjoy Safe and Private texting",
                textAlign: TextAlign.justify,
                style: TextStyle(
                    color: ColorAssets.neomBlack2,
                    fontSize: 16,
                    fontWeight: FontWeight.w300),
              ),
            ),
          ),
          SizedBox(
            height: 40,
          ),
          SlideTransition(
                  position: Tween<Offset>(begin: Offset(-1, 0), end: Offset(0, 0))
                            .animate(controller),
                  child: FadeTransition(
                    opacity: controller,
                    
            child: Container(
              height: 50,
              margin: EdgeInsets.only(right: 20, left: 20),
              width: double.infinity,
              child: FilledButton(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                      backgroundColor:
                          MaterialStateProperty.all(ColorAssets.neomWhite)),
                  onPressed: () {
                    Navigator.pushNamed(context, SignUpPageRoute);
                  },
                  child: Text(
                        "Join Now",
                        style: TextStyle(color: ColorAssets.neomBlack2, fontSize: 15),
                      ),
                    ),
                  ),
          )),
          
          SizedBox(
            height: 10,
          ),
          SlideTransition(
            position: Tween<Offset>(begin: Offset(0, 1), end: Offset(0, 0))
                            .animate(controller),
            child: FadeTransition(
              opacity: controller,
              child: Align(
                alignment: Alignment.center,
                child: TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, LoginPageRoute);
                    },
                    child: Text(
                      "Already have an account? Login",
                      style: TextStyle(
                        color: ColorAssets.neomBlack2,
                      ),
                      textAlign: TextAlign.center,
                    )),
              ),
            ),
          )
        ],
      ),
    );

  }
}
