import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

void DeleteAccountDialouge(BuildContext context) {
  showCupertinoModalPopup(
    context: context,
    builder: (BuildContext context) => CupertinoAlertDialog(
      title: const Text('Alert'),
      content: const Text('Are you Sure you want to Delete your Account'),
      actions: <CupertinoDialogAction>[
        CupertinoDialogAction(
          isDefaultAction: true,
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('No'),
        ),
        CupertinoDialogAction(
          isDestructiveAction: true,
          onPressed: () async{
            SharedPreferences prefs = await SharedPreferences.getInstance();

                prefs.clear();
          },
          child: const Text('Yes'),
        ),
      ],
    ),
  );
}
