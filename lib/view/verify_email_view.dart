import 'package:flutter/material.dart';
import 'package:my_notes/constants/colors.dart';
import 'package:my_notes/constants/routes.dart';
import 'package:my_notes/services/auth/auth_service.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 80),
              const Icon(
                Icons.note_add,
                size: 100,
              ),
              const SizedBox(height: 15),
              const Text(
                "MyNotes",
                style: TextStyle(
                  fontSize: 30,
                ),
              ),
              const SizedBox(height: 50),
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
                    const SizedBox(height: 80),
                    const Text(
                      "Verification send, check your email.",
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "If you haven't received the verification email: ",
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        AuthService.firebase().sendEmailVerification();
                      },
                      child: const Text(
                        "Send email verfication",
                        style: TextStyle(
                          color: emphasisColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 50),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed(signInRoute);
                        },
                        child: const Text(
                          "Back to sign in page",
                          style: TextStyle(color: Colors.black),
                        ),
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

    // Widget build(BuildContext context) {
    //   return Scaffold(
    //     appBar: AppBar(
    //       title: const Text("Verify Email"),
    //     ),
    //     body: Column(
    //       children: [
    //         const Text("We have send you a verification on your email."),
    //         const Text(
    //             "If you have not recieved an email, please click the button below."),
    //         TextButton(
    //           onPressed: () async {
    //             AuthService.firebase().sendEmailVerification();
    //           },
    //           child: const Text("Send email verfication"),
    //         ),
    //         TextButton(
    //           onPressed: () async {
    //             await AuthService.firebase().signOut();
    //             if (!mounted) return;
    //             Navigator.of(context).pushNamedAndRemoveUntil(
    //               registerRoute,
    //               (route) => false,
    //             );
    //           },
    //           child: const Text("Register another account"),
    //         ),
    //       ],
    //     ),
    //   );
    // }
  }
}
