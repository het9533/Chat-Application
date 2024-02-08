import 'package:chat_app/common/constants/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatScreen extends StatefulWidget {
  final String firstUserUid;
  final String secondUserUid;
  final String endUserImage;
  static const chatScreen = 'chatScreen';
  const ChatScreen(
      {Key? key, required this.firstUserUid, required this.secondUserUid, required this.endUserImage})
      : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<String> messages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorAssets.neomCream,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        elevation: 0,
        backgroundColor: ColorAssets.neomCream,
        automaticallyImplyLeading: true,
        centerTitle: false,
        title: Row(
          
          children: [
            Container(
              
                        margin: EdgeInsets.only(right: 10),
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(
                                    '${widget.endUserImage}'),
                                fit: BoxFit.cover),
                            shape: BoxShape.circle),
                      ),
            Text(widget.secondUserUid, style: GoogleFonts.roboto(
              color: ColorAssets.neomBlack,
              fontSize: 20,
              fontWeight: FontWeight.w500
            ),),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    margin: EdgeInsets.symmetric(
                      vertical: 5,horizontal: 10
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          bottomLeft: Radius.circular(15),
                          topRight: Radius.circular(15)),
                      color: ColorAssets.neomBlue,
                    ),
                    child: Text(messages[index], style: GoogleFonts.roboto(
                      color: Colors.white,
                      fontSize: 20
                    ),),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Flexible(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: 30.0,
                      maxHeight: 250.0,
                    ),
                    child: Scrollbar(
                      child: TextField(
                        cursorColor: Colors.blue,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        controller: _messageController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(
                            top: 5.0,
                            left: 15.0,
                            right: 15.0,
                            bottom: 5.0,
                          ),
                          hintText: "Type your message",
                          hintStyle: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    sendMessage(_messageController.text);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void sendMessage(String message) {
    setState(() {
      messages.add(message);
      _messageController.clear();
    });
  }
}
