import 'package:flutter/material.dart';
import 'package:my_notes/services/cloud/cloud_note.dart';
import 'package:my_notes/utilities/dialogs/delete_dialog.dart';

typedef NoteCallback = void Function(CloudNote note);

class NotesListView extends StatelessWidget {
  final Iterable<CloudNote> notes;
  final NoteCallback onDeleteNote;
  final NoteCallback onTap;

  const NotesListView({
    super.key,
    required this.notes,
    required this.onDeleteNote,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes.elementAt(index);
        return Card(
          elevation: 0,
          child: ListTile(
            onTap: () => onTap(note),
            title: Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Text(
                note.title,
                maxLines: 1,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            subtitle: Text(
              note.text,
              maxLines: 1,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: FittedBox(
              fit: BoxFit.fill,
              child: Row(
                children: [
                  Text(note.timestamp, style: const TextStyle(fontStyle: FontStyle.italic),),
                  IconButton(
                    onPressed: () async {
                      final shouldDelete = await showDeleteDialog(context);
                      if (shouldDelete) {
                        onDeleteNote(note);
                      }
                    },
                    icon: const Icon(Icons.delete),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
