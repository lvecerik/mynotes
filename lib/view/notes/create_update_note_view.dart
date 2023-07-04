import 'package:flutter/material.dart';
import 'package:my_notes/services/auth/auth_service.dart';
import 'package:my_notes/utilities/dialogs/cannot_share_empty_note_dialog.dart';
import 'package:my_notes/utilities/generics/get_arguments.dart';
import 'package:my_notes/services/cloud/cloud_note.dart';
import 'package:my_notes/services/cloud/firebase_cloud_storage.dart';
import 'package:share_plus/share_plus.dart';

class CreateUpdateNoteView extends StatefulWidget {
  const CreateUpdateNoteView({super.key});

  @override
  State<CreateUpdateNoteView> createState() => _CreateUpdateNoteViewState();
}

class _CreateUpdateNoteViewState extends State<CreateUpdateNoteView> {
  CloudNote? _note;
  late final FirebaseCloudStorage _notesService;
  late final TextEditingController _textController;
  late final TextEditingController _titleController;

  @override
  void initState() {
    _notesService = FirebaseCloudStorage();
    _textController = TextEditingController();
    _titleController = TextEditingController();
    super.initState();
  }

  Future<CloudNote> createOrGetExistingNote(BuildContext context) async {
    final widgetNote = context.getArgument<CloudNote>();
    if (widgetNote != null) {
      _note = widgetNote;
      _textController.text = widgetNote.text;
      _titleController.text = widgetNote.title;
      return widgetNote;
    }

    final existingNote = _note;
    if (existingNote != null) {
      return existingNote;
    }

    final currentUser = AuthService.firebase().currentUser!;
    final userId = currentUser.id;
    final newNote = await _notesService.createNote(ownerUserId: userId);
    _note = newNote;
    return newNote;
  }

  void _deleteNoteIfEmpty() {
    final note = _note;

    if (_textController.text.isEmpty && note != null) {
      _notesService.deleteNote(documentId: note.documentId);
    }
  }

  void _saveNoteIfTextNotEmpty() async {
    final note = _note;
    final text = _textController.text;
    final title = _titleController.text;
    if (text.isNotEmpty && note != null) {
      await _notesService.updateNote(
          documentId: note.documentId, text: text, title: title);
    }
  }

  void _textAndTitleControllerListener() async {
    final note = _note;
    if (note == null) {
      return;
    }
    final text = _textController.text;
    final title = _titleController.text;
    await _notesService.updateNote(
        documentId: note.documentId, text: text, title: title);
  }

  void _setUpTextControllerListener() {
    _textController.removeListener(_textAndTitleControllerListener);
    _textController.addListener(_textAndTitleControllerListener);
    _titleController.removeListener(_textAndTitleControllerListener);
    _titleController.addListener(_textAndTitleControllerListener);
  }

  @override
  void dispose() {
    _deleteNoteIfEmpty();
    _saveNoteIfTextNotEmpty();
    _textController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.getArgument<CloudNote>() == null
            ? "New Note"
            : "Edit Note"),
        actions: [
          IconButton(
            onPressed: () async {
              final text = _textController.text;
              if (_note == null || text.isEmpty) {
                await showCannotShareEmptyNoteDialog(context);
              } else {
                Share.share(text);
              }
            },
            icon: const Icon(Icons.share),
          )
        ],
      ),
      body: FutureBuilder(
        future: createOrGetExistingNote(context),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              {
                _setUpTextControllerListener();
                return Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    children: [
                      TextField(
                        controller: _titleController,
                        keyboardType: TextInputType.multiline,
                        decoration: const InputDecoration(hintText: "Title"),
                        autofocus: true,
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: TextField(
                          controller: _textController,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          expands: true,
                          decoration:
                              const InputDecoration(hintText: "Type here..."),
                          autofocus: true,
                        ),
                      ),
                    ],
                  ),
                );
              }

            default:
              return const Center(
                child: CircularProgressIndicator(),
              );
          }
        },
      ),
    );
  }
}
