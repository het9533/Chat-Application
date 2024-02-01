import 'package:chat_app/common/constants/color_constants.dart';
import 'package:chat_app/common/constants/routes.dart';
import 'package:chat_app/features/Presentation/Bloc/authbloc/authentication_bloc.dart';
import 'package:chat_app/features/Presentation/Bloc/authbloc/authentication_events.dart';
import 'package:chat_app/features/Presentation/Bloc/authbloc/authentication_states.dart';
import 'package:chat_app/features/Presentation/widgets/custom_phone_feild.dart';
import 'package:chat_app/features/Presentation/widgets/custom_text_fields.dart';
import 'package:chat_app/features/Presentation/widgets/horizontal_or_line.dart';
import 'package:chat_app/features/data/entity/user.dart';
import 'package:chat_app/features/domain/usecase/firebase_firestore_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpPage extends StatefulWidget {
  final FirebaseFirestoreUseCase firebaseFirestoreUseCase;

  const SignUpPage({super.key, required this.firebaseFirestoreUseCase});

  @override
  State<SignUpPage> createState() =>
      _SignUpPageState(firebaseFirestoreUseCase: firebaseFirestoreUseCase);
}

class _SignUpPageState extends State<SignUpPage> {
  final FirebaseFirestoreUseCase firebaseFirestoreUseCase;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool agree = false;
  bool obscureText = true;

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
            firebaseFirestoreUseCase.addUser(UserDetails(
                displayName: '',
                email: emailController.text,
                number: phoneController.text,
                password: passwordController.text));
            Future.delayed(Duration(seconds: 1));

            Navigator.pushNamed(context, UserProfileScreenRoute,arguments: {
              state.user
            });
          }
          if (state is AuthenticationFailure) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.error)));
          }
        },
        child: Padding(
          padding: EdgeInsets.only(left: 20, right: 20, top: 70),
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
              Form(
                  child: Column(
                children: [
                  CustomTextFormField(
                    label: "Email Adress",
                    hint: "Enter your email",
                    controller: emailController,
                  ),
                  SizedBox(height: 20),
                  CustomPhoneFeild(
                      label: "Mobile Number",
                      hint: "Enter your mobile number",
                      controller: phoneController),
                  SizedBox(height: 20),
                  CustomTextFormField(
                      label: "Password",
                      hint: "Enter your password",
                      controller: passwordController),
                ],
              )),
              SizedBox(height: 20),
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
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                        backgroundColor:
                            MaterialStateProperty.all(ColorAssets.neomGold)),
                    onPressed: () async {
                      context.read<AuthenticationBloc>().add(
                          EmailSignUpRequestedEvent(UserDetails(
                              displayName: '',
                              email: emailController.text,
                              number: phoneController.text,
                              password: passwordController.text)));
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
                    onPressed: () {
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
    ));
  }
}
