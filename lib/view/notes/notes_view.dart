import 'package:flutter/material.dart';
import 'package:my_notes/constants/routes.dart';
import 'package:my_notes/services/auth/auth_service.dart';
import 'package:my_notes/services/cloud/cloud_note.dart';
import 'package:my_notes/services/cloud/firebase_cloud_storage.dart';
import 'package:my_notes/utilities/dialogs/sign_out_dialog.dart';
import 'package:my_notes/view/notes/create_update_note_view.dart';
import 'package:my_notes/view/notes/notes_list_view.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

enum MenuAction { signout }

class _NotesViewState extends State<NotesView> {
  late final FirebaseCloudStorage _notesService;
  String get userId => AuthService.firebase().currentUser!.id;
  String get userEmail => AuthService.firebase().currentUser!.email;

  @override
  void initState() {
    _notesService = FirebaseCloudStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MyNotes $userEmail"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(createOrUpdateNoteRoute);
            },
            icon: const Icon(Icons.note_add_outlined),
            tooltip: "Create new note",
          ),
          PopupMenuButton<MenuAction>(onSelected: (value) async {
            switch (value) {
              case MenuAction.signout:
                final shouldSignOut = await showSignOutDialog(context);
                if (shouldSignOut) {
                  await AuthService.firebase().signOut();
                  if (mounted) {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      signInRoute,
                      (_) => false,
                    );
                  }
                }
                break;
            }
          }, itemBuilder: (context) {
            return const [
              PopupMenuItem<MenuAction>(
                value: MenuAction.signout,
                child: Text("Sign out"),
              ),
            ];
          })
        ],
      ),
      body: Container(
        color: const Color.fromRGBO(229, 229, 229, 1),
        padding: const EdgeInsets.all(10),
        child: StreamBuilder(
          stream: _notesService.allNotes(ownerUserId: userId),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
              case ConnectionState.active:
                if (snapshot.hasData) {
                  final allNotes = snapshot.data as Iterable<CloudNote>;
                  return NotesListView(
                    notes: allNotes,
                    onDeleteNote: (note) async {
                      await _notesService.deleteNote(
                          documentId: note.documentId);
                    },
                    onTap: (note) {
                      Navigator.of(context)
                          .pushNamed(createOrUpdateNoteRoute, arguments: note);
                    },
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              default:
                return const Center(
                  child: CircularProgressIndicator(),
                );
            }
          },
        ),
      ),
    );
  }
}
