import 'package:flutter/material.dart';
import 'package:my_notes/utilities/dialogs/generic_dialog.dart';

Future<void> showCannotShareEmptyNoteDialog(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: "Share attempt",
    content: "You cannot share an empty note",
    optionBuilder: () => {
      "OK": null
    },
  );
}
