import 'package:flutter/material.dart';
import 'package:my_notes/constants/colors.dart';
import 'package:my_notes/constants/routes.dart';
import 'package:my_notes/services/auth/auth_service.dart';
import 'package:my_notes/view/notes/create_update_note_view.dart';
import 'package:my_notes/view/notes/notes_view.dart';
import 'package:my_notes/view/password_reset_view.dart';
import 'package:my_notes/view/verify_email_view.dart';
import 'package:my_notes/view/login_view.dart';
import 'package:my_notes/view/register_view.dart';
import 'package:google_fonts/google_fonts.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'MyNotes',
      theme: ThemeData(
        hoverColor: Colors.transparent,
        splashColor: emphasisColor,
        primarySwatch: createMaterialColor(const Color(0xFFFFD52E)),
        textTheme: GoogleFonts.robotoTextTheme()
      ),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      routes: {
        signInRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        notesRoute: (context) => const NotesView(),
        verifyRoute: (context) => const VerifyEmailView(),
        createOrUpdateNoteRoute: (context) => const CreateUpdateNoteView(),
        passwordResetRoute: (context) => const PasswordResetView()
      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;
            if (user != null) {
              if (user.isEmailVerified) {
                return const NotesView();
              } else {
                return const VerifyEmailView();
              }
            } else {
              return const LoginView();
            }
          default:
            return const Center(
              child: CircularProgressIndicator(),
            );
        }
      },
    );
  }
}
