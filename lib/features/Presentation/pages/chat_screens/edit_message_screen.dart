import 'package:chat_app/common/constants/color_constants.dart';
import 'package:chat_app/features/Presentation/Bloc/chat_bloc/chat_bloc.dart';
import 'package:chat_app/features/Presentation/Bloc/chat_bloc/chat_event.dart';
import 'package:chat_app/features/Presentation/Bloc/chat_bloc/chat_state.dart';
import 'package:chat_app/features/data/model/message_model.dart';
import 'package:emoji_keyboard_flutter/emoji_keyboard_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class EditMessageScreen extends StatefulWidget {
  final String newMessage;
  final String chatId;
  final String messageId;
  final String timeStampMessage;
  final List<Message> message;
  const EditMessageScreen({
    super.key,
    required this.newMessage,
    required this.chatId,
    required this.messageId,
    required this.timeStampMessage,
    required this.message,
  });

  static const editMessageScreen = 'editMessageScreen';

  @override
  State<EditMessageScreen> createState() => _EditMessageScreenState();
}

class _EditMessageScreenState extends State<EditMessageScreen> {
  final TextEditingController _messageController = TextEditingController();
  bool showEmojiKeyboard = false;
  final FocusNode focusNode = FocusNode();
  late ChatBloc chatBloc;
  List<Message> message = [];

  @override
  void initState() {
    chatBloc = context.read<ChatBloc>();
    focusNode.requestFocus();
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        showEmojiKeyboard = false;
      }
      setState(() {});
      _messageController.text = widget.newMessage;
    });
    message = widget.message;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent.withOpacity(0.7),
      body: BlocListener<ChatBloc, ChatState>(
        listener: (context, state) {
          if (state is EditedMessageState) {
            Navigator.pop(context);
          }
        },
        child: SafeArea(
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
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        )),
                    Spacer(),
                    PopupMenuButton(
                      elevation: 0.0,
                      color: Colors.white,
                      itemBuilder: (context) {
                        return [
                          PopupMenuItem(child: Text('Report')),
                          PopupMenuItem(child: Text('Block')),
                          PopupMenuItem(child: Text('Clear Chat')),
                          PopupMenuItem(child: Text('Search')),
                          PopupMenuItem(child: Text('Media,links,and docs'))
                        ];
                      },
                    )
                  ],
                ),
              ),
              Expanded(
                  child: ListView.builder(
                      reverse: true,
                      itemCount: 1,
                      itemBuilder: (context, index) {
                        return Container(
                           alignment: Alignment.topRight,
                          color: Colors.transparent,
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
                                color: ColorAssets.neomBlue),
                            child: IntrinsicWidth(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.newMessage,
                                    style: GoogleFonts.roboto(
                                        color: Colors.white, fontSize: 16),
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
                                          widget.timeStampMessage,
                                          style: GoogleFonts.roboto(
                                              color: Colors.white,
                                              fontSize: 12),
                                        ),
                                      
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
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
                          cursorColor: Colors.white,
                          style: TextStyle(color: Colors.white),
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
                                icon: Icon(
                                  Icons.emoji_emotions_outlined,
                                  color: Colors.white,
                                )),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(10)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(10)),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
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
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: ColorAssets.neomBlue,
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.done,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          chatBloc.add(EditedMessageEvent(
                              chatId: widget.chatId,
                              messageId: widget.messageId,
                              newMessage: _messageController.text));
                        },
                      ),
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
    );
  }
}
