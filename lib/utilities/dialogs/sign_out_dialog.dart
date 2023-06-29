import 'package:flutter/material.dart';
import 'package:my_notes/utilities/dialogs/generic_dialog.dart';

Future<bool> showSignOutDialog(BuildContext context, String text) {
  return showGenericDialog<bool>(
    context: context,
    title: "Sign out",
    content: "Are you sure you want to sign out?",
    optionBuilder: () => {
      "Sign Out": true,
      "Close": false
    },
  ).then((value) => value ?? false);
}
