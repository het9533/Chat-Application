import 'package:chat_app/common/constants/color_constants.dart';
import 'package:chat_app/common/constants/routes.dart';
import 'package:chat_app/features/Presentation/Bloc/authbloc/authentication_bloc.dart';
import 'package:chat_app/features/Presentation/Bloc/authbloc/authentication_events.dart';
import 'package:chat_app/features/Presentation/Bloc/authbloc/authentication_states.dart';
import 'package:chat_app/features/Presentation/Bloc/phone_authentication_bloc/phone_authentication_bloc.dart';
import 'package:chat_app/features/Presentation/Bloc/phone_authentication_bloc/phone_authentication_events.dart';
import 'package:chat_app/features/Presentation/Bloc/phone_authentication_bloc/phone_authentication_states.dart';
import 'package:chat_app/features/Presentation/widgets/custom_phone_feild.dart';
import 'package:chat_app/features/Presentation/widgets/custom_text_fields.dart';
import 'package:chat_app/features/Presentation/widgets/horizontal_or_line.dart';
import 'package:chat_app/features/data/entity/user.dart';
import 'package:chat_app/features/domain/usecase/firebase_firestore_usecase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpPage extends StatefulWidget {
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
  bool agree = false;
  bool obscureText = true;
  bool otpVerified = false;
  bool isClickedSignUpGoogle = false;

  var otpFieldVisibility = false;
  var receivedID = '';
  bool islogin = false;
  FirebaseAuth auth = FirebaseAuth.instance;

  String userNumber = '';

  // Add a GlobalKey<FormState>
  final _formKey = GlobalKey<FormState>();

  _SignUpPageState({required this.firebaseFirestoreUseCase});

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
          
             if (isClickedSignUpGoogle) {
                  Future.delayed(Duration(seconds: 1));
                Navigator.pushNamed(context, UserProfileScreenRoute ,arguments: {
                  UserDetails(
                  displayName: state.user.displayName,
                  email: state.user.email,
                  imagepath: state.user.photoURL,
                  number: state.user.phoneNumber
                )});
             }
             if (!isClickedSignUpGoogle) {
                  Future.delayed(Duration(seconds: 1));
                Navigator.pushNamed(context, VerifyEmailScreenRoute, arguments: {
                  firebaseFirestoreUseCase
                });
             }
              }
          
            if (state is AuthenticationFailure) {
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
              if (state is PhoneAuthenticationSuccess) {
                otpVerified = true;
                print("phone auth  Success");
              }
              if (state is PhoneAuthenticationFailure) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(state.error)));
              }
            },
            child: Padding(
              padding: EdgeInsets.only(left: 20, right: 20, top: 70),
              child: Form(
                // Wrap with Form and provide the key
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
                      height: 50,
                    ),
                    Column(
                      children: [
                        CustomTextFormField(
                          label: "Email Address",
                          hint: "Enter your email",
                          controller: emailController,
                          // Add email validator
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
                        CustomPhoneFeild(
                          isEnabled: otpVerified,
                          label: "Mobile Number",
                          hint: "Enter your mobile number",
                          controller: phoneController,
                          onChanged: (val) {
                            userNumber = val.completeNumber;
                          },
                          onsubmitted: (String) {
                            if (otpFieldVisibility) {
                              print(
                                  "phone number is : ${phoneController.text}");
                              context.read<PhoneAuthenticationBloc>().add(
                                  VerifyOTPCodeEvent(
                                      otpController.text, otpVerified));
                            } else {
                              context
                                  .read<PhoneAuthenticationBloc>()
                                  .add(VerifyPhoneNumberEvent(userNumber));
                              setState(() {
                                otpFieldVisibility = true;
                              });
                            }
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Visibility(
                          visible: otpFieldVisibility,
                          child: TextFormField(
                            onFieldSubmitted: (value) {
                              context.read<PhoneAuthenticationBloc>().add(
                                  VerifyOTPCodeEvent(
                                      otpController.text, otpVerified));
                            },
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
                        ),
                        SizedBox(height: 20),
                        CustomTextFormField(
                          label: "Password",
                          hint: "Enter your password",
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
                    SizedBox(height: 20),
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
                    Container(
                      height: 50,
                      width: double.infinity,
                      child: FilledButton(
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10))),
                              backgroundColor: MaterialStateProperty.all(
                                  ColorAssets.neomGold)),
                          onPressed: () async {
                            // Validate the form before submitting
                            if (_formKey.currentState?.validate() ?? false) {
                              context.read<AuthenticationBloc>().add(
                                  EmailSignUpRequestedEvent(UserDetails(
                                      displayName: '',
                                      email: emailController.text,
                                      number: phoneController.text,
                                      password: passwordController.text)));
                            }

                            setState(() {
                                isClickedSignUpGoogle = false;
                              }); 
                          },
                          child: Text(
                            "Sign Up",
                            style: TextStyle(
                                color: ColorAssets.neomBlack2, fontSize: 15),
                          )),
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
                            onPressed: () async {
                              context
                                  .read<AuthenticationBloc>()
                                  .add(GoogleSignInRequestedEvent());


                              setState(() {
                                isClickedSignUpGoogle = true;
                              });    
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
                              Navigator.pushNamed(context, LoginPageRoute);
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
    );
  }
}
