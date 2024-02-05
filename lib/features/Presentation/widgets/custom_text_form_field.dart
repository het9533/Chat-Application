
import 'package:chat_app/common/constants/color_constants.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final bool enabled;
  final bool filled;
  final String? Function(String?)? validator;

  const CustomTextFormField({
    this.filled = false,
    this.enabled = false,
    required this.label,
    required this.hint,
    required this.controller,
    super.key, this.validator,
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
          validator: validator,
          enabled: enabled,
          controller: controller,
          style: Theme.of(context)
              .primaryTextTheme
              .bodyMedium
              ?.copyWith(
                color: Color(0xff777777),
                fontWeight: FontWeight.w500),
          decoration:InputDecoration(
            
            focusedBorder: OutlineInputBorder(
              borderRadius:
                    BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(
                color: enabled ? ColorAssets.kblackcolor : Colors.transparent,
                width: 1
              ),

            ), 
            enabledBorder: OutlineInputBorder(
              borderRadius:
                    BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(
                color: ColorAssets.klightgrey,
                width: 2
              ),
              
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius:
                    BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(
                color: ColorAssets.klightgrey,
                width: 2
              ),
              
            ),
            border: OutlineInputBorder(
              borderRadius:
                    BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(
                color: ColorAssets.klightgrey,
                width: 2
              ),
              
            ),
            hintText: hint,
            fillColor: ColorAssets.klightgrey,
            filled: !enabled,
            hintStyle: Theme.of(context)
              .primaryTextTheme
              .bodyMedium
              ?.copyWith(
                color: Color(0xff777777),
                fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}
