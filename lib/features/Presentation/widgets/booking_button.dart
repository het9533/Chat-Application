import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class rowBottomButtons extends StatelessWidget {
  final String FirstButtonText;
  final String SecondButtonText;
  final Function()? OnFirstButtonPressed;
  final Function()? OnSecondButtonPressed;



  const rowBottomButtons({
    required this.FirstButtonText,
    required this.SecondButtonText,
    this.OnFirstButtonPressed,
    this.OnSecondButtonPressed,
    
    
    super.key,
  });
  

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20,right: 20 , bottom: 7),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.7),
            offset: Offset(0, -20),
            blurRadius: 7.0,
            spreadRadius: 0.5,
          )
        ]
      ),
      width: double.infinity,
      height: 70,
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 50,
              child: ElevatedButton(
                  onPressed: OnFirstButtonPressed,
                  style: ButtonStyle(
                    elevation: MaterialStateProperty.all(0),
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                    side: MaterialStateProperty.all(BorderSide(
                      color: Color(0xffDDDDDD)
                    )),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                    
                  ),
                  
                  child: Text(
                    FirstButtonText,
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      color: Color(0xff1A1A1A),
                      fontWeight: FontWeight.w400,
                    ),
                  )),
            ),
          ),
              SizedBox(
                width: 12,
              ),
          Expanded(
            child: SizedBox(
              height: 50,
              child: ElevatedButton(
                  style: ButtonStyle(
                                    elevation: MaterialStateProperty.all(0),
              
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                    backgroundColor: MaterialStateProperty.all(Color(0xff1A1A1A)),
                  ),
                  onPressed:OnSecondButtonPressed,
                  child: Text(
                    SecondButtonText,
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                  )),
            ),
          ),
        ],
      ),
    );
  }
}