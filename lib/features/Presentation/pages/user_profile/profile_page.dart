import 'dart:io';
import 'package:chat_app/common/constants/color_constants.dart';
import 'package:chat_app/features/Presentation/Bloc/profile_page_bloc/profile_page_bloc.dart';
import 'package:chat_app/features/Presentation/Bloc/profile_page_bloc/profile_page_events.dart';
import 'package:chat_app/features/Presentation/Bloc/profile_page_bloc/profile_page_states.dart';
import 'package:chat_app/features/Presentation/pages/chat_screens/home_page.dart';
import 'package:chat_app/features/Presentation/pages/email_verification/account_success_screen.dart';
import 'package:chat_app/features/Presentation/widgets/booking_button.dart';
import 'package:chat_app/features/Presentation/widgets/customCircle_page.dart';
import 'package:chat_app/features/Presentation/widgets/custom_text_fields.dart';
import 'package:chat_app/features/data/entity/user.dart';
import 'package:chat_app/features/data/entity/user_session.dart';
import 'package:chat_app/features/dependencyInjector/injector.dart';
import 'package:chat_app/features/domain/usecase/firebase_firestore_usecase.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class ProfilePage extends StatefulWidget {
  static const profilepage = 'profilepage';

  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  bool editMode = true;
  TextEditingController firstnamecontroller = TextEditingController();
  TextEditingController lastnamecontroller = TextEditingController();
  TextEditingController emailnamecontroller = TextEditingController();
  TextEditingController phonenumbercontroller = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  String? myImageName;
  Uint8List? myImagePath;
  final UserSession _userSession = sl<UserSession>();
  final FirebaseFirestoreUseCase firebaseFirestoreUseCase =
      sl<FirebaseFirestoreUseCase>();
  final _formKey = GlobalKey<FormState>();
  final String defaultNetworkImage =
      'https://img.freepik.com/free-photo/3d-illustration-boy-with-camera-his-hand_1142-36694.jpg?w=740&t=st=1708339994~exp=1708340594~hmac=f6cb1c250478ec9e716e1dad64912b805dff54a8792436a8bfbd213939b773a8';
  _ProfilePageState();

  @override
  void initState() {
    initializeData();
    super.initState();
  }

  Widget _dialog(context) {
    return AlertDialog(
      elevation: 0.0,
      backgroundColor: Colors.white,
      title: Column(
        children: [
          Lottie.asset('assets/lottie/invalid.json', repeat: false),
          SizedBox(
            height: 10,
          ),
          Text(
            "Username already exists",
            style:
                GoogleFonts.roboto(fontSize: 20, fontWeight: FontWeight.w500),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Okay"))
      ],
    );
  }

  void _scaleDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      pageBuilder: (context, a1, a2) {
        return Container();
      },
      transitionBuilder: (context, a1, a2, child) {
        var curve = Curves.easeInOut.transform(a1.value);
        return Transform.scale(
          scale: curve,
          child: _dialog(context),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  Future<void> pickImage(ImageSource source) async {
    try {
      final XFile? imagePath = await ImagePicker().pickImage(source: source);
      if (imagePath == null) return;
      final imagePermanent = await saveFilePermanently(imagePath);
      setState(() {
        this.myImagePath = imagePermanent;
      });
    } on PlatformException catch (e) {
      print("error $e");
    }
  }

  Future<Uint8List> saveFilePermanently(XFile imagePath) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File("${directory.path}/images/${imagePath.name}");
    await file.create(recursive: true);
    await file.writeAsBytes(await imagePath.readAsBytes());
    _userSession.userDetails?.imagepath = await imageUploadToFirebase(file);
    myImagePath = await imagePath.readAsBytes();
    myImageName = imagePath.name;

    return myImagePath!;
  }

  Future<String> imageUploadToFirebase(File image) async {
    FirebaseStorage storage = FirebaseStorage.instance;

    final StorageReference = storage
        .ref()
        .child("UserProfile/user_${_userSession.userDetails?.email}");

    final file = StorageReference.putFile(image);

    String imagePathUrl = await file.snapshot.ref.getDownloadURL();

    return imagePathUrl;
  }

  void DeleteAccountData() async {
    firstnamecontroller.text = "";
    lastnamecontroller.text = "";
    emailnamecontroller.text = "";
  }

  void initializeData() async {
    userNameController.text = _userSession.userDetails?.userName ?? "";
    firstnamecontroller.text = _userSession.userDetails?.firstName ?? "";
    emailnamecontroller.text = _userSession.userDetails?.email ?? "";
    lastnamecontroller.text = _userSession.userDetails?.lastName ?? "";
    if (_userSession.userDetails?.number == 'XXXXXXXXXX') {
      phonenumbercontroller.text = '';
    } else {
      phonenumbercontroller.text = _userSession.userDetails?.number ?? "";
    }
    http.Response response = await http.get(
        Uri.parse(_userSession.userDetails?.imagepath ?? defaultNetworkImage));
    myImagePath = response.bodyBytes;

    setState(() {});
  }

  // void DeleteAccountDialouge(BuildContext context) {
  //   showCupertinoModalPopup(
  //     context: context,
  //     builder: (BuildContext context) => CupertinoAlertDialog(
  //       title: const Text('Alert'),
  //       content: const Text('Are you Sure you want to Delete your Account'),
  //       actions: <CupertinoDialogAction>[
  //         CupertinoDialogAction(
  //           isDefaultAction: true,
  //           onPressed: () {
  //             Navigator.pop(context);
  //           },
  //           child: const Text('No'),
  //         ),
  //         CupertinoDialogAction(
  //           isDestructiveAction: true,
  //           onPressed: () async {
  //             SharedPreferences prefs = await SharedPreferences.getInstance();
  //             DeleteAccountData();
  //             setState(() {
  //               prefs.clear();
  //             });
  //             await Future.delayed(Duration(seconds: 1));
  //             Navigator.pop(context);
  //           },
  //           child: const Text('Yes'),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorAssets.neomCream,
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        elevation: 0.0,
        backgroundColor: ColorAssets.neomCream,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            CupertinoIcons.arrow_left,
            size: 30,
          ),
        ),
        title: Text(
          editMode ? "Edit Profile" : "Profile",
        ),
        centerTitle: true,
      ),
      body: BlocListener<ProfilePageBloc, ProfilePageState>(
        listener: (context, state) {
          if (state is ProfilePageInitial) {}
          if (state is ProfileLoadingState) {
            Center(child: CircularProgressIndicator());
          }
          if (state is ProfileLoadedState) {}
          if (state is ProfileErrorState) {}
          if (state is EditingModeEnabledState) {
            setState(() {
              editMode = state.editMode;
            });
          }
          if (state is EditingModeDisabledState) {
            setState(() {
              editMode = state.editMode;
            });
          }
          if (state is ChangesSavedState) {
            if (phonenumbercontroller.text == '') {
              phonenumbercontroller.text = state.userDetails.number!;
            } else {
              phonenumbercontroller.text = phonenumbercontroller.text;
            }
            setState(() {
              editMode = false;
            });
            if (state.doesUserNameUserExist) {
              _scaleDialog(context);
            }
          }
          if (state is ContinueButtonState) {
            if (phonenumbercontroller.text == '') {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Phone number is required'),
                  duration: Duration(seconds: 2),
                ),
              );
              return;
            } else {
              Navigator.pushNamed(context,
                  AccountCreatedSuccessScreen.accountCreatedSuccessScreen);
            }
          }
        },
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
                  child: Column(
                    children: [
                      if (myImagePath != null)
                        Container(
                          height: 150,
                          width: 150,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: MemoryImage(myImagePath!),
                              fit: BoxFit.cover,
                            ),
                            shape: BoxShape.circle,
                            border: Border.all(width: 1.5, color: Colors.black),
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
                                        pickImage(ImageSource.gallery);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(15),
                                        child: SvgPicture.asset(
                                          "assets/images/edit.svg",
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : null,
                        )
                      else
                        Container(
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
                                          pickImage(ImageSource.gallery);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(15),
                                          child: SvgPicture.asset(
                                            "assets/images/edit.svg",
                                          ),
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
                        key: _formKey,
                        child: Column(
                          children: [
                            CustomTextFormField(
                              enabled: editMode ? true : false,
                              label: "Username",
                              hint: "Username",
                              controller: userNameController,
                              // Add First Name validator
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your Username';
                                }

                                return null;
                              },
                            ),
                            SizedBox(height: 20),
                            CustomTextFormField(
                              enabled: editMode ? true : false,
                              label: "First Name",
                              hint: "First Name",
                              controller: firstnamecontroller,
                              // Add First Name validator
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your First Name';
                                }

                                return null;
                              },
                            ),
                            SizedBox(height: 20),
                            CustomTextFormField(
                              enabled: editMode ? true : false,
                              label: "Last Name",
                              hint: "Last Name",
                              controller: lastnamecontroller,
                              // Add email validator
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your Last Name';
                                }

                                return null;
                              },
                            ),
                            SizedBox(height: 20),
                            CustomTextFormField(
                              enabled: false,
                              label: "Email Address",
                              hint: "Email",
                              controller: emailnamecontroller,
                              // Add email validator
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your Email';
                                }
                                if (!RegExp(
                                        r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
                                    .hasMatch(value)) {
                                  return 'Please enter a valid email address';
                                }
                                return null;
                              },
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            CustomTextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'This field is required';
                                }
                                return null;
                              },
                              label: "Phone Number",
                              hint: 'XXXXXXXXXX',
                              controller: phonenumbercontroller,
                              enabled: editMode
                                  ? (phonenumbercontroller.text != "" ||
                                          phonenumbercontroller.text !=
                                              'XXXXXXXXXX')
                                      ? true
                                      : false
                                  : false,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            RowBottomButtons(
              firstColorButton: Colors.white,
              secondColorButton: ColorAssets.neomBlue,
              FirstButtonText: editMode ? "Cancel" : "Done",
              SecondButtonText: editMode ? "Save Changes" : "Edit Details",
              OnSecondButtonPressed: () async {
                if (editMode == false) {
                  setState(() {
                    editMode = true;
                  });
                } else {
                  if ((_formKey.currentState?.validate() ?? false)) {
                    _userSession.userDetails = UserDetails(
                        userName: userNameController.text,
                        userId: _userSession.userDetails?.userId,
                        email: emailnamecontroller.text,
                        firstName: firstnamecontroller.text,
                        lastName: lastnamecontroller.text,
                        imagepath: _userSession.userDetails?.imagepath ??
                            defaultNetworkImage,
                        number: phonenumbercontroller.text,
                        password: _userSession.userDetails?.password);

                    context.read<ProfilePageBloc>().add(SaveChangesEvent(
                        userDetails: _userSession.userDetails!));
                  } else {}
                }
              },
              OnFirstButtonPressed: () {
                if (!editMode) {
                
                    Navigator.pushNamed(context, ChatMainScreen.chatMainScreen);
                 
                } else {
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
