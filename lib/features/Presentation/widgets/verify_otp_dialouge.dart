import 'package:chat_app/common/constants/color_constants.dart';
import 'package:flutter/material.dart';

class verifyOtpDialouge extends StatelessWidget {
  

  const verifyOtpDialouge({
    super.key,
    required this.userNumber,
    required this.otpController,
    required this.otpVerified, required this.onCancelPressed,
    required this.onAcceptPressed,
  });

  final String userNumber;
  final TextEditingController otpController;
  final bool otpVerified;
  final void Function()? onCancelPressed;
  final void Function()? onAcceptPressed;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
          contentPadding: EdgeInsets.only(
            left: 24.0,
            top: 10,
            right: 24.0,
            bottom: 10.0,
          ),
          title: Text(
            'Verify Your Phone Number ',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          content: Text('${userNumber}'),
          actions: [
            TextFormField(
              controller: otpController,
              decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                        Radius.circular(10)),
                    borderSide: BorderSide(
                        color:
                            ColorAssets.neomBlack,
                        width: 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                        Radius.circular(10)),
                    borderSide: BorderSide(
                        color:
                            ColorAssets.neomBlack,
                        width: 1),
                  ),
                  disabledBorder:
                      OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                        Radius.circular(10)),
                    borderSide: BorderSide(
                        color:
                            ColorAssets.neomBlack,
                        width: 1),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                        Radius.circular(10)),
                    borderSide: BorderSide(
                        color:
                            ColorAssets.neomBlack,
                        width: 1),
                  ),
                  contentPadding: EdgeInsets.only(
                      left: 20,
                      right: 20,
                      top: 0,
                      bottom: 0),
                  hintText: 'OTP',
                  hintStyle: TextStyle(
                    color: Colors.grey,
                  )),
            ),
            Row(
              children: [
                TextButton(
                  onPressed: onCancelPressed,
                  child: Text('CANCEL'),
                ),
                TextButton(
                  onPressed: onAcceptPressed,
                  child: Text('ACCEPT'),
                ),
              ],
            )
          ],
        );
  }
}

    