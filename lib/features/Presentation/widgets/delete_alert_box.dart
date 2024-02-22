import 'package:flutter/cupertino.dart';

void DeleteAccountDialouge({required BuildContext context ,required VoidCallback onYesPressed ,required VoidCallback onNoPressed }) {
  showCupertinoModalPopup(
    context: context,
    builder: (BuildContext context) => CupertinoAlertDialog(
      title: const Text('Alert'),
      content: const Text('Are you sure you want to delete this message ?'),
      actions: <CupertinoDialogAction>[
        CupertinoDialogAction(
          isDefaultAction: true,
          onPressed: onNoPressed,
          child: const Text('No'),
        ),
        CupertinoDialogAction(
          isDestructiveAction: true,
          onPressed: onYesPressed,
          child: const Text('Yes'),
        ),
      ],
    ),
  );
}
