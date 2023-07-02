import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_notes/constants/routes.dart';

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
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromRGBO(255, 147, 15, 1),
                Color.fromRGBO(255, 249, 91, 1)
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
              const Text("MyNotes", style: TextStyle(
                fontSize: 30,
              ),),
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
                    const SizedBox(height: 30),
                    const Text(
                      "Enter email to reset your password",
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
                            Color.fromARGB(237, 0, 0, 0),
                            Color.fromARGB(185, 0, 0, 0)
                            // Color.fromRGBO(255, 147, 15, 1),
                            // Color.fromRGBO(255, 249, 91, 1),
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
                        onPressed: () {
                          FirebaseAuth.instance
                              .sendPasswordResetEmail(email: _email.text);
                          Navigator.of(context).pushNamed(signInRoute);
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
  }
}
