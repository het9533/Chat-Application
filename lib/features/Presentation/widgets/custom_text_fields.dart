
import 'package:chat_app/common/constants/color_constants.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final String? Function(String?)? validator;
    final bool enabled;
  final bool filled;
  final Widget? suffixIcon;
  
  final bool obscureText;
 

  const CustomTextFormField({
    this.suffixIcon = null,
     this.label= '',
    required this.hint,
    required this.controller,
    super.key, required this.validator, this.obscureText = false, this.enabled = false, this.filled = false,
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
        TextFormField(
         enabled: enabled,
        style: enabled ? TextStyle(
          
            fontWeight: FontWeight.w500,
            color: Colors.black,
        ) : TextStyle(
            color: Colors.grey
        ),

        obscureText: obscureText,
         validator: validator ,
          controller: controller,
               decoration:InputDecoration(
                enabled: enabled,
                filled: true,
                fillColor: Colors.white,
            suffixIcon: suffixIcon,
            focusedBorder: OutlineInputBorder(
              borderRadius:
                    BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(
                color: ColorAssets.neomBlue,
                width: 1
              ),

            ), 
            enabledBorder: OutlineInputBorder(
              borderRadius:
                    BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(
                color: Colors.grey,
                width: 1
              ),
              
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius:
                    BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(
                color: Colors.grey,
                width: 1,
              ),
              
            ),
            border: OutlineInputBorder(
              borderRadius:
                    BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(
                color: Colors.grey,
                width: 1
              ),
              
            ),

              contentPadding: EdgeInsets.only(left: 20, right: 20, top: 0 , bottom: 0),
          
              hintText: hint,
              
              hintStyle: TextStyle(
                color: Colors.grey.shade400,
                
              )),
        ),
      ],
    );
  }
}
