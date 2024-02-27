import 'package:chat_app/common/constants/color_constants.dart';
import 'package:chat_app/features/Presentation/pages/chat_screens/add_group_detail_screen.dart';
import 'package:chat_app/features/data/entity/user.dart';
import 'package:chat_app/features/data/entity/user_session.dart';
import 'package:chat_app/features/dependencyInjector/injector.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CreateGroupScreen extends StatefulWidget {
  static const createGroupScreen = 'CreateGroupScreen';
  const CreateGroupScreen({super.key});

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final TextEditingController searchController = TextEditingController();
  final FocusNode focusNode = FocusNode();
  final UserSession _userSession = sl<UserSession>();
  final user = FirebaseAuth.instance.currentUser;
  final List<UserDetails> groupParticipants = [];
  
  

  @override
  void initState() {
    focusNode.requestFocus();
    focusNode.addListener(() {});
    groupParticipants.add(_userSession.userDetails!);
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
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Text(
          'New Group',
          style: GoogleFonts.roboto(
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        elevation: 0.0,
      ),
      floatingActionButton: FloatingActionButton(
         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        elevation: 0.0,
        onPressed: () {
          Navigator.pushReplacementNamed(context,CreateGroupDetailScreen.createGroupDetailScreen, arguments: groupParticipants);
        },
        backgroundColor: ColorAssets.neomBlue,
        child: Icon(Icons.arrow_forward, color: Colors.white,),
      ),
      body: Column(
        children: [
          Column(
            children: [
              Padding(
                padding:
                    EdgeInsets.only(top: 8, left: 15, right: 15, bottom: 10),
                child: SearchBar(
                    focusNode: focusNode,
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12))),
                    controller: searchController,
                    onChanged: (value) {
                      setState(() {});
                    },
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                    elevation: MaterialStateProperty.all(0.0),
                    padding: MaterialStateProperty.all(
                        EdgeInsets.symmetric(horizontal: 10)),
                    leading: Icon(Icons.search),
                    hintText: "Search",
                    hintStyle: MaterialStateProperty.all(GoogleFonts.roboto(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ))),
              ),
              Container(
                margin:
                    EdgeInsets.only(top: 10, left: 15, right: 15, bottom: 0),
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: groupParticipants.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Stack(
                      children: [
                        Column(
                          children: [
                            Container(
                              margin: EdgeInsets.all(5),
                              padding: EdgeInsets.all(5),
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                border: Border.all(color: ColorAssets.neomBlue),
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
                                        groupParticipants[index].imagepath!,
                                      ),
                                      fit: BoxFit.cover,
                                    )),
                              ),
                            ),
                            Text(
                              groupParticipants[index].firstName!,
                              style: GoogleFonts.roboto(
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: () {
                            groupParticipants.removeAt(index);
                            setState(() {});
                          },
                          child: CircleAvatar(
                            radius: 12,
                            backgroundColor: Colors.white,
                            child: Icon(Icons.cancel, size: 17),
                          ),
                        )
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .where('userId', isNotEqualTo: user!.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                final document = snapshot.data?.docs;

                if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return Expanded(
                  child: Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(50),
                        topLeft: Radius.circular(50),
                      ),
                    ),
                    height: double.infinity,
                    child: ListView.separated(
                      separatorBuilder: (context, index) => Divider(
                        thickness: 0.3,
                        color: Colors.grey,
                      ),
                      itemCount: document!.length,
                      itemBuilder: (BuildContext context, int index) {
                        UserDetails userDetails = UserDetails.fromJson(
                            document[index].data() as Map<String, dynamic>);
                        final checked = groupParticipants.contains(userDetails);
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          trailing: Transform.scale(
                            scale: 1.2,
                            child: Checkbox.adaptive(
                              checkColor: Colors.white,
                              fillColor: MaterialStateProperty.all(checked
                                  ? ColorAssets.neomBlue
                                  : Colors.white),
                              shape: CircleBorder(),
                              value: checked,
                              onChanged: (value) {
                                if (value!) {
                                  groupParticipants.add(userDetails);
                                  setState(() {});
                                }
                                if (value == false) {
                                  groupParticipants.remove(userDetails);
                                  setState(() {});
                                }
                              },
                            ),
                          ),
                          leading: Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image: NetworkImage(
                                        document[index]['imagepath']))),
                          ),
                          title: Text(document[index]['userName']),
                          subtitle: Text(document[index]['email']),
                        );
                      },
                    ),
                  ),
                );
              })
        ],
      ),
    );
  }
}
