
import 'package:chat_app/features/Presentation/Bloc/chat_bloc/chat_bloc.dart';
import 'package:chat_app/features/Presentation/Bloc/chat_bloc/chat_event.dart';
import 'package:chat_app/features/Presentation/Bloc/chat_bloc/chat_state.dart';
import 'package:chat_app/features/Presentation/pages/chat_screens/chat_home.dart';
import 'package:chat_app/features/Presentation/pages/chat_screens/home_page.dart';
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
import 'package:intl/intl.dart';

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
  List<Message> messages = [];
    List<String> selectedMessageCount = [];

  late String chatId;
  bool isEditMessage = false;
  bool isMessageSelected = false;
  bool showEmojiKeyboard = false;
  final FocusNode focusNode = FocusNode();
  late ChatBloc chatBloc;

  @override
  void initState() {
    chatId = chatFeaturesUseCase.chatRoomId(
        widget.userDetails.userId!, widget.chatUserDetails.userId!);
        chatBloc = context.read<ChatBloc>();
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        showEmojiKeyboard = false;
      }
      setState(() {});
    });

    chatBloc.add(LoadChatEvent(chatId: chatId));
    super.initState();
  }
  @override
  void dispose() {
    chatBloc.streamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: selectedMessageCount.isEmpty,
      onPopInvoked: (didPop) {
        if (selectedMessageCount.isNotEmpty) {
          selectedMessageCount.clear();
          setState(() {});
        }
      },
      child: SelectionArea(
        child: Scaffold(
          backgroundColor: ColorAssets.neomCream,
          body: SafeArea(
            child: Column(
              children: [
                
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, ChatMainScreen.chatMainScreen);
                        },
                        child: const Icon(Icons.arrow_back),
                      ),
                    ),
                    Container(
                      height: 35,
                      width: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        image: DecorationImage(
                          image: NetworkImage(
                            widget.chatUserDetails.imagepath!,
                          ),
                          fit: BoxFit.cover,
                        ),
                        // color: Colors.black,
                      ),
                      alignment: Alignment.center,
                    ),
                    InkWell(
                      onTap: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (_) => const UserProfileScreen(),
                        //   ),
                        // );
                      },
                      child: Container(
                        height: 50,
                        // width: 200,
                        padding: const EdgeInsets.only(left: 10),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          widget.chatUserDetails.userName!,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    selectedMessageCount.isNotEmpty
                        ? Row(
                            children: [
                              selectedMessageCount.length == 1
                                  ? IconButton(
                                      onPressed: () {},
                                      iconSize: 22,
                                      color: ColorAssets.neomBlack,
                                      icon: const Icon(
                                        Icons.edit,
                                      ),
                                    )
                                  : Container(),
                              IconButton(
                                onPressed: () {
                                  // _chatBloc.add(
                                  //   DeleteMessageEvent(
                                  //       chatId: chatId!,
                                  //       messageIds: selectedMessageCount),
                                  // );
                                },
                                iconSize: 22,
                                color: ColorAssets.neomBlack,
                                icon: const Icon(
                                  Icons.delete,
                                ),
                              ),
                            ],
                          )
                        : PopupMenuButton(
                            icon: const Icon(Icons.more_vert),
                            iconSize: 24,
                            padding: const EdgeInsets.only(left: 20),
                            onSelected: (value) {
                              // switch (value) {
                              //   case PopUpMenuList.signOut:
                              //     context.read<AuthBloc>().add(
                              //           UserSignOutEvent(),
                              //         );

                              //   default:
                              // }
                            },
                            position: PopupMenuPosition.under,
                            itemBuilder: (BuildContext bc) {
                              return const [
                                PopupMenuItem(
                                  child: Text("NewGroup"),
                                ),
                                PopupMenuItem(
                                  child: Text("Settings"),
                                ),
                                PopupMenuItem(
                                  
                                  child: Text("Sign-Out"),
                                )
                              ];
                            },
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
                    messages = state.docs
                        .map((e) => Message.fromJson(e.data()))
                        .toList();
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
                      String timestampString = messages[index].timeStamp.toString(); // Assuming 'timeStamp' is a string representing a timestamp
                      DateTime timestamp = DateTime.parse(timestampString);
                      String formattedTime =
                          DateFormat('HH:mm').format(timestamp);
      
                      return InkWell(
                        onLongPress: () {
                            if (selectedMessageCount.contains(
                                messages[index].messageId)) {
                              selectedMessageCount.remove(
                                  messages[index].messageId);
                            } else {
                              selectedMessageCount.add(
                                  messages[index].messageId!);
                            }
                            setState(() {});
                          },
                          onTap: () {
                            if (selectedMessageCount.length == 1 &&
                                selectedMessageCount.contains(messages[index].messageId)) {
                              selectedMessageCount.remove(
                                  messages[index].messageId);
                            } else if (selectedMessageCount.isNotEmpty &&
                                !selectedMessageCount.contains(messages[index].messageId)) {
                              selectedMessageCount.add(
                                  messages[index].messageId!);
                            } else {
                              selectedMessageCount.remove(
                                  messages[index].messageId);
                            }
                            setState(() {});
                          },
                        child: Container(
                          alignment: Alignment.topRight,
                          color: selectedMessageCount.contains(
                                messages[index].messageId)
                            ? ColorAssets.neomBlue.withOpacity(0.15)
                            : null,
                          child: Align(
                            alignment: messages[index].sender ==
                                widget.userDetails.userId!
                            ? Alignment.topRight
                            : Alignment.topLeft,
                          child: Container(
                            child: Container(
                                                        
                              constraints: BoxConstraints(minWidth: 100),
                              padding: EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 10.0),
                              margin:
                                  EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                              decoration: BoxDecoration(
                                      color: messages[index].sender ==
                                      widget.userDetails.userId!
                                  ? ColorAssets.neomBlue
                                  : Colors.grey.shade300,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    bottomLeft: Radius.circular(15),
                                    topRight: Radius.circular(15)),
                              
                              ),
                              child: IntrinsicWidth(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      messages[index].content!,
                                      style: GoogleFonts.roboto(
                                          color: messages[index].sender ==
                                                  widget.userDetails.userId!
                                              ? Colors.white
                                              : Colors.black,
                                          fontSize: 16),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            formattedTime,
                                            style: GoogleFonts.roboto(
                                                color: messages[index].sender ==
                                                        widget.userDetails.userId!
                                                    ? Colors.white
                                                    : Colors.black,
                                                fontSize: 12),
                                          ),
                                          SizedBox(width: 5),
                                          messages[index].sender ==
                                                  widget.userDetails.userId!
                                              ? Icon(
                                                  Icons.done_all,
                                                  color:   (messages[index].seenby!.contains(widget.chatUserDetails.userId)) ? Colors.white : Colors.black ,
                                                  size: 15,
                                                )
                                              : Container(),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          )));
                      
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
                            readby: widget.chatUserDetails.userId,
                            chatId: chatId,
                            createdAt: DateTime.now(),
                            groupImage: widget.chatUserDetails.imagepath!,
                            groupName: widget.chatUserDetails.userName!,
                            lastMessage: {
                              'content': _messageController.text,
                              'sender': widget.userDetails.userId!,
                              'timeStamp': DateTime.now(),
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
                            seenby: [],
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
                  valueListenable: ValueNotifier(0),
                  builder: (BuildContext context, dynamic value, Widget? child) {
                    return Visibility(
                      visible: showEmojiKeyboard,
                      child: EmojiKeyboard(
                        emotionController: _messageController,
                        emojiKeyboardHeight: 350,
                        darkMode: true,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
