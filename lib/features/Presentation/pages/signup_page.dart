import 'package:chat_app/common/constants/color_constants.dart';
import 'package:chat_app/features/Presentation/widgets/custom_phone_feild.dart';
import 'package:chat_app/features/Presentation/widgets/custom_text_fields.dart';
import 'package:chat_app/features/Presentation/widgets/horizontal_or_line.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool agree = false;
  bool obscureText = true;
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
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
                    suffixIcon: null,
                    suffixOnTap: null,
                    isSuffixIcon: null,
                    
                    
                    
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
                    suffixIcon: Icon(Icons.remove_red_eye),
                    isSuffixIcon: true,
                    obSecureText: obscureText,
                    suffixOnTap: (){
                      setState(() {
                        obscureText=!obscureText;
                      });
                    },
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
                        color: ColorAssets.neomBlack2, fontWeight: FontWeight.bold),
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
                  onPressed: () {},
                  child: Text(
                    "Sign Up",
                    style: TextStyle(color: ColorAssets.neomBlack2, fontSize: 15),
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
                  onPressed: () {},
                  icon: Image.asset("assets/images/google_icon.png",width: 20,),
                  
                  label: Text("Sign Up With Google")),
            ),
            SizedBox(
              height: 10,
            ),
             Align(
               alignment: Alignment.center,
               child: TextButton(
                   onPressed: () {},
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
        ));
  }
}
