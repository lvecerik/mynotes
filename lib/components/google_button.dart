import 'package:flutter/material.dart';
import 'package:my_notes/constants/routes.dart';
import 'package:my_notes/services/auth/google_auth.dart';

class GoogleButton extends StatelessWidget {
  const GoogleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(250, 50),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(50),
          ),
        ),
      ).merge(
        ButtonStyle(
          overlayColor: MaterialStateProperty.all<Color>(Colors.transparent),
        ),
      ),
      onPressed: () async {
        await GoogleAuthService().signInWithGoogle();
        if (context.mounted) {
          Navigator.of(context)
              .pushNamedAndRemoveUntil(notesRoute, (route) => false);
        }
      },
      icon: Image.asset("assets/images/google_icon.png"),
      label: const Text(
        "Continue with Google",
        style: TextStyle(fontSize: 17, color: Colors.black),
      ),
    );
  }
}
