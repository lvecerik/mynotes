import 'package:flutter/material.dart';
import 'package:my_notes/components/email_textfields.dart';
import 'package:my_notes/components/google_button.dart';
import 'package:my_notes/components/logo.dart';
import 'package:my_notes/constants/colors.dart';
import 'package:my_notes/constants/routes.dart';
import 'package:my_notes/services/auth/auth_exceptions.dart';
import 'package:my_notes/services/auth/auth_service.dart';
import '../utilities/dialogs/error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  late bool _isObscured;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    _isObscured = true;
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
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
            colors: [backgroundGradient1, backgroundGradient2],
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
                height: 430,
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
                      "Welcome back!",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 20),
                    EmailTextField(controller: _email),
                    SizedBox(
                      width: 250,
                      child: TextField(
                        controller: _password,
                        obscureText: _isObscured,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: InputDecoration(
                          hintText: "Password",
                          hintStyle: const TextStyle(color: Colors.black),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _isObscured = !_isObscured;
                              });
                            },
                            icon: _isObscured
                                ? const Icon(Icons.visibility)
                                : const Icon(Icons.visibility_off),
                            color: Colors.black,
                          ),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 10, 30, 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  passwordResetRoute, (_) => false);
                            },
                            child: const Text(
                              "Forgot Password?",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    DecoratedBox(
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
                          final email = _email.text;
                          final password = _password.text;
                          try {
                            await AuthService.firebase().signIn(
                              email: email,
                              password: password,
                            );
                            final user = AuthService.firebase().currentUser;
                            if (!mounted) return;
                            if (user?.isEmailVerified ?? false) {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                notesRoute,
                                (route) => false,
                              );
                            } else {
                              Navigator.of(context).pushNamed(verifyRoute);
                            }
                          } on UserNotFoundAuthException {
                            await showErrorDialog(
                              context,
                              "User does not exist",
                            );
                          } on WrongPasswordAuthException {
                            await showErrorDialog(
                              context,
                              "Incorrect password",
                            );} on InvalidEmailAuthException {
                            await showErrorDialog(
                              context,
                              "Invalid email",
                            );
                          } on GenericAuthException {
                            await showErrorDialog(
                              context,
                              "Authentication error",
                            );
                          }
                        },
                        child: const Text(
                          "Sign in",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(255, 197, 73, 1)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    const GoogleButton(),
                    const SizedBox(height: 40),
                    Row(
                      
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("First time here?"),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                              registerRoute,
                              (_) => false,
                            );
                          },
                          child: const Text(
                            "Sign up",
                            style: TextStyle(
                              color: darkYellow,
                            ),
                          ),
                        )
                      ],
                    )
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
