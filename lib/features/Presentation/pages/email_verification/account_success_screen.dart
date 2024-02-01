import 'package:chat_app/common/constants/color_constants.dart';
import 'package:flutter/material.dart';

class AccountCreatedSuccessScreen extends StatefulWidget {
  const AccountCreatedSuccessScreen({super.key});

  @override
  State<AccountCreatedSuccessScreen> createState() => _AccountCreatedSuccessScreenState();
}

class _AccountCreatedSuccessScreenState extends State<AccountCreatedSuccessScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(
        duration: Duration(milliseconds: 1500), vsync: this);
    controller.forward();
    controller.repeat(reverse: true);
    super.initState();
  }
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        actions: [IconButton(onPressed: () {
          Navigator.pop(context);
        }, icon: Icon(Icons.close))],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: controller,
              child: Image.asset("assets/illustrations/account_created.png",
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
              "Your Account Successfully Created!",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: ColorAssets.neomBlack2),
            ),
            SizedBox(
              height: 16,
            ),
            SizedBox(
              child: Text(
                "Congratulations! Your account has been successfully created. Get ready to enjoy a seamless and secure chatting experience. Start connecting and engaging with others on our platform. Happy chatting!",
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
            Container(
              height: 50,
              width: double.infinity,
              child: FilledButton(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                      backgroundColor:
                          MaterialStateProperty.all(ColorAssets.neomGold)),
                  onPressed: () async {},
                  child: Text(
                    "Continue",
                    style:
                        TextStyle(color: ColorAssets.neomBlack2, fontSize: 15),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
