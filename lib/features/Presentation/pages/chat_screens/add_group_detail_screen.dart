import 'dart:io';

import 'package:chat_app/common/constants/app_constanst.dart';
import 'package:chat_app/common/constants/color_constants.dart';
import 'package:chat_app/features/Presentation/Bloc/chat_bloc/chat_bloc.dart';
import 'package:chat_app/features/Presentation/Bloc/chat_bloc/chat_event.dart';
import 'package:chat_app/features/Presentation/Bloc/chat_bloc/chat_state.dart';
import 'package:chat_app/features/Presentation/pages/chat_screens/chat_screen.dart';
import 'package:chat_app/features/data/entity/user.dart';
import 'package:chat_app/features/data/model/chat_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class CreateGroupDetailScreen extends StatefulWidget {
  static const createGroupDetailScreen = 'CreateGroupDetailScreen';
  final List<UserDetails> groupParticipants;
  const CreateGroupDetailScreen({super.key, required this.groupParticipants});

  @override
  State<CreateGroupDetailScreen> createState() =>
      _CreateGroupDetailScreenState();
}

class _CreateGroupDetailScreenState extends State<CreateGroupDetailScreen> {
  final FocusNode focusNode = FocusNode();
  final user = FirebaseAuth.instance.currentUser;
  TextEditingController groupNameController = TextEditingController();
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  Uint8List? imageFile;
  final ImagePicker image = ImagePicker();
  XFile? imagepath;
  String? GroupImageUrl;
  Chat? chat;
  @override
  void initState() {
    focusNode.requestFocus();
    focusNode.addListener(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorAssets.neomCream,
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        backgroundColor: ColorAssets.neomCream,
        leading: IconButton(
          onPressed: () {},
          icon: Icon(Icons.arrow_back),
        ),
        title: Text(
          'Create Group',
          style: GoogleFonts.roboto(
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        elevation: 0.0,
      ),
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        onPressed: () async {
          final gId = FirebaseFirestore.instance.collection('chats').doc().id;
          List<String> users = [];
          for (var i = 0; i < widget.groupParticipants.length; i++) {
            users.add(widget.groupParticipants[i].userId!);
          }
          Map<String, UserDetails>? usersInfo = widget.groupParticipants
              .asMap()
              .map((key, value) => MapEntry(value.userId!, value));

          if (imagepath != null) {
            File file = File(imagepath!.path);
            final storageRef = FirebaseStorage.instance.ref();
            final imageref =
                await storageRef.child("Group/${gId}").putFile(file);
            final imageUrl = await imageref.ref.getDownloadURL();
            GroupImageUrl = imageUrl;
          }

           chat = Chat(
              chatId: gId,
              createdAt: DateTime.now(),
              groupImage: GroupImageUrl ?? AppConstant.defaultIcon,
              groupName: groupNameController.text,
              usersInfo: usersInfo,
              type: ChatType.group,
              users: users);

          context.read<ChatBloc>().add(AddChatEvent(chat: chat!, chatId: gId));
        },
        backgroundColor: ColorAssets.neomBlue,
        child: Icon(
          Icons.done,
          color: Colors.white,
        ),
      ),
      body: BlocListener<ChatBloc, ChatState>(
        listener: (context, state) {
        if (state is ChatAddedState) {
          Navigator.pushReplacementNamed(context, ChatScreen.chatScreen, arguments: [
            chat,
            ChatType.group
          ]);
        }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            Stack(
              children: [
                Row(
                  children: [
                    Container(
                        margin: EdgeInsets.only(left: 20),
                        padding: EdgeInsets.all(5),
                        height: 120,
                        width: 120,
                        decoration: BoxDecoration(
                          border: Border.all(color: ColorAssets.neomBlue),
                          shape: BoxShape.circle,
                        ),
                        child: imageFile != null
                            ? Container(
                                padding: EdgeInsets.all(8),
                                height: 100,
                                width: 100,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: MemoryImage(imageFile!),
                                      fit: BoxFit.cover,
                                    )),
                              )
                            : GroupImageUrl != null
                                ? Container(
                                    height: 120,
                                    width: 120,
                                    clipBehavior: Clip.hardEdge,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                    ),
                                    child: Image(
                                      image: NetworkImage(GroupImageUrl!),
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Container(
                                    padding: EdgeInsets.all(8),
                                    height: 100,
                                    width: 100,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          image: AssetImage(
                                              'assets/images/group_icon.png'),
                                          fit: BoxFit.cover,
                                        )),
                                  )),
                    SizedBox(
                      width: 30,
                    ),
                    Expanded(
                      child: Container(
                          margin: EdgeInsets.all(5),
                          child: TextFormField(
                            controller: groupNameController,
                            decoration: InputDecoration(
                              hintText: 'Group Name',
                            ),
                          )),
                    )
                  ],
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height / 10,
                  right: MediaQuery.of(context).size.width / 1.55,
                  child: InkWell(
                    onTap: () async {
                      imagepath =
                          await image.pickImage(source: ImageSource.gallery);

                      if (imagepath == null) return;
                      imageFile = await imagepath!.readAsBytes();
                      setState(() {});
                    },
                    child: CircleAvatar(
                      radius: 15,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.edit, size: 20),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(50),
                    topLeft: Radius.circular(50),
                  ),
                ),
                height: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Participants :',
                      style: GoogleFonts.roboto(
                          fontSize: 20,
                          color: ColorAssets.neomBlue,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      color: Colors.white,
                      margin: EdgeInsets.only(
                          top: 10, left: 15, right: 15, bottom: 0),
                      height: 120,
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                        ),
                        itemCount: widget.groupParticipants.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Stack(
                            children: [
                              Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(5),
                                    height: 60,
                                    width: 60,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: ColorAssets.neomBlue),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Container(
                                      padding: EdgeInsets.all(8),
                                      height: 60,
                                      width: 60,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                            image: NetworkImage(
                                              widget.groupParticipants[index]
                                                  .imagepath!,
                                            ),
                                            fit: BoxFit.cover,
                                          )),
                                    ),
                                  ),
                                  Text(
                                    widget.groupParticipants[index].firstName!,
                                    style: GoogleFonts.roboto(
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                              InkWell(
                                onTap: () {
                                  widget.groupParticipants.removeAt(index);
                                  setState(() {});
                                },
                                child: CircleAvatar(
                                  radius: 10,
                                  backgroundColor: Colors.white,
                                  child: Icon(Icons.cancel, size: 14),
                                ),
                              )
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
