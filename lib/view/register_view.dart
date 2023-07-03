import 'package:flutter/material.dart';
import 'package:my_notes/components/google_button.dart';
import 'package:my_notes/components/my_textfields.dart';
import 'package:my_notes/constants/colors.dart';
import 'package:my_notes/constants/routes.dart';
import 'package:my_notes/services/auth/auth_exceptions.dart';
import 'package:my_notes/services/auth/auth_service.dart';
import 'package:my_notes/utilities/dialogs/error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final TextEditingController _confirmPassword;
  late bool _isPasswordObscured;
  late bool _isConfirmPasswordObscured;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    _confirmPassword = TextEditingController();
    _isPasswordObscured = true;
    _isConfirmPasswordObscured = true;
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _confirmPassword = TextEditingController();

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
              colors: [backgroundGradient1, backgroundGradient2],
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
                height: 480,
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
                      "Create an account",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 20),
                    EmailTextField(controller: _email),
                    SizedBox(
                      width: 250,
                      child: TextField(
                        controller: _password,
                        obscureText: _isPasswordObscured,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: InputDecoration(
                          hintText: "Password",
                          hintStyle: const TextStyle(color: Colors.black),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _isPasswordObscured = !_isPasswordObscured;
                              });
                            },
                            icon: _isPasswordObscured
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
                    SizedBox(
                      width: 250,
                      child: TextField(
                        controller: _confirmPassword,
                        obscureText: _isConfirmPasswordObscured,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: InputDecoration(
                          hintText: "Confirm password",
                          hintStyle: const TextStyle(color: Colors.black),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _isConfirmPasswordObscured =
                                    !_isConfirmPasswordObscured;
                              });
                            },
                            icon: _isConfirmPasswordObscured
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
                    const SizedBox(height: 20),
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
                          final confirmPassword = _confirmPassword.text;
                          try {
                            if (password == confirmPassword) {
                              await AuthService.firebase().createUser(
                                email: email,
                                password: password,
                              );
                              AuthService.firebase().sendEmailVerification();
                              if (!mounted) return;
                              Navigator.of(context).pushNamed(verifyRoute);
                            } else {
                              await showErrorDialog(
                                  context, "Password does not match");
                            }
                          } on WeakPasswordAuthException {
                            await showErrorDialog(
                              context,
                              "Password has to be at least 6 characters",
                            );
                          } on EmailAlreadyInUsedAuthException {
                            await showErrorDialog(
                              context,
                              "Email taken",
                            );
                          } on InvalidEmailAuthException {
                            await showErrorDialog(
                              context,
                              "Invalid email",
                            );
                          } on GenericAuthException {
                            await showErrorDialog(
                              context,
                              "Failed to register",
                            );
                          }
                        },
                        child: const Text(
                          "Sign up",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(255, 197, 73, 1)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      //sign up
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already have an account?"),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                              signInRoute,
                              (_) => false,
                            );
                          },
                          child: const Text(
                            "Sign in",
                            style: TextStyle(
                              color: Color.fromRGBO(233, 179, 63, 1),
                            ),
                          ),
                        )
                      ],
                    ),
                    //const SizedBox(height: 5),
                    const Text("or"),
                    const SizedBox(height: 10),
                    const GoogleButton(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Register"),
//       ),
//       body: Column(
//         children: [
//           TextField(
//             controller: _email,
//             enableSuggestions: false,
//             autocorrect: false,
//             keyboardType: TextInputType.emailAddress,
//             decoration: const InputDecoration(
//               hintText: "Email",
//             ),
//           ),
//           TextField(
//             controller: _password,
//             obscureText: true,
//             enableSuggestions: false,
//             autocorrect: false,
//             decoration: const InputDecoration(
//               hintText: "Password",
//             ),
//           ),
//           TextField(
//             controller: _confirmPassword,
//             obscureText: true,
//             enableSuggestions: false,
//             autocorrect: false,
//             decoration: const InputDecoration(
//               hintText: "Confirm password",
//             ),
//           ),
//           TextButton(
//             onPressed: () async {
//               final email = _email.text;
//               final password = _password.text;
//               final confirmPassword = _confirmPassword.text;
//               try {
//                 if (password == confirmPassword) {
//                   await AuthService.firebase().createUser(
//                     email: email,
//                     password: password,
//                   );
//                   AuthService.firebase().sendEmailVerification();
//                   if (!mounted) return;
//                   Navigator.of(context).pushNamed(verifyRoute);
//                 } else {
//                   await showErrorDialog(context, "Password does not match");
//                 }
//               } on WeakPasswordAuthException {
//                 await showErrorDialog(
//                   context,
//                   "Password has to be at least 6 characters",
//                 );
//               } on EmailAlreadyInUsedAuthException {
//                 await showErrorDialog(
//                   context,
//                   "Email taken",
//                 );
//               } on InvalidEmailAuthException {
//                 await showErrorDialog(
//                   context,
//                   "Invalid email",
//                 );
//               } on GenericAuthException {
//                 await showErrorDialog(
//                   context,
//                   "Failed to register",
//                 );
//               }
//             },
//             child: const Text("Register"),
//           ),
//           TextButton(
//               onPressed: () {
//                 Navigator.of(context).pushNamedAndRemoveUntil(
//                   signInRoute,
//                   (_) => false,
//                 );
//               },
//               child: const Text("Have an account? Login"))
//         ],
//       ),
//     );
//   }
// }
