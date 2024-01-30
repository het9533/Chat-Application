import 'package:flutter/material.dart';

class HorizontalOrLine extends StatelessWidget {
    final String label;
  final double height;

  const HorizontalOrLine({
    required this.label,
    required this.height,
  });



  @override
  Widget build(BuildContext context) {

    return Row(children: <Widget>[
      Expanded(
        child: new Container(
            margin: const EdgeInsets.only(left: 10.0, right: 15.0),
            child: Divider(
              color: Colors.grey,
              height: height,
            )),
      ),

      Text(label, style: TextStyle(
        fontWeight: FontWeight.w600
      ),),

      Expanded(
        child: new Container(
            margin: const EdgeInsets.only(left: 15.0, right: 10.0),
            child: Divider(
              color: Colors.grey,
              height: height,
            )),
      ),
    ]);
  }
}
