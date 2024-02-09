
import 'package:chat_app/common/constants/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextIconButton extends StatelessWidget {
  final IconData icon;

  final String text;

  AppTextIconButton({
    super.key,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      
      children: [
        Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
              color: ColorAssets.neomBlue, shape: BoxShape.circle),
          child: Icon(
            icon,
            color: Colors.white,
          ),
        ),
        SizedBox(
          width: 20,
        ),
        Text(
          text,
          style: GoogleFonts.roboto(
              fontSize: 20, color: Colors.black),
        )
      ],
    );
  }
}
