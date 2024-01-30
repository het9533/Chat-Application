
import 'package:chat_app/common/constants/color_constants.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final bool? isSuffixIcon;
  final Icon? suffixIcon;
  final bool? obSecureText;
   final suffixOnTap;

  const CustomTextFormField({
    required this.label,
    required this.hint,
    required this.controller,
     this.isSuffixIcon = false,
     this.obSecureText = false,
    super.key,  required this.suffixIcon,  required this.suffixOnTap, 
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
              color: ColorAssets.neomBlack2, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          height: 50,
          child: TextFormField(
            obscureText: obSecureText!,
            controller: controller,
            decoration: InputDecoration(
              suffixIcon: isSuffixIcon! ? GestureDetector(
                onTap: suffixOnTap(),
                child: suffixIcon) : null,
            
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide:
                      BorderSide(color: ColorAssets.neomBlack, width: 1),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide:
                      BorderSide(color: ColorAssets.neomBlack, width: 1),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide:
                      BorderSide(color: ColorAssets.neomBlack, width: 1),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide:
                      BorderSide(color: ColorAssets.neomBlack, width: 1),
                ),
                contentPadding: EdgeInsets.only(left: 20, right: 20, top: 0 , bottom: 0),
                hintText: hint,
                
                hintStyle: TextStyle(
                  color: Colors.grey,
                  
                )),
          ),
        ),
      ],
    );
  }
}
