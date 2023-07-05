import 'package:flutter/material.dart';
import 'package:my_notes/utilities/dialogs/generic_dialog.dart';

Future<void> showPasswordResetDialog(BuildContext context, String text) {
  return showGenericDialog<void>(
    context: context,
    title: "Password reset",
    content: text,
    optionBuilder: () => {
      "OK": null,
    },
  );
}