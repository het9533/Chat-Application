import 'package:chat_app/common/constants/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class CustomPhoneFeild extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;

  const CustomPhoneFeild({
  
    required this.label,
    required this.hint,
    required this.controller,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: ColorAssets.neomBlack2,
            fontWeight: FontWeight.bold
          ),
          
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          height: 50,
          child: IntlPhoneField(
            
            
            
            initialCountryCode: '+91',
            initialValue: '+91',
            invalidNumberMessage: "please Enter Valid PhoneNumber",
          
            disableLengthCheck: true,
            controller: controller,
            decoration:InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderRadius:
                      BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(
               color: ColorAssets.neomBlack,
                  width: 1
                ),
                
              ), 
              enabledBorder: OutlineInputBorder(
                borderRadius:
                      BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(
                  color: ColorAssets.neomBlack,
                  width: 1
                ),
                
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius:
                      BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(
                 color: ColorAssets.neomBlack,
                  width: 1
                ),
                
              ),
              border: OutlineInputBorder(
                borderRadius:
                      BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(
                 color: ColorAssets.neomBlack,
                  width: 1
                ),
                
              ),
              hintText: hint,
              contentPadding: EdgeInsets.only(left: 0, right: 0, top: 0 , bottom: 0),
              hintStyle: TextStyle(
                color: Colors.grey,
              )
            ),
          ),
        ),
      ],
    );
  }
}