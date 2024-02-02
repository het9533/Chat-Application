import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class iconContainer extends StatelessWidget {
  final String imagepath;
  const iconContainer({
    required this.imagepath,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: Color(0xffDDDDDD)
        ),
        color: Color(0xffffffff),
        // color: Colors.red,
        borderRadius: BorderRadius.circular(5)
      ),
      child: SvgPicture.asset(imagepath),
    );
  }
}
