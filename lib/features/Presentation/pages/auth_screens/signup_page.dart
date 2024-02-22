import 'package:chat_app/common/constants/color_constants.dart';
import 'package:chat_app/features/Presentation/Bloc/authbloc/authentication_bloc.dart';
import 'package:chat_app/features/Presentation/Bloc/authbloc/authentication_events.dart';
import 'package:chat_app/features/Presentation/Bloc/authbloc/authentication_states.dart';
import 'package:chat_app/features/Presentation/Bloc/phone_authentication_bloc/phone_authentication_bloc.dart';
import 'package:chat_app/features/Presentation/Bloc/phone_authentication_bloc/phone_authentication_events.dart';
import 'package:chat_app/features/Presentation/Bloc/phone_authentication_bloc/phone_authentication_states.dart';
import 'package:chat_app/features/Presentation/Bloc/profile_page_bloc/profile_page_bloc.dart';
import 'package:chat_app/features/Presentation/Bloc/profile_page_bloc/profile_page_events.dart';
import 'package:chat_app/features/Presentation/Bloc/profile_page_bloc/profile_page_states.dart';
import 'package:chat_app/features/Presentation/pages/auth_screens/login_screen.dart';
import 'package:chat_app/features/Presentation/pages/chat_screens/home_page.dart';
import 'package:chat_app/features/Presentation/pages/email_verification/email_verification_screen.dart';
import 'package:chat_app/features/Presentation/pages/user_profile/profile_page.dart';
import 'package:chat_app/features/Presentation/widgets/custom_text_fields.dart';
import 'package:chat_app/features/Presentation/widgets/horizontal_or_line.dart';
import 'package:chat_app/features/data/entity/user.dart';
import 'package:chat_app/features/data/entity/user_session.dart';
import 'package:chat_app/features/dependencyInjector/injector.dart';
import 'package:chat_app/features/domain/usecase/firebase_firestore_usecase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:lottie/lottie.dart';

class SignUpPage extends StatefulWidget {
  static const signuppage = 'signuppage';

  final FirebaseFirestoreUseCase firebaseFirestoreUseCase;

  const SignUpPage({Key? key, required this.firebaseFirestoreUseCase})
      : super(key: key);

  @override
  State<SignUpPage> createState() =>
      _SignUpPageState(firebaseFirestoreUseCase: firebaseFirestoreUseCase);
}

class _SignUpPageState extends State<SignUpPage> {
  final FirebaseFirestoreUseCase firebaseFirestoreUseCase;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final TextEditingController firstNamecontroller = TextEditingController();
  final TextEditingController lastNamecontroller = TextEditingController();
  final TextEditingController UserNamecontroller = TextEditingController();
  final UserSession _userSession = sl<UserSession>();

  bool agree = false;
  bool obscureText = true;
  bool otpVerified = false;
  bool isClickedSignUpGoogle = false;
  bool isClicked = false;
  bool otpFieldVisibility = false;
  String receivedID = '';
  bool islogin = false;
  bool isvalidphoneNumber = true;
  FirebaseAuth auth = FirebaseAuth.instance;

  String userNumber = '';

  // Add a GlobalKey<FormState>
  final _formKey = GlobalKey<FormState>();

  _SignUpPageState({required this.firebaseFirestoreUseCase});
  Widget _dialog(BuildContext context) {
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
            "user already exists please Login",
            style:
                GoogleFonts.roboto(fontSize: 15, fontWeight: FontWeight.w500),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                isClicked = false;
              });
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

  Widget _UserNamedialog(BuildContext context) {
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
              Navigator.of(context).pop();
            },
            child: const Text("Okay"))
      ],
    );
  }

  void __UserNamescaleDialog() {
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

  final String defaultNetworkImage =
      'https://img.freepik.com/free-photo/3d-illustration-boy-with-camera-his-hand_1142-36694.jpg?w=740&t=st=1708339994~exp=1708340594~hmac=f6cb1c250478ec9e716e1dad64912b805dff54a8792436a8bfbd213939b773a8';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) {
            if (state is AuthenticationLoading) {
              showDialog(
                context: context,
                builder: (context) => Align(
                  alignment: Alignment.center,
                  child: Container(
                    color: Colors.white,
                    height: 50,
                    width: 50,
                    child: Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: ColorAssets.neomBlue,
                      ),
                    ),
                  ),
                ),
              );
            }
            if (state is AuthenticationSuccess) {
              if (isClickedSignUpGoogle) {
                var str = state.user.displayName!;
                List<String> list = str.split(" ");
                print(list[0]);
                print(list[1]);
                if (state.isUserExist) {
                  FirebaseFirestore.instance
                      .collection('users')
                      .doc(state.user.uid)
                      .get()
                      .then((value) {
                    return _userSession.userDetails = UserDetails.fromJson(
                        value.data() as Map<String, dynamic>);
                  });
                } else {
                  _userSession.userDetails = UserDetails(
                      signUpType: SignUpType.google,
                      userName: null,
                      userId: state.user.uid,
                      email: state.user.email,
                      firstName: list[0],
                      lastName: list[1],
                      imagepath: state.user.photoURL,
                      number: phoneController.text,
                      password: passwordController.text);
                }
               _userSession.userDetails != null ? context.read<ProfilePageBloc>().add(
                    SaveChangesEvent(userDetails: _userSession.userDetails!)) : null;
              } else {
                Future.delayed(Duration(seconds: 1));

                _userSession.userDetails = UserDetails(
                    signUpType: SignUpType.email,
                    userName: UserNamecontroller.text,
                    userId: state.user.uid,
                    email: emailController.text,
                    firstName: firstNamecontroller.text,
                    lastName: lastNamecontroller.text,
                    imagepath: defaultNetworkImage,
                    number: phoneController.text,
                    password: passwordController.text);
                context.read<ProfilePageBloc>().add(
                    SaveChangesEvent(userDetails: _userSession.userDetails!));
              }
            }

            if (state is AuthenticationFailure) {
              print("Authentication error ");
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.error)));
            }
          },
          child:
              BlocListener<PhoneAuthenticationBloc, PhoneAuthenticationState>(
            listener: (context, state) {
              if (state is PhoneAuthenticationLoading) {
                Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (state is PhoneNumberVerifiedState) {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    contentPadding: EdgeInsets.only(
                      left: 24.0,
                      top: 10,
                      right: 24.0,
                      bottom: 10.0,
                    ),
                    title: Text(
                      'Verify Your Phone Number ',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    content: Text('${userNumber}'),
                    actions: [
                      TextFormField(
                        controller: otpController,
                        decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(
                                  color: ColorAssets.neomBlack, width: 1),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(
                                  color: ColorAssets.neomBlack, width: 1),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(
                                  color: ColorAssets.neomBlack, width: 1),
                            ),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(
                                  color: ColorAssets.neomBlack, width: 1),
                            ),
                            contentPadding: EdgeInsets.only(
                                left: 20, right: 20, top: 0, bottom: 0),
                            hintText: 'OTP',
                            hintStyle: TextStyle(
                              color: Colors.grey,
                            )),
                      ),
                      Row(
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              context.read<PhoneAuthenticationBloc>().add(
                                  VerifyOTPCodeEvent(
                                      otpController.text, otpVerified));
                            },
                            child: Text('Submit'),
                          ),
                        ],
                      )
                    ],
                  ),
                );
              }
              if (state is PhoneAuthenticationSuccess) {
                context.read<AuthenticationBloc>().add(
                    EmailSignUpRequestedEvent(UserDetails(
                        signUpType: SignUpType.email,
                        imagepath: defaultNetworkImage,
                        userName: UserNamecontroller.text,
                        firstName: firstNamecontroller.text,
                        lastName: lastNamecontroller.text,
                        email: emailController.text,
                        number: phoneController.text,
                        password: passwordController.text)));

                setState(() {
                  isClickedSignUpGoogle = false;
                });
                otpVerified = true;
                print("phone auth  Success");
              }

              if (state is PhoneAuthenticationFailure) {
                print("phoneAuthentication error ");
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.error.toString())));
              }
            },
            child: BlocListener<ProfilePageBloc, ProfilePageState>(
              listener: (context, state) {
                if (state is ChangesSavedState) {
                  final bool isEmailVerified =
                      FirebaseAuth.instance.currentUser!.emailVerified;
                  print(isEmailVerified);
                  if (isEmailVerified) {
                    _userSession.userDetails!.userName != null
                        ? Navigator.pushNamed(
                            context, ChatMainScreen.chatMainScreen)
                        : Navigator.pushNamed(context, ProfilePage.profilepage);
                  } else {
                    Navigator.pushNamed(
                        context, VerifyEmailScreen.verifyemailscreen);
                  }
                }
              },
              child: Padding(
                padding: EdgeInsets.only(left: 20, right: 20, top: 70),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Create Account",
                        style: TextStyle(
                            color: ColorAssets.neomBlack2,
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        "Connect with your friends today!",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Column(
                        children: [
                          CustomTextFormField(
                            enabled: true,
                            label: "Username",
                            hint: "Username",
                            controller: UserNamecontroller,
                            // Add First Name validator
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your Username';
                              }

                              return null;
                            },
                          ),
                          SizedBox(height: 10),
                          CustomTextFormField(
                            enabled: true,
                            label: "Email Address",
                            hint: "Email",
                            controller: emailController,
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
                          SizedBox(height: 10),
                          CustomTextFormField(
                            enabled: true,
                            label: "First Name",
                            hint: "First Name",
                            controller: firstNamecontroller,
                            // Add First Name validator
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your First Name';
                              }

                              return null;
                            },
                          ),
                          SizedBox(height: 10),
                          CustomTextFormField(
                            enabled: true,
                            label: "Last Name",
                            hint: "Last Name",
                            controller: lastNamecontroller,
                            // Add email validator
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your Last Name';
                              }

                              return null;
                            },
                          ),
                          SizedBox(height: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Mobile Number",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 10),
                              Container(
                                child: IntlPhoneField(
                                  controller: phoneController,
                                  keyboardType: TextInputType.phone,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  onSubmitted: (String) {
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                  },
                                  onChanged: (val) {
                                    userNumber = val.completeNumber;
                                  },
                                  initialCountryCode: 'IN',
                                  initialValue: '+91',
                                  decoration: InputDecoration(
                                    fillColor: Colors.white,
                                    filled: true,
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      borderSide: BorderSide(
                                          color: Colors.black, width: 1),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      borderSide: BorderSide(
                                          color: Colors.black, width: 1),
                                    ),
                                    disabledBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      borderSide: BorderSide(
                                          color: Colors.black, width: 1),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      borderSide: BorderSide(
                                          color: Colors.black, width: 1),
                                    ),
                                    hintText: "Mobile Number",
                                    contentPadding: EdgeInsets.only(
                                        left: 10,
                                        right: 10,
                                        top: 10,
                                        bottom: 10),
                                    hintStyle: TextStyle(
                                      color: Colors.grey.shade400,
                                    ),
                                  ),
                                  validator: (value) {
                                    if (!RegExp(r'^(?:[+0]9)?[0-9]{6,14}$')
                                        .hasMatch(value!.completeNumber)) {
                                      setState(() {
                                        isvalidphoneNumber = false;
                                      });
                                      return 'Please enter Number';
                                    }
                                    if (value.completeNumber.isEmpty ||
                                        !value.isValidNumber()) {
                                      setState(() {
                                        isvalidphoneNumber = false;
                                      });
                                      return 'Phone number is required';
                                    }
                                    if (!value.isValidNumber()) {
                                      setState(() {
                                        isvalidphoneNumber = false;
                                      });
                                      return 'Please enter a valid phone number';
                                    }
                                    setState(() {
                                      isvalidphoneNumber = true;
                                    });
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                          CustomTextFormField(
                            enabled: true,
                            obscureText: obscureText,
                            suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    obscureText = !obscureText;
                                  });
                                },
                                icon: Icon(Icons.remove_red_eye)),
                            label: "Password",
                            hint: "Password",
                            controller: passwordController,
                            // Add password validator
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              if (value.length < 8) {
                                return 'Password must be at least 8 characters long';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 24,
                            width: 24,
                            child: Checkbox(
                              isError: true,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              value: agree,
                              onChanged: (value) {
                                setState(() {
                                  agree = value ?? false;
                                });
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: Text(
                              'I agree to the terms and conditions',
                              style: TextStyle(
                                  color: ColorAssets.neomBlack2,
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        onTap: () async {
                          if ((_formKey.currentState?.validate() ?? false) &&
                              isvalidphoneNumber) {
                            setState(() {
                              isClicked = true;
                            });
                            await Future.delayed(Duration(milliseconds: 300));
                            // verify phone number
                            final bool userExist =
                                await firebaseFirestoreUseCase
                                    .doesUserEmailExist(emailController.text);

                            final bool userNameExist =
                                await firebaseFirestoreUseCase
                                    .doesUserNameUserExist(
                                        UserNamecontroller.text, '');
                            if (userExist) {
                              _scaleDialog();
                            } else {
                              userNameExist
                                  ? __UserNamescaleDialog()
                                  : context
                                      .read<PhoneAuthenticationBloc>()
                                      .add(VerifyPhoneNumberEvent(userNumber));
                            }
                            setState(() {
                              isClicked = false;
                            });

                            // verify otp
                          }
                        },
                        child: Align(
                          alignment: Alignment.center,
                          child: AnimatedContainer(
                            alignment: Alignment.center,
                            duration: Duration(milliseconds: 400),
                            decoration: BoxDecoration(
                                color: ColorAssets.neomBlue,
                                borderRadius:
                                    BorderRadius.circular(isClicked ? 10 : 10)),
                            height: 50,
                            width: MediaQuery.of(context).size.width,
                            child: isClicked
                                ? Align(
                                    child: SizedBox(
                                    height: 25,
                                    width: 25,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      color: Colors.white,
                                    ),
                                  ))
                                : Text(
                                    "Sign Up",
                                    style: TextStyle(
                                        color: ColorAssets.neomWhite,
                                        fontSize: 15),
                                  ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      HorizontalOrLine(label: "Or Sign Up With", height: 0),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        height: 50,
                        width: double.infinity,
                        child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                isClickedSignUpGoogle = true;
                              });
                              context
                                  .read<AuthenticationBloc>()
                                  .add(GoogleSignInRequestedEvent());
                            },
                            icon: Image.asset(
                              "assets/images/google_icon.png",
                              width: 20,
                            ),
                            label: Text("Sign Up With Google")),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      if (!isClickedSignUpGoogle)
                        Align(
                          alignment: Alignment.center,
                          child: TextButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, LoginPage.loginpage);
                              },
                              child: Text(
                                "Already have an account? Login",
                                style: TextStyle(
                                  color: ColorAssets.neomBlack2,
                                ),
                                textAlign: TextAlign.center,
                              )),
                        )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
