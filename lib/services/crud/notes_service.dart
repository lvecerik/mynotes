// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:sqflite/sqflite.dart';
// import "package:path/path.dart" show join;
// import 'package:path_provider/path_provider.dart';
// import 'crud_exceptions.dart';
// import 'package:flutter/foundation.dart' show kIsWeb;

// class NotesService {
//   Database? _db;

//   List<DatabaseNote> _notes = [];

//   NotesService._sharedInstance() {
//     _notesStreamController = StreamController<List<DatabaseNote>>.broadcast(
//       onListen: () {
//         _notesStreamController.sink.add(_notes);
//       },
//     );
//   }
//   static final NotesService _shared = NotesService._sharedInstance();
//   factory NotesService() => _shared;

//   late final StreamController<List<DatabaseNote>> _notesStreamController;

//   Stream<List<DatabaseNote>> get allNotes => _notesStreamController.stream;

//   Future<DatabaseUser> getOrCreateUser({required String email}) async {
//     try {
//       final user = await getUser(email: email);
//       return user;
//     } on CouldNotFindUser {
//       print("no user");
//       final createdUser = await createUser(email: email);
//       return createdUser;
//     } catch (e) {
//       print(e);
//       rethrow;
//     }
//   }

//   Future<void> _catcheNotes() async {
//     final allNotes = await getAllNotes();
//     _notes = allNotes.toList();
//     _notesStreamController.add(_notes);
//   }

//   Future<DatabaseNote> updateNote(
//       {required DatabaseNote note, required String text}) async {
//     await _ensureDbisOpen();
//     final db = _getDatabaseOrThrow();

//     await getNote(id: note.id);

//     final updateCount = await db.update(
//       notesTable,
//       {
//         textColumn: text,
//       },
//       where: "id = ?",
//       whereArgs: [note.id],
//     );

//     if (updateCount == 0) {
//       throw CouldNotUpdateNote();
//     } else {
//       final updatedNote = await getNote(id: note.id);
//       _notes.removeWhere((note) => note.id == updatedNote.id);
//       _notes.add(updatedNote);
//       _notesStreamController.add(_notes);
//       return updatedNote;
//     }
//   }

//   Future<Iterable<DatabaseNote>> getAllNotes() async {
//     await _ensureDbisOpen();
//     final db = _getDatabaseOrThrow();
//     final notes = await db.query(notesTable);

//     return notes.map((noteRow) => DatabaseNote.fromRow(noteRow));
//   }

//   Future<DatabaseNote> getNote({required int id}) async {
//     await _ensureDbisOpen();
//     final db = _getDatabaseOrThrow();
//     final notes = await db.query(
//       notesTable,
//       limit: 1,
//       where: "id = ? ",
//       whereArgs: [id],
//     );
//     if (notes.isEmpty) {
//       throw CouldNotFindNote();
//     } else {
//       final note = DatabaseNote.fromRow(notes.first);
//       _notes.removeWhere((note) => note.id == id);
//       _notes.add(note);
//       _notesStreamController.add(_notes);
//       return note;
//     }
//   }

//   Future<int> deleteAllNotes() async {
//     await _ensureDbisOpen();
//     final db = _getDatabaseOrThrow();
//     await db.delete(notesTable);
//     final numberOfDeletions = await db.delete(notesTable);
//     _notes = [];
//     _notesStreamController.add(_notes);
//     return numberOfDeletions;
//   }

//   Future<void> deleteNote({required int id}) async {
//     await _ensureDbisOpen();
//     final db = _getDatabaseOrThrow();
//     final deletedCount = await db.delete(
//       notesTable,
//       where: "id = ?",
//       whereArgs: [id],
//     );
//     if (deletedCount == 0) {
//       throw CouldnotDeleteNote();
//     } else {
//       _notes.removeWhere((note) => note.id == id);
//       _notesStreamController.add(_notes);
//     }
//   }

//   Future<DatabaseNote> createNote({required DatabaseUser owner}) async {
//     await _ensureDbisOpen();
//     final db = _getDatabaseOrThrow();

//     //make sure owner exists in database
//     final dbUser = await getUser(email: owner.email);
//     if (dbUser != owner) {
//       throw CouldNotFindUser();
//     }

//     const text = "";
//     //create note
//     final noteId = await db.insert(notesTable, {
//       userIdColumn: owner.id,
//       textColumn: text,
//     });

//     final note = DatabaseNote(
//       id: noteId,
//       userId: owner.id,
//       text: text,
//     );
//     _notes.add(note);
//     _notesStreamController.add(_notes);
//     return note;
//   }

//   Future<DatabaseUser> getUser({required String email}) async {
//     await _ensureDbisOpen();
//     final db = _getDatabaseOrThrow();
//     final results = await db.query(
//       userTable,
//       limit: 1,
//       where: email,
//       whereArgs: [email.toLowerCase()],
//     );
//     if (results.isEmpty) {
//       throw CouldNotFindUser();
//     } else {
//       return DatabaseUser.fromRow(results.first);
//     }
//   }

//   Future<DatabaseUser> createUser({required String email}) async {
//     await _ensureDbisOpen();

//     final db = _getDatabaseOrThrow();
//     final results = await db.query(
//       userTable,
//       limit: 1,
//       where: email,
//       whereArgs: [email.toLowerCase()],
//     );
//     if (results.isNotEmpty) {
//       throw UserAlreadyExists();
//     }

//     final userId = await db.insert(userTable, {
//       emailColumn: email.toLowerCase(),
//     });
//     return DatabaseUser(
//       id: userId,
//       email: email,
//     );
//   }

//   Future<void> deleteUser({required String email}) async {
//     await _ensureDbisOpen();
//     final db = _getDatabaseOrThrow();
//     final deleteCount = await db.delete(
//       userTable,
//       where: "email =  ?",
//       whereArgs: [email.toLowerCase()],
//     );
//     if (deleteCount != 1) {
//       throw CouldnotDeleteUser();
//     }
//   }

//   Database _getDatabaseOrThrow() {
//     final db = _db;
//     if (db == null) {
//       throw DatabaseIsNotOpen();
//     } else {
//       return db;
//     }
//   }

//   Future<void> open() async {
//     if (_db != null) {
//       throw DatabaseAlreadyOpenException();
//     }
//     try {
//       final docsPath = await getApplicationDocumentsDirectory();
//       final dbPath = join(docsPath.path, dbName);
//       print(dbPath);
//       final db = await openDatabase(dbPath);
//       _db = db;

//       //create user table
//       await db.execute(createUserTable);
//       //create notes table
//       await db.execute(createNotesTable);
//       await _catcheNotes();
//     } on MissingPlatformDirectoryException {
//       throw UnableToGetDocumentsDirectory();
//     }
//   }

//   Future<void> close() async {
//     final db = _db;
//     if (db == null) {
//       throw DatabaseIsNotOpen();
//     } else {
//       await db.close();
//       _db = null;
//     }
//   }

//   Future<void> _ensureDbisOpen() async {
//     try {
//       await open();
//     } on DatabaseAlreadyOpenException {
//       //empty - let it go
//     }
//   }
// }

// @immutable
// class DatabaseUser {
//   final int id;
//   final String email;

//   const DatabaseUser({
//     required this.id,
//     required this.email,
//   });

//   DatabaseUser.fromRow(Map<String, Object?> map)
//       : id = map[idColumn] as int,
//         email = map[emailColumn] as String;

//   @override
//   String toString() => "Person, ID = $id, email = $email";

//   @override
//   bool operator ==(covariant DatabaseUser other) => id == other.id;

//   @override
//   int get hashCode => id.hashCode;
// }

// class DatabaseNote {
//   final int id;
//   final int userId;
//   final String text;

//   DatabaseNote({
//     required this.id,
//     required this.userId,
//     required this.text,
//   });

//   DatabaseNote.fromRow(Map<String, Object?> map)
//       : id = map[idColumn] as int,
//         userId = map[userIdColumn] as int,
//         text = map[textColumn] as String;

//   @override
//   String toString() => "Notes, ID = $id, userId = $userId, text = $text";

//   @override
//   bool operator ==(covariant DatabaseUser other) => id == other.id;

//   @override
//   int get hashCode => id.hashCode;
// }

// const dbName = "testing.db";
// const notesTable = "note";
// const userTable = "user";
// const idColumn = "id";
// const emailColumn = "email";
// const userIdColumn = "userId";
// const textColumn = "text";
// const createUserTable = """CREATE TABLE IF NOT EXISTS "user" (
//       "id"	INTEGER NOT NULL,
//       "email"	TEXT NOT NULL UNIQUE,
//       PRIMARY KEY("id" AUTOINCREMENT)
//       ); """;
// const createNotesTable = """CREATE TABLE IF NOT EXISTS "notes" (
//       "id"	INTEGER NOT NULL,
//       "user_id"	INTEGER NOT NULL,
//       "text"	TEXT,
//       PRIMARY KEY("id"),
//       FOREIGN KEY("user_id") REFERENCES "user"("id")
//     ); """;
