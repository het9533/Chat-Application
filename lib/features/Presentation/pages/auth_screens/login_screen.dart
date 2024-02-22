import 'package:chat_app/common/constants/color_constants.dart';
import 'package:chat_app/features/Presentation/Bloc/authbloc/authentication_bloc.dart';
import 'package:chat_app/features/Presentation/Bloc/authbloc/authentication_events.dart';
import 'package:chat_app/features/Presentation/Bloc/authbloc/authentication_states.dart';
import 'package:chat_app/features/Presentation/pages/auth_screens/signup_page.dart';
import 'package:chat_app/features/Presentation/pages/chat_screens/home_page.dart';
import 'package:chat_app/features/Presentation/pages/user_profile/profile_page.dart';
import 'package:chat_app/features/Presentation/widgets/custom_text_fields.dart';
import 'package:chat_app/features/Presentation/widgets/horizontal_or_line.dart';
import 'package:chat_app/features/data/entity/user.dart';
import 'package:chat_app/features/dependencyInjector/injector.dart';
import 'package:chat_app/features/domain/usecase/firebase_firestore_usecase.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {
  static const loginpage = 'LoginPage';

  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool agree = false;
  bool obSecureText = true;
  bool isLoginWithGoogle = false;
  bool userExist = false;

  final FirebaseFirestoreUseCase firebaseFirestoreUseCase =
      sl<FirebaseFirestoreUseCase>();
  final _formKey = GlobalKey<FormState>();

  Future<bool> checkUserExist() async {
    final user = FirebaseAuth.instance.currentUser!;
    userExist = await firebaseFirestoreUseCase.checkIfDocExists(user.uid);
    setState(() {});
    return userExist;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) {
            if (state is AuthenticationLoading) {
              Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is AuthenticationSuccess) {
              if (isLoginWithGoogle) {
                if (state.isUserExist) {
                  Navigator.pushNamed(context, ChatMainScreen.chatMainScreen);
                } else {
                  Navigator.pushNamed(context, ProfilePage.profilepage,
                      arguments: UserDetails(
                        signUpType: SignUpType.google,
                        email: state.user.email,
                        firstName: state.user.displayName,
                        imagepath: state.user.photoURL,
                        number: state.user.phoneNumber,
                      ));
                }
              }
              if (!isLoginWithGoogle) {
                Navigator.pushNamed(context, ChatMainScreen.chatMainScreen);
              }
            }
            if (state is AuthenticationFailure) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(state.error),
              ));
            }
          },
          child: Padding(
            padding: EdgeInsets.only(left: 20, right: 20, top: 70),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hi, Welcome Back!👋",
                  style: TextStyle(
                      color: ColorAssets.neomBlack2,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  "Hello again, you've been missed!",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 20,
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CustomTextFormField(
                        enabled: true,
                        label: "Email Address",
                        hint: "Email",
                        controller: emailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!RegExp(
                                  r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
                              .hasMatch(value)) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      CustomTextFormField(
                        enabled: true,
                        label: "Password",
                        hint: "password",
                        controller: passwordController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 24,
                          width: 24,
                          child: Checkbox(
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
                            'Remember Me',
                            style: TextStyle(
                                color: ColorAssets.neomBlack2,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
                          "Forgot Password",
                          style: TextStyle(
                            color: Colors.red,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: 50,
                  width: double.infinity,
                  child: FilledButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      backgroundColor:
                          MaterialStateProperty.all(ColorAssets.neomBlue),
                    ),
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false){
                         context.read<AuthenticationBloc>().add(
                          EmailSignInRequestedEvent(UserDetails(
                              signUpType: SignUpType.email,
                              email: emailController.text,
                              password: passwordController.text)));

                      setState(() {
                        isLoginWithGoogle = false;
                      });
                      }
                     
                    },
                    child: Text(
                      "Login",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                HorizontalOrLine(label: "Or Login With", height: 0),
                SizedBox(
                  height: 30,
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
                    onPressed: () async {
                      setState(() {
                        isLoginWithGoogle = true;
                      });

                      context
                          .read<AuthenticationBloc>()
                          .add(GoogleSignInRequestedEvent());
                    },
                    icon: Image.asset(
                      "assets/images/google_icon.png",
                      width: 20,
                    ),
                    label: Text("Login With Google"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: TextButton(
        onPressed: () {
          Navigator.pushNamed(context, SignUpPage.signuppage, arguments: {
            'firebaseFirestoreUseCase': firebaseFirestoreUseCase
          });
        },
        child: Text(
          "Don't have an account? Sign Up",
          style: TextStyle(
            color: ColorAssets.neomBlack2,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
