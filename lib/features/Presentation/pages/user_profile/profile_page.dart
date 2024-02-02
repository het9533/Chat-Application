import 'dart:io';

import 'package:chat_app/features/Presentation/widgets/booking_button.dart';
import 'package:chat_app/features/Presentation/widgets/customCircle_page.dart';
import 'package:chat_app/features/Presentation/widgets/custom_text_form_field.dart';
import 'package:chat_app/features/data/entity/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  final UserDetails userDetails;

  const ProfilePage({super.key, required this.userDetails});

  @override
  State<ProfilePage> createState() =>
      _ProfilePageState(userDetails: userDetails);
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  bool editMode = false;

  TextEditingController firstnamecontroller = TextEditingController();
  TextEditingController lastnamecontroller = TextEditingController();
  TextEditingController emailnamecontroller = TextEditingController();
  TextEditingController ssncontroller = TextEditingController();

  final UserDetails userDetails;

  File? _image;
  String? myImagePath;

  _ProfilePageState({required this.userDetails});

  @override
  void initState() {
    super.initState();
    loadImage(userDetails);
  }

  Future getImage(ImageSource source) async {
    try {
      final XFile? imagePath = await ImagePicker().pickImage(source: source);
      if (imagePath == null) return;

      final imagePermanent = await saveFilePermanently(imagePath);

      setState(() {
        this._image = imagePermanent;
      });
    } on PlatformException catch (e) {
      print("error $e");
    }
  }

  Future<File> saveFilePermanently(XFile imagePath) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final directory = await getApplicationDocumentsDirectory();
    final file = File("${directory.path}/images/${imagePath.name}");

    await file.create(recursive: true);
    await file.writeAsBytes(await imagePath.readAsBytes());
    userDetails.imagepath = file.path;
    prefs.setString("profilImage", userDetails.imagepath!);

    return file;
  }

  loadImage(UserDetails userDetails) async {
    setState(() {
      _image = File(userDetails.imagepath!);
    });
  }

  void DeleteAccountData() {
    firstnamecontroller.text = "";
    lastnamecontroller.text = "";
    emailnamecontroller.text = "";
    _image = null;
  }

  void DeleteAccountDialouge(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('Alert'),
        content: const Text('Are you Sure you want to Delete your Account'),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('No'),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              DeleteAccountData();
              setState(() {
                prefs.clear();
              });
              await Future.delayed(Duration(seconds: 1));
              Navigator.pop(context);
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        elevation: 0.0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {},
          icon: Icon(
            CupertinoIcons.arrow_left,
            size: 30,
          ),
        ),
        title: Text(
          editMode ? "Edit Profile" : "Profile",
          style: Theme.of(context).primaryTextTheme.headlineLarge,
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
                child: Column(
                  children: [
                    _image != null
                        ? Container(
                            height: 150,
                            width: 150,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: FileImage(_image!),
                                fit: BoxFit.cover,
                              ),
                              shape: BoxShape.circle,
                              border:
                                  Border.all(width: 1.5, color: Colors.black),
                            ),
                            child: editMode
                                ? Center(
                                    child: Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.5),
                                        shape: BoxShape.circle,
                                      ),
                                      child: InkWell(
                                        onTap: () {
                                          getImage(ImageSource.gallery);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(15),
                                          child: SvgPicture.asset(
                                              "assets/images/edit.svg"),
                                        ),
                                      ),
                                    ),
                                  )
                                : null,
                          )
                        : Container(
                            height: 150,
                            width: 150,
                            child: CustomPaint(
                              child: editMode
                                  ? Center(
                                      child: Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.5),
                                          shape: BoxShape.circle,
                                        ),
                                        child: InkWell(
                                          onTap: () {
                                            getImage(ImageSource.gallery);
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(15),
                                            child: SvgPicture.asset(
                                                "assets/images/edit.svg"),
                                          ),
                                        ),
                                      ),
                                    )
                                  : null,
                              painter: customCirclePainter(),
                              size: Size(150, 150),
                            ),
                          ),
                    SizedBox(
                      height: 30,
                    ),
                    Form(
                      child: Column(
                        children: [
                          CustomTextFormField(
                            label: "First name",
                            hint: userDetails.displayName ?? "",
                            controller: firstnamecontroller,
                            enabled: editMode ? true : false,
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          CustomTextFormField(
                            label: "Last name",
                            hint: userDetails.displayName ?? "",
                            controller: lastnamecontroller,
                            enabled: editMode ? true : false,
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          CustomTextFormField(
                            label: "Email",
                            hint: userDetails.email ?? "",
                            controller: emailnamecontroller,
                            enabled: editMode ? true : false,
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          CustomTextFormField(
                            label: "Social security number",
                            hint: '1997-07-14-0000',
                            controller: ssncontroller,
                            enabled: false,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          rowBottomButtons(
              FirstButtonText: editMode ? "Discard" : "Delete Account",
              SecondButtonText: editMode ? "Save Changes" : "Edit Details",
              OnSecondButtonPressed: () async {
                if (editMode == false) {
                  setState(() {
                    editMode = true;
                  });
                } else {
                  setState(() {
                    editMode = false;
                    userDetails.displayName = firstnamecontroller.text;
                    userDetails.email = emailnamecontroller.text;
                  });
                }
              },
              OnFirstButtonPressed: () {
                editMode == false
                    ? DeleteAccountDialouge(context)
                    : Navigator.pop(context);
              }),
        ],
      ),
    );
  }
}
