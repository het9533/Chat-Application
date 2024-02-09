import 'dart:io';
import 'package:chat_app/common/constants/color_constants.dart';
import 'package:chat_app/features/Presentation/Bloc/profile_page_bloc/profile_page_bloc.dart';
import 'package:chat_app/features/Presentation/Bloc/profile_page_bloc/profile_page_events.dart';
import 'package:chat_app/features/Presentation/Bloc/profile_page_bloc/profile_page_states.dart';
import 'package:chat_app/features/Presentation/pages/email_verification/account_success_screen.dart';
import 'package:chat_app/features/Presentation/widgets/booking_button.dart';
import 'package:chat_app/features/Presentation/widgets/customCircle_page.dart';
import 'package:chat_app/features/Presentation/widgets/custom_text_form_field.dart';
import 'package:chat_app/features/data/entity/user.dart';
import 'package:chat_app/features/dependencyInjector/injector.dart';
import 'package:chat_app/features/domain/usecase/firebase_firestore_usecase.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  final UserDetails userDetails;

  const ProfilePage({Key? key, required this.userDetails}) : super(key: key);

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
  TextEditingController phonenumbercontroller = TextEditingController();
  TextEditingController userNameController = TextEditingController();

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  final UserDetails userDetails;
  Uint8List? myImagePath;
  String? myImageName;
  final FirebaseFirestoreUseCase firebaseFirestoreUseCase =
      sl<FirebaseFirestoreUseCase>();

  _ProfilePageState({required this.userDetails});

  @override
  void initState() {
    initializeData();
    super.initState();
  }
  Widget _dialog(BuildContext context) {
    return AlertDialog(
      elevation: 0.0,
      backgroundColor: Colors.white,
      title: Column(
        children: [
          Lottie.asset('assets/lottie/invalid.json',repeat: false),
          SizedBox(height: 10,),
          Text("Username already exists", style: GoogleFonts.roboto(
            fontSize: 20,
            fontWeight: FontWeight.w500
          ),),
        ],
      ),
      actions: <Widget>[
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Okay"))
      ],
    );
  }

void _scaleDialog() {
    showGeneralDialog(
      context: context,
      pageBuilder: (ctx, a1, a2) {
        return Container();
      },
      transitionBuilder: (ctx, a1, a2, child) {
        var curve = Curves.easeInOut.transform(a1.value);
        return Transform.scale(
          scale: curve,
          child: _dialog(ctx),
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
    userDetails.imagepath = await imageUploadToFirebase(file);
    myImagePath = await imagePath.readAsBytes();
    myImageName = imagePath.name;

    return myImagePath!;
  }

  Future<String> imageUploadToFirebase(File image) async {
    FirebaseStorage storage = FirebaseStorage.instance;

    final StorageReference =
        storage.ref().child("UserProfile/user_${userDetails.email}");

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
    userNameController.text = userDetails.userName ?? "";
    firstnamecontroller.text = userDetails.firstName ?? "";
    emailnamecontroller.text = userDetails.email ?? "";
    lastnamecontroller.text = userDetails.lastName ?? "";
    phonenumbercontroller.text = userDetails.number ?? "";
    http.Response response =
        await http.get(Uri.parse(userDetails.imagepath ?? ""));
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
            if (userNameController.text == '') {
              userNameController.text = state.userDetails.userName!;
            } else {
              userNameController.text = userNameController.text;
            }
            if (firstnamecontroller.text == '') {
              firstnamecontroller.text = state.userDetails.firstName!;
            } else {
              firstnamecontroller.text = firstnamecontroller.text;
            }
            if (lastnamecontroller.text == '') {
              lastnamecontroller.text = state.userDetails.lastName!;
            } else {
              lastnamecontroller.text = lastnamecontroller.text;
            }
            if (emailnamecontroller.text == '') {
              emailnamecontroller.text = state.userDetails.email!;
            } else {
              emailnamecontroller.text = emailnamecontroller.text;
            }
            if (phonenumbercontroller.text == '') {
              phonenumbercontroller.text = state.userDetails.number!;
            } else {
              phonenumbercontroller.text = phonenumbercontroller.text;
            }
            setState(() {
              editMode = false;
            });
            if (state.doesUserNameUserExist) {
              _scaleDialog();
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
                        child: Column(
                          children: [
                            CustomTextFormField(
                              label: "UserName",
                              hint: "name@123",
                              controller: userNameController,
                              enabled: editMode ? true : false,
                            ),
                            SizedBox(height: 16),
                            CustomTextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'This field is required';
                                }
                                return null;
                              },
                              label: "First name",
                              hint: "First Name",
                              controller: firstnamecontroller,
                              enabled: editMode ? true : false,
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            CustomTextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'This field is required';
                                }
                                return null;
                              },
                              label: "Last name",
                              hint: "Last Name",
                              controller: lastnamecontroller,
                              enabled: editMode ? true : false,
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            CustomTextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'This field is required';
                                }
                                return null;
                              },
                              label: "Email",
                              hint: 'Email',
                              controller: emailnamecontroller,
                              enabled: false,
                            ),
                            SizedBox(
                              height: 16,
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
                              enabled: editMode ? true : false,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            RowBottomButtons(
              FirstButtonText: editMode ? "Delete Account" : "Finish",
              SecondButtonText: editMode ? "Save Changes" : "Edit Details",
              OnSecondButtonPressed: () async {
                if (editMode == false) {
                  setState(() {
                    editMode = true;
                  });
                } else {
                  final user = FirebaseAuth.instance.currentUser;
                  context.read<ProfilePageBloc>().add(SaveChangesEvent(
                      userDetails: UserDetails(
                          userName: userNameController.text,
                          userId: user != null ? user.uid : "",
                          email: emailnamecontroller.text,
                          firstName: firstnamecontroller.text,
                          lastName: lastnamecontroller.text,
                          imagepath: userDetails.imagepath,
                          number: phonenumbercontroller.text,
                          password: userDetails.password)));
                }
              },
              OnFirstButtonPressed: () {
                if (!editMode) {
                  context.read<ProfilePageBloc>().add(ContinueButtonEvent());
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
