import 'package:chat_app/common/constants/color_constants.dart';
import 'package:flutter/material.dart';

class UserChatCard extends StatelessWidget {
  final String image;

  final String username;

  final VoidCallback ontap;

  final String lastMessage;

  final String unseenCount;
  final String lastMessageTime;
  final bool colorCondition;
  final bool showIconCase;

  UserChatCard(
      {super.key,
      required this.image,
      required this.username,
      required this.ontap,
      required this.lastMessage,
      required this.unseenCount,
      required this.lastMessageTime,
      this.showIconCase = false,
      this.colorCondition = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        padding: EdgeInsets.all(10),
        width: double.infinity,
        height: 70,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12), color: Colors.white),
        child: Row(
          children: [
            Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: NetworkImage(image), fit: BoxFit.cover))),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    username,
                    style: TextStyle(
                      color: colorCondition ? Colors.pink : Color(0xFF13100D),
                      fontSize: 14,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w700,
                      height: 0,
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  if (lastMessage != '')
                    Row(
                      children: [
                       showIconCase ?  Icon(
                          Icons.done_all,
                          size: 15,
                          color: colorCondition ? Colors.red : Colors.black,
                        ) : Container(),
                        SizedBox(width: 5),
                        Text(
                          lastMessage,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w500,
                            height: 0,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            SizedBox(
              width: 40,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Text(
                    lastMessageTime,
                    style: TextStyle(
                      color: Color(0xFF13100D),
                      fontSize: 14,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.normal,
                      height: 0,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                if (unseenCount != '')
                  Align(
                    alignment: Alignment.bottomRight,
                    child: CircleAvatar(
                      backgroundColor: ColorAssets.neomBlue,
                      radius: 12,
                      child: Text(
                        unseenCount,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.bold,
                          height: 0,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
