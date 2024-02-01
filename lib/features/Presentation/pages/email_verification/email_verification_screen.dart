import 'dart:async';

import 'package:chat_app/common/constants/color_constants.dart';
import 'package:chat_app/features/Presentation/pages/email_verification/account_success_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:page_transition/page_transition.dart';

class VerifyEmailScreen extends StatefulWidget {
  
  const VerifyEmailScreen({super.key});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen>
    with TickerProviderStateMixin,WidgetsBindingObserver {
  late AnimationController controller;
  late bool isClicked = false;
  bool isEmailVerified = false;
  late Timer timer;

void didChangeAppLifecycleState(AppLifecycleState state) async {

  if (state == AppLifecycleState.inactive ) {
    
    
       print('app inactive MINIMIZED!');
    
    // print('app inactive in lock screen!');
  } else if (state == AppLifecycleState.resumed) {
    print('app resumed');
  }
}
  @override
  void initState() {
    isClicked = false;
    WidgetsBinding.instance.addObserver(this);
    controller = AnimationController(
        duration: Duration(milliseconds: 1500), vsync: this);
    controller.forward();
    controller.repeat(reverse: true);
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    if (!isEmailVerified) {
      sendVerificationEmail();
      timer = Timer.periodic(Duration(seconds: 3), (_) => checkEmailVerified());
    }
    super.initState();
  }
 
  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser?.reload();

    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });
    if (isEmailVerified) timer.cancel();
  }

  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  void dispose() {
    controller.dispose();
    timer.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;

    return isEmailVerified
        ? AccountCreatedSuccessScreen()
        : Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              actions: [IconButton(onPressed: () {}, icon: Icon(Icons.close))],
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AnimatedBuilder(
                    animation: controller,
                    child: SvgPicture.asset("assets/illustrations/email.svg",
                        height: 300),
                    builder: (BuildContext context, Widget? child) {
                      return Transform.translate(
                        offset: Offset(0, -10 * controller.value),
                        child: child,
                      );
                    },
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text(
                    "Verify your email address!",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: ColorAssets.neomBlack2),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text(
                    user.email.toString(),
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 18,
                        color: ColorAssets.neomBlack2),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  SizedBox(
                    child: Text(
                      "To enhance the security of your account, please verify your email before chatting. Check your inbox for a verification email and follow the instructions to ensure a safe and enjoyable chatting experience. Thank you for your cooperation!",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 12,
                          color: ColorAssets.neomBlack),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  InkWell(
                    onTap: () async {
                      setState(() {
                        isClicked = true;
                      });
                      await Future.delayed(Duration(seconds: 1));
                      await Navigator.push(
                          context,
                          PageTransition(
                              duration: Duration(milliseconds: 900),
                              child: AccountCreatedSuccessScreen(),
                              curve: Curves.fastOutSlowIn,
                              alignment: Alignment.center,
                              type: PageTransitionType.scale));

                      setState(() {
                        isClicked = false;
                      });
                    },
                    child: AnimatedContainer(
                      alignment: Alignment.center,
                      duration: Duration(seconds: 1),
                      decoration: BoxDecoration(
                          color: ColorAssets.neomGold,
                          borderRadius:
                              BorderRadius.circular(isClicked ? 50 : 10)),
                      height: 50,
                      width: isClicked ? 50 : MediaQuery.of(context).size.width,
                      child: isClicked
                          ? Align(child: Icon(Icons.check))
                          : Text(
                              "Continue",
                              style: TextStyle(
                                  color: ColorAssets.neomBlack2, fontSize: 15),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
