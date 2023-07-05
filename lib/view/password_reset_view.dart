import 'package:flutter/material.dart';
import 'package:my_notes/components/logo.dart';
import 'package:my_notes/constants/colors.dart';
import 'package:my_notes/constants/routes.dart';
import 'package:my_notes/services/auth/auth_exceptions.dart';
import 'package:my_notes/services/auth/auth_service.dart';
import 'package:my_notes/utilities/dialogs/error_dialog.dart';
import 'package:my_notes/utilities/dialogs/password_reset_dialog.dart';

class PasswordResetView extends StatefulWidget {
  const PasswordResetView({super.key});

  @override
  State<PasswordResetView> createState() => _PasswordResetViewState();
}

class _PasswordResetViewState extends State<PasswordResetView> {
  late final TextEditingController _email;

  @override
  void initState() {
    _email = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              backgroundGradient1,
              backgroundGradient2,
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 80),
              const Icon(
                Icons.note_add,
                size: 100,
              ),
              const Logo(),
              Container(
                height: 280,
                width: 325,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 30),
                    const Text(
                      "Enter your email to reset password",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      //emial
                      width: 250,
                      child: TextField(
                        controller: _email,
                        enableSuggestions: false,
                        autocorrect: false,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          hintText: "Email",
                          hintStyle: TextStyle(color: Colors.black),
                          suffixIcon: Icon(Icons.mail),
                          suffixIconColor: Colors.black,
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    DecoratedBox(
                      //sign in
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            buttonGradient1,
                            buttonGradient2,
                          ],
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        boxShadow: <BoxShadow>[
                          BoxShadow(color: Colors.transparent),
                        ],
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(250, 50),
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          elevation: 0,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(50),
                            ),
                          ),
                        ),
                        onPressed: () async {
                          try {
                            await AuthService.firebase()
                                .sendPasswordResetEmail(email: _email.text);

                            if (!mounted) return;
                            await showPasswordResetDialog(context,
                                "Check your email to set new password");
                            if (!mounted) return;
                            Navigator.of(context).pushNamed(signInRoute);

                          } on UserNotFoundAuthException {
                            await showErrorDialog(
                              context,
                              "User does not exist",
                            );
                          } on InvalidEmailAuthException {
                            await showErrorDialog(
                              context,
                              "Invalid email",
                            );
                          } on GenericAuthException {
                            await showErrorDialog(
                              context,
                              "Unknown error",
                            );
                          }
                        },
                        child: const Text(
                          "Reset Password",
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(255, 197, 73, 1)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 35),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(signInRoute);
                      },
                      child: const Text(
                        "Return back",
                        style: TextStyle(color: darkYellow),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
