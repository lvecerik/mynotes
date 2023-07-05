import 'package:flutter/material.dart';
import 'package:my_notes/constants/colors.dart';

typedef DialogOptionBuilder<T> = Map<String, T?> Function();

Future<T?> showGenericDialog<T>({
  required BuildContext context,
  required String title,
  required String content,
  required DialogOptionBuilder optionBuilder,
}) {
  final options = optionBuilder();
  return showDialog<T>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: darkYellow),),
          content: Text(content),
          actions: options.keys.map((optionTitle) {
            final value = options[optionTitle];
            return TextButton(
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(appleWhite),
              overlayColor: MaterialStateProperty.all<Color>(emphasisColor)
              ),
              onPressed: () {
                if (value != null) {
                  Navigator.of(context).pop(value);
                } else {
                  Navigator.of(context).pop();
                }
              },
              child: Text(optionTitle, style:const TextStyle(color: Colors.black),),
            );
          }).toList(),
        );
      });
}
