import 'package:chat_app/common/constants/color_constants.dart';
import 'package:chat_app/features/Presentation/Bloc/profile_page_bloc/profile_page_bloc.dart';
import 'package:chat_app/features/Presentation/Bloc/profile_page_bloc/profile_page_events.dart';
import 'package:chat_app/features/Presentation/Bloc/profile_page_bloc/profile_page_states.dart';
import 'package:chat_app/features/Presentation/pages/chat_screens/home_page.dart';
import 'package:chat_app/features/Presentation/pages/email_verification/account_success_screen.dart';
import 'package:chat_app/features/Presentation/widgets/booking_button.dart';
import 'package:chat_app/features/Presentation/widgets/custom_text_fields.dart';
import 'package:chat_app/features/data/entity/user.dart';
import 'package:chat_app/features/data/entity/user_session.dart';
import 'package:chat_app/features/dependencyInjector/injector.dart';
import 'package:chat_app/features/domain/usecase/firebase_firestore_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class ProfilePage extends StatefulWidget {
  static const profilepage = 'profilepage';

  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
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
    Uint8List? imageFile;
      final ImagePicker image = ImagePicker();
  XFile? imagepath;
  final UserSession _userSession = sl<UserSession>();
  final FirebaseFirestoreUseCase firebaseFirestoreUseCase =
      sl<FirebaseFirestoreUseCase>();
  final _formKey = GlobalKey<FormState>();
  final String defaultNetworkImage =
      'https://img.freepik.com/free-photo/3d-illustration-boy-with-camera-his-hand_1142-36694.jpg?w=740&t=st=1708339994~exp=1708340594~hmac=f6cb1c250478ec9e716e1dad64912b805dff54a8792436a8bfbd213939b773a8';


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
    imageFile = response.bodyBytes;

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
             
            if(_userSession.userDetails?.userName != userNameController.text){
              _scaleDialog(context);
            }
             
              
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
                     Center(
                            child: Hero(
                              tag: 'Profile',
                              child: Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(80),
                                  color: Colors.transparent,
                                ),
                                alignment: Alignment.center,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    if (imageFile != null)
                                      Container(
                                        height: 120,
                                        width: 120,
                                        clipBehavior: Clip.hardEdge,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                        ),
                                        child: Image(
                                          image: MemoryImage(imageFile!),
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    else if (_userSession.userDetails?.imagepath !=
                                        null)
                                      Container(
                                        height: 120,
                                        width: 120,
                                        clipBehavior: Clip.hardEdge,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                        ),
                                        child: Image(
                                          image: NetworkImage(
                                              _userSession.userDetails!.imagepath!),
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    else
                                      const Icon(
                                        CupertinoIcons.profile_circled,
                                        color: Colors.grey,
                                        size: 120,
                                      ),
                                    if (editMode)
                                      InkWell(
                                        onTap: () async {
                                          imagepath = await image.pickImage(
                                              source: ImageSource.gallery);

                                          if (imagepath == null) return;
                                          imageFile =
                                              await imagepath!.readAsBytes();
                                          setState(() {});
                                        },
                                        child: Container(
                                          height: 40,
                                          width: 40,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            color: Colors.transparent
                                                .withOpacity(0.5),
                                          ),
                                          alignment: Alignment.center,
                                          child:SvgPicture.asset(
                                            "assets/images/edit.svg",
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
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
                              enabled: editMode? userNameController.text.isEmpty ? true : false : false,
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
                    if (_userSession.userDetails?.signUpType == SignUpType.google) {
                      _userSession.userDetails = UserDetails(
                        signUpType: SignUpType.google,
                        userName: userNameController.text,
                        userId: _userSession.userDetails?.userId,
                        email: emailnamecontroller.text,
                        firstName: firstnamecontroller.text,
                        lastName: lastnamecontroller.text,
                        imagepath: _userSession.userDetails?.imagepath ??
                            defaultNetworkImage,
                        number: phonenumbercontroller.text,
                        password: _userSession.userDetails?.password);
                    }else{
                       _userSession.userDetails = UserDetails(
                        signUpType: SignUpType.email,
                        userName: userNameController.text,
                        userId: _userSession.userDetails?.userId,
                        email: emailnamecontroller.text,
                        firstName: firstnamecontroller.text,
                        lastName: lastnamecontroller.text,
                        imagepath: _userSession.userDetails?.imagepath ??
                            defaultNetworkImage,
                        number: phonenumbercontroller.text,
                        password: _userSession.userDetails?.password);
                    }

                    context.read<ProfilePageBloc>().add(SaveChangesEvent(
                        userDetails: _userSession.userDetails!, image: imagepath));
                  } else {

                  }
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
