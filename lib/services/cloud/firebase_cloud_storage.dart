import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:my_notes/services/cloud/cloud_note.dart';
import 'package:my_notes/services/cloud/cloud_storage_constants.dart';
import 'package:my_notes/services/cloud/cloud_storage_exceptions.dart';

class FirebaseCloudStorage {
  final notes = FirebaseFirestore.instance.collection("notes");
  Future<CloudNote> createNote({required String ownerUserId}) async {
    final document = await notes.add({
      ownerUserIdFieldName: ownerUserId,
      textFieldName: "",
      titleFieldName: "",
      timestampFieldName: ""
    });
    final fetchedNote = await document.get();
    return CloudNote(
      documentId: fetchedNote.id,
      ownerUserId: ownerUserId,
      text: "",
      title: "",
      timestamp: timestampInFormat(),
    );
  }

  Future<void> deleteNote({required String documentId}) async {
    try {
      await notes.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeleteNoteException();
    }
  }

  Future<void> updateNote(
      {required String documentId,
      required String text,
      required String title,
      required String timestamp}) async {
    try {
      await notes.doc(documentId).update({
        textFieldName: text,
        titleFieldName: title,
        timestampFieldName: timestampInFormat()
      });
    } catch (e) {
      throw CouldNotUpdateNoteException();
    }
  }

  Stream<Iterable<CloudNote>> allNotes({required String ownerUserId}) {
    final onlyUsersNotes = notes
      .where(
        ownerUserIdFieldName,
        isEqualTo: ownerUserId,
      )
      .snapshots()
      .map((querySnapshot) {
        final notesList = querySnapshot.docs.map(
          (doc) => CloudNote.fromSnapshot(doc),
        ).toList();

        notesList.sort((a, b) => b.timestamp.compareTo(a.timestamp));
        return notesList;
      });

  return onlyUsersNotes;
  }

  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstance();

  FirebaseCloudStorage._sharedInstance();
  factory FirebaseCloudStorage() => _shared;

  String timestampInFormat() {
    return DateFormat('yyyy M.d. HH:mm').format(DateTime.now());
  }
}
