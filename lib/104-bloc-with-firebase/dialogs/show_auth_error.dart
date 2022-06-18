import 'package:bloc_full_learn/104-bloc-with-firebase/dialogs/generic_dialog.dart';
import 'package:flutter/material.dart' show BuildContext;

import '../auth/auth_error.dart';

Future<void> showAuthErrorDialog({
  required AuthError error,
  required BuildContext context,
}) {
  return showGenericDialog<void>(
    context: context,
    title: error.dialogTitle,
    content: error.dialogDescription,
    optionBuilder: () => {
      'OK': true,
    },
  );
}
