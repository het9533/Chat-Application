import 'package:chat_app/features/Presentation/Bloc/chat_bloc/chat_bloc.dart';
import 'package:chat_app/features/Presentation/Bloc/chat_bloc/chat_event.dart';
import 'package:chat_app/features/Presentation/Bloc/chat_bloc/chat_state.dart';
import 'package:chat_app/features/Presentation/pages/chat_screens/edit_message_screen.dart';
import 'package:chat_app/features/Presentation/widgets/delete_alert_box.dart';
import 'package:chat_app/features/data/entity/user_session.dart';
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
  Chat? chatModel;
  final ChatType chatType;
  static const chatScreen = 'chatScreen';
  ChatScreen({Key? key, required this.chatType, this.chatModel})
      : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatFeaturesUseCase chatFeaturesUseCase = sl<ChatFeaturesUseCase>();
  final TextEditingController _messageController = TextEditingController();
  List<Message> messages = [];
  late String chatId;
  bool isEditMessage = false;
  bool isMessageSelected = false;
  bool showEmojiKeyboard = false;
  final FocusNode focusNode = FocusNode();
  late ChatBloc chatBloc;
  List<String> selectedMessage = [];
  bool selectionMode = false;
  String? messageTimeStamp;
  final UserSession _userSession = sl<UserSession>();
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    print(widget.chatModel!.users);
    if (widget.chatType == ChatType.private) {
      chatId = chatFeaturesUseCase.chatRoomId(_userSession.userDetails!.userId!,
          _userSession.endUserDetails!.userId!);
    } else {
      chatId = widget.chatModel!.chatId!;
    }
    chatBloc = context.read<ChatBloc>();
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        showEmojiKeyboard = false;
      }
      setState(() {});
    });

    chatBloc.add(LoadMessageEvent(chatId: chatId));
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
      canPop: selectedMessage.isEmpty,
      onPopInvoked: (didPop) {
        if (selectedMessage.isNotEmpty) {
          selectedMessage.clear();
          setState(() {
            isEditMessage = false;
            isMessageSelected = false;
            selectionMode = false;
          });
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
                      widget.chatType == ChatType.group
                          ? Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                  color: Colors.red,
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          widget.chatModel!.groupImage!),
                                      fit: BoxFit.cover),
                                  shape: BoxShape.circle),
                            )
                          : Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                  color: Colors.red,
                                  image: DecorationImage(
                                      image: NetworkImage(_userSession
                                          .endUserDetails!.imagepath!),
                                      fit: BoxFit.cover),
                                  shape: BoxShape.circle),
                            ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          widget.chatType == ChatType.group
                              ? Text(
                                  widget.chatModel!.groupName!,
                                  style: GoogleFonts.roboto(
                                      color: ColorAssets.neomBlack,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500),
                                )
                              : Text(
                                  _userSession.endUserDetails!.userName!,
                                  style: GoogleFonts.roboto(
                                      color: ColorAssets.neomBlack,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500),
                                ),
                          (widget.chatType == ChatType.group &&
                                  widget.chatModel != null)
                              ? Text(
                                  'You, ${widget.chatModel!.usersInfo!.values.where((e) => e.userId != _userSession.userDetails!.userId).map((e) => e.userName).join(', ')}',
                                  style: GoogleFonts.roboto(
                                    color: ColorAssets.neomBlack,
                                    fontSize: 14,
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                      Spacer(),
                      !selectionMode
                          ? PopupMenuButton(
                              elevation: 0.0,
                              color: Colors.white,
                              itemBuilder: (context) {
                                return [
                                  PopupMenuItem(child: Text('Report')),
                                  PopupMenuItem(child: Text('Block')),
                                  PopupMenuItem(child: Text('Clear Chat')),
                                  PopupMenuItem(child: Text('Search')),
                                  PopupMenuItem(
                                      child: Text('Media,links,and docs'))
                                ];
                              },
                            )
                          : Row(
                              children: [
                                if (selectedMessage.length == 1 &&
                                    messages
                                            .firstWhere((element) =>
                                                element.messageId ==
                                                selectedMessage[0])
                                            .sender ==
                                        _userSession.userDetails!.userId!)
                                  IconButton(
                                      onPressed: () {
                                        final String editMessage =
                                            selectedMessage[0];
                                        selectedMessage.clear();
                                        setState(() {
                                          isEditMessage = false;
                                          isMessageSelected = false;
                                          selectionMode = false;
                                        });
                                        Navigator.push(
                                            context,
                                            PageRouteBuilder(
                                              barrierColor: Colors.transparent,
                                              opaque: false,
                                              pageBuilder: (context, animation,
                                                  secondaryAnimation) {
                                                return EditMessageScreen(
                                                    message: messages,
                                                    timeStampMessage:
                                                        messageTimeStamp!,
                                                    chatId: chatId,
                                                    messageId: editMessage,
                                                    newMessage: messages
                                                        .firstWhere((element) =>
                                                            element.messageId ==
                                                            editMessage)
                                                        .content!);
                                              },
                                            ));
                                      },
                                      icon: Icon(Icons.edit))
                                else
                                  Container(),
                                IconButton(
                                    onPressed: () {
                                      setState(() {
                                        isEditMessage = false;
                                        isMessageSelected = false;
                                        selectionMode = false;
                                      });
                                      DeleteAccountDialouge(
                                          context: context,
                                          onNoPressed: () {
                                            setState(() {
                                              isEditMessage = false;
                                              isMessageSelected = false;
                                              selectionMode = false;
                                              selectedMessage.clear();
                                            });
                                            Navigator.pop(context);
                                          },
                                          onYesPressed: () {
                                            Navigator.pop(context);
                                            context.read<ChatBloc>().add(
                                                DeleteMessageEvent(
                                                    selectedMessage,
                                                    chatId: chatId));
                                          });
                                    },
                                    icon: Icon(Icons.delete))
                              ],
                            )
                    ],
                  ),
                ),
                Expanded(
                    child: BlocConsumer<ChatBloc, ChatState>(
                        listener: (context, state) {
                  if (state is InitialChatState) {
                  } else if (state is ChatLoadedState) {
                  } else if (state is ChatUpdatedState) {
                  } else if (state is ChatErrorState) {
                  } else if (state is MessageLoadedState) {
                  } else if (state is MessageUpdatedState) {
                    messages = state.docs
                        .map((e) => Message.fromJson(e.toJson()))
                        .toList();
                    WidgetsBinding.instance.addPostFrameCallback(
                      (_) => controller
                          .jumpTo(controller.position.maxScrollExtent),
                    );
                  }
                }, buildWhen: (previous, current) {
                  return current is MessageUpdatedState ||
                      current is ChatAddedState ||
                      current is ChatErrorState ||
                      current is ChatLoadedState ||
                      current is ChatUpdatedState ||
                      current is DeletedMessageState ||
                      current is EditedMessageState ||
                      current is InitialChatState;
                }, builder: (context, state) {
                  if (state is InitialChatState) {}
                  if (state is ChatLoadedState) {}
                  if (state is ChatAddedState) {}
                  if (state is ChatUpdatedState) {}
                  if (state is ChatErrorState) {}
                  if (state is MessageLoadedState) {}
                  if (state is MessageUpdatedState) {}
                  if (state is DeletedMessageState) {
                    selectedMessage.clear();
                  }
                  if (state is EditedMessageState) {}
                  return CustomScrollView(
                    controller: controller,
                    slivers: [
                      (widget.chatModel?.type == ChatType.group)
                          ? SliverPadding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 30),
                              sliver: SliverToBoxAdapter(
                                child: Container(
                                  alignment: Alignment.center,
                                  child: (widget.chatModel
                                              ?.lastMessage?['sender'] ==
                                          _userSession.userDetails?.userId)
                                      ? Text(
                                          'You created a group',
                                          style: TextStyle(color: Colors.grey),
                                        )
                                      : Text(
                                          "${widget.chatModel?.usersInfo![widget.chatModel?.lastMessage!['sender']]?.userName} created group",
                                          style: TextStyle(color: Colors.grey)),
                                ),
                              ),
                            )
                          : SliverToBoxAdapter(child: Container()),
                      SliverList.builder(
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final reversedIndex = messages.length - index - 1;

                          String timestampString =
                              messages[reversedIndex].timeStamp.toString();
                          DateTime timestamp = DateTime.parse(timestampString);
                          String formattedTime =
                              DateFormat('hh:mm a').format(timestamp);
                          messageTimeStamp = formattedTime;
                          return InkWell(
                            onLongPress: () {
                              selectedMessage
                                  .add(messages[reversedIndex].messageId!);
                              // print(selectedMessage);
                              setState(() {
                                selectionMode = true;
                              });
                            },
                            onTap: () {
                              if (selectionMode) {
                                if (selectedMessage.contains(
                                    messages[reversedIndex].messageId)) {
                                  selectedMessage.remove(
                                      messages[reversedIndex].messageId);
                                  setState(() {});
                                } else {
                                  selectedMessage
                                      .add(messages[reversedIndex].messageId!);
                                  setState(() {});
                                }
                              }
                              if (selectedMessage.isEmpty) {
                                setState(() {
                                  selectionMode = false;
                                });
                              }
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 3),
                              alignment: messages[reversedIndex].sender ==
                                      _userSession.userDetails!.userId!
                                  ? Alignment.topRight
                                  : Alignment.topLeft,
                              color: selectedMessage.contains(
                                      messages[reversedIndex].messageId!)
                                  ? ColorAssets.neomBlue.withOpacity(0.15)
                                  : Colors.transparent,
                              child: Container(
                                constraints: BoxConstraints(minWidth: 100),
                                padding: EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 10.0),
                                margin: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      bottomLeft: Radius.circular(15),
                                      topRight: Radius.circular(15)),
                                  color: messages[reversedIndex].sender ==
                                          _userSession.userDetails!.userId!
                                      ? ColorAssets.neomBlue
                                      : Colors.grey.shade300,
                                ),
                                child: IntrinsicWidth(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        messages[reversedIndex].content!,
                                        style: GoogleFonts.roboto(
                                            color: messages[reversedIndex]
                                                        .sender ==
                                                    _userSession
                                                        .userDetails!.userId!
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              formattedTime,
                                              style: GoogleFonts.roboto(
                                                  color: messages[reversedIndex]
                                                              .sender ==
                                                          _userSession
                                                              .userDetails!
                                                              .userId!
                                                      ? Colors.white
                                                      : Colors.black,
                                                  fontSize: 12),
                                            ),
                                            SizedBox(width: 5),
                                            messages[reversedIndex].sender ==
                                                    _userSession
                                                        .userDetails!.userId!
                                                ? widget.chatType ==
                                                        ChatType.group
                                                    ? Icon(
                                                        Icons.done_all,
                                                        color: !(messages[
                                                                    reversedIndex]
                                                                .unseenby!
                                                                .contains(messages[reversedIndex].sender))
                                                            ? Colors
                                                                .lightGreenAccent
                                                            : Colors.white,
                                                        size: 15,
                                                      )
                                                    : Icon(
                                                        Icons.done_all,
                                                        color: !(messages[
                                                                    reversedIndex]
                                                                .unseenby!
                                                                .contains(_userSession
                                                                    .endUserDetails
                                                                    ?.userId!))
                                                            ? Colors
                                                                .lightGreenAccent
                                                            : Colors.white,
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
                          );
                        },
                      )
                    ],
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
                          if (widget.chatType == ChatType.private) {
                            final chat = Chat(
                              chatId: chatId,
                              createdAt: DateTime.now(),
                              groupImage:
                                  _userSession.endUserDetails?.imagepath!,
                              groupName: _userSession.endUserDetails?.userName,
                              lastMessage: {
                                'content': _messageController.text,
                                'sender': _userSession.userDetails!.userId!,
                                'timeStamp': DateTime.now(),
                              },
                              usersInfo: {
                                _userSession.userDetails!.userId!:
                                    _userSession.userDetails!,
                                _userSession.endUserDetails!.userId!:
                                    _userSession.endUserDetails!
                              },
                              type: ChatType.private,
                              users: [
                                _userSession.userDetails!.userId!,
                                _userSession.endUserDetails!.userId!
                              ],
                            );
                            final messageObj = Message(
                              unseenby: [
                                _userSession.userDetails!.userId!,
                                _userSession.endUserDetails!.userId!
                              ],
                              messageId: mId,
                              content: _messageController.text,
                              timeStamp: DateTime.now(),
                              sender: _userSession.userDetails!.userId!,
                            );
                            widget.chatModel = chat;
                            context.read<ChatBloc>().add(AddMessageEvent(
                                chat: chat,
                                message: messageObj,
                                chatId: chatId));
                          } else {
                            final chatModel = Chat(
                              chatId: chatId,
                              createdAt: DateTime.now(),
                              groupImage: widget.chatModel?.groupImage,
                              groupName: widget.chatModel?.groupName,
                              lastMessage: {
                                'content': _messageController.text,
                                'sender': _userSession.userDetails!.userId!,
                                'timeStamp': DateTime.now(),
                              },
                              usersInfo: widget.chatModel?.usersInfo,
                              type: ChatType.group,
                              users: widget.chatModel?.users?.toList(),
                            );
                            print(widget.chatModel?.users?.toList());
                            final messageObj = Message(
                              unseenby: widget.chatModel?.users?.toList(),
                              messageId: mId,
                              content: _messageController.text,
                              timeStamp: DateTime.now(),
                              sender: _userSession.userDetails!.userId!,
                            );

                            context.read<ChatBloc>().add(AddMessageEvent(
                                chat: chatModel,
                                message: messageObj,
                                chatId: chatId));
                          }
                          _messageController.clear();
                        },
                      ),
                    ],
                  ),
                ),
                ValueListenableBuilder(
                  valueListenable: ValueNotifier(0),
                  builder:
                      (BuildContext context, dynamic value, Widget? child) {
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
