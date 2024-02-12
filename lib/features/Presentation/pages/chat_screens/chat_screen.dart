import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:chat_app/common/constants/color_constants.dart';
import 'package:chat_app/features/data/model/chat_model.dart';
import 'package:chat_app/features/data/model/message_model.dart';
import 'package:chat_app/features/dependencyInjector/injector.dart';
import 'package:chat_app/features/domain/usecase/chat_features_usercase.dart';

class ChatScreen extends StatefulWidget {
  final String firstUserUid;
  final Map<String, dynamic> userMap;
  static const chatScreen = 'chatScreen';
  ChatScreen({Key? key, required this.firstUserUid, required this.userMap})
      : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatFeaturesUseCase chatFeaturesUseCase = sl<ChatFeaturesUseCase>();
  final TextEditingController _messageController = TextEditingController();
  final List<Message> messages = [];
  late String chatId;

  @override
  void initState() {
    chatId = chatFeaturesUseCase.chatRoomId(
        widget.firstUserUid, widget.userMap['userId']);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SelectionArea(
      child: Scaffold(
        backgroundColor: ColorAssets.neomCream,
        appBar: AppBar(
          scrolledUnderElevation: 0,
          elevation: 0,
          backgroundColor: ColorAssets.neomCream,
          automaticallyImplyLeading: true,
          centerTitle: false,
          title: Padding(
            padding: EdgeInsets.only(right: double.infinity /4),
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.only(right: 5),
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(widget.userMap['imagepath']),
                          fit: BoxFit.cover),
                      shape: BoxShape.circle),
                ),
                Text(
                  widget.userMap['firstName'],
                  style: GoogleFonts.roboto(
                      color: ColorAssets.neomBlack,
                      fontSize: 20,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder<List<Message>>(
                stream: chatFeaturesUseCase.getMessages(chatId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    messages.clear();
                    messages.addAll(snapshot.data!);
                    return ListView.builder(
                      reverse: true,
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        return Align(
                          alignment: messages[index].sender == widget.firstUserUid
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 16.0),
                            margin:
                                EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  bottomLeft: Radius.circular(15),
                                  topRight: Radius.circular(15)),
                              color: messages[index].sender == widget.firstUserUid
                                  ? ColorAssets.neomBlue
                                  : Colors.grey[300],
                            ),
                            child: Text(
                              messages[index].content!,
                              style: GoogleFonts.roboto(
                                  color: messages[index].sender ==
                                          widget.firstUserUid
                                      ? Colors.white
                                      : Colors.black,
                                  fontSize: 20),
                            ),
                          ),
                        );
                      },
                    );
                  }
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
      ),
    );
  }

  void sendMessage(String message) {
    setState(() {
      final chat = Chat(
        chatId: chatId,
        createdAt: DateTime.now(),
        groupImage: widget.userMap['imagepath'],
        groupName: widget.userMap['userName'],
        lastMessage: {
          'content': message,
          'sender': widget.firstUserUid,
          'timeStamp': Timestamp.now().toString(),
        },
        type: ChatType.private,
        users: [widget.firstUserUid, widget.userMap['userId']],
      );
      final messageObj = Message(
        content: message,
        timeStamp: DateTime.now(),
        sender: widget.firstUserUid,
      );

      chatFeaturesUseCase.sendMessage(chatId, chat, messageObj);
      _messageController.clear();
    });
  }
}
