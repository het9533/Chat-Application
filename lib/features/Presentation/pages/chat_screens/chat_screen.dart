import 'package:chat_app/features/Presentation/Bloc/chat_bloc/chat_bloc.dart';
import 'package:chat_app/features/Presentation/Bloc/chat_bloc/chat_event.dart';
import 'package:chat_app/features/Presentation/Bloc/chat_bloc/chat_state.dart';
import 'package:chat_app/features/data/entity/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_keyboard_flutter/emoji_keyboard_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:chat_app/common/constants/color_constants.dart';
import 'package:chat_app/features/data/model/chat_model.dart';
import 'package:chat_app/features/data/model/message_model.dart';
import 'package:chat_app/features/dependencyInjector/injector.dart';
import 'package:chat_app/features/domain/usecase/chat_features_usercase.dart';

class ChatScreen extends StatefulWidget {
  final UserDetails userDetails;
  final UserDetails chatUserDetails;
  static const chatScreen = 'chatScreen';
  ChatScreen(
      {Key? key, required this.userDetails, required this.chatUserDetails})
      : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatFeaturesUseCase chatFeaturesUseCase = sl<ChatFeaturesUseCase>();
  final TextEditingController _messageController = TextEditingController();
  List<QueryDocumentSnapshot<Map<String, dynamic>>> messages = [];
  late String chatId;
  bool isEditMessage = false;
  bool isMessageSelected = false;
  bool showEmojiKeyboard = false;
  final FocusNode focusNode = FocusNode();

  @override
  void initState() {
    chatId = chatFeaturesUseCase.chatRoomId(
        widget.userDetails.userId!, widget.chatUserDetails.userId!);
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        showEmojiKeyboard = false;
      }
      setState(() {});
    });

    context.read<ChatBloc>().add(LoadChatEvent(chatId: chatId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SelectionArea(
      child: Scaffold(
        backgroundColor: ColorAssets.neomCream,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Row(
                  children: [
                    IconButton(
                        style: IconButton.styleFrom(
                            visualDensity: VisualDensity(
                              horizontal: -2,
                            ),
                            padding: EdgeInsets.zero),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.arrow_back)),
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                          color: Colors.red,
                          image: DecorationImage(
                              image: NetworkImage(
                                  widget.chatUserDetails.imagepath!),
                              fit: BoxFit.cover),
                          shape: BoxShape.circle),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      widget.chatUserDetails.userName!,
                      style: GoogleFonts.roboto(
                          color: ColorAssets.neomBlack,
                          fontSize: 20,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              Expanded(
                  child: BlocConsumer<ChatBloc, ChatState>(
                      listener: (context, state) {
                if (state is InitialChatState) {}
                if (state is ChatLoadedState) {}
                if (state is ChatAddedState) {
                  context.read<ChatBloc>().add(LoadChatEvent(chatId: chatId));
                }
                if (state is ChatUpdatedState) {}
                if (state is ChatErrorState) {}
                if (state is MessageLoadedState) {}
                if (state is MessageUpdatedState) {
                  messages = state.docs;
                }
              }, buildWhen: (previous, current) {
                return current is MessageUpdatedState;
              }, builder: (context, state) {
                if (state is InitialChatState) {}
                if (state is ChatLoadedState) {}
                if (state is ChatAddedState) {}
                if (state is ChatUpdatedState) {}
                if (state is ChatErrorState) {}
                if (state is MessageLoadedState) {}
                if (state is MessageUpdatedState) {}
                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    return Align(
                      alignment: messages[index]['sender'] ==
                              widget.userDetails.userId!
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: InkWell(
                        onLongPress: () {
                          setState(() {
                            isMessageSelected = true;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16.0),
                          margin: EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15),
                                bottomLeft: Radius.circular(15),
                                topRight: Radius.circular(15)),
                            color: messages[index]['sender'] ==
                                    widget.userDetails.userId!
                                ? ColorAssets.neomBlue
                                : Colors.grey.shade300,
                          ),
                          child: Text(
                            messages[index]['content']!,
                            style: GoogleFonts.roboto(
                                color: messages[index]['sender'] ==
                                        widget.userDetails.userId!
                                    ? Colors.white
                                    : Colors.black,
                                fontSize: 16),
                          ),
                        ),
                      ),
                    );
                  },
                );
              })),
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
                          textInputAction: TextInputAction.newline,
                          cursorColor: Colors.blue,
                          keyboardType: TextInputType.multiline,
                          focusNode: focusNode,
                          onTap: () {
                            setState(() {
                              showEmojiKeyboard = false;
                            });
                          },
                          controller: _messageController,
                          decoration: InputDecoration(
                            prefixIcon: IconButton(
                                onPressed: () {
                                  if (focusNode.hasPrimaryFocus) {
                                    setState(() {
                                      showEmojiKeyboard = true;
                                      focusNode.unfocus();
                                    });
                                  } else {
                                    setState(() {
                                      showEmojiKeyboard = !showEmojiKeyboard;
                                    });
                                  }
                                },
                                icon: Icon(Icons.emoji_emotions_outlined)),
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey.shade400),
                                borderRadius: BorderRadius.circular(10)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor),
                                borderRadius: BorderRadius.circular(10)),
                            border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey.shade400),
                                borderRadius: BorderRadius.circular(10)),
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
                        final mId = FirebaseFirestore.instance
                            .collection('chats')
                            .doc(chatId)
                            .collection('message')
                            .doc()
                            .id;

                        final chat = Chat(
                          chatId: chatId,
                          createdAt: DateTime.now(),
                          groupImage: widget.chatUserDetails.imagepath!,
                          groupName: widget.chatUserDetails.userName!,
                          lastMessage: {
                            'content': _messageController.text,
                            'sender': widget.userDetails.userId!,
                            'timeStamp': Timestamp.now().toString(),
                          },
                          usersInfo: {
                            widget.userDetails.userId!: widget.userDetails,
                            widget.chatUserDetails.userId!:
                                widget.chatUserDetails
                          },
                          type: ChatType.private,
                          users: [
                            widget.userDetails.userId!,
                            widget.chatUserDetails.userId
                          ],
                        );
                        final messageObj = Message(
                          messageId: mId,
                          content: _messageController.text,
                          timeStamp: DateTime.now(),
                          sender: widget.userDetails.userId!,
                        );
                        context.read<ChatBloc>().add(AddMessageEvent(
                            chat: chat, message: messageObj, chatId: chatId));
                        _messageController.clear();
                      },
                    ),
                  ],
                ),
              ),
              ValueListenableBuilder(
                valueListenable: ValueNotifier(showEmojiKeyboard),
                builder: (BuildContext context, dynamic value, Widget? child) {
                  return Visibility(
                    visible: showEmojiKeyboard,
                    child: EmojiKeyboard(
                      emotionController: _messageController,
                      emojiKeyboardHeight: 400,
                      darkMode: true,
                      showEmojiKeyboard: showEmojiKeyboard,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
