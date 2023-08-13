import 'dart:io';

import 'package:flutter_sqflite/notes_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHandler {
  static Database? _db;

  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }

    _db = await initDatabase();
    return _db;
  }

  initDatabase() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, "notes.db");

    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute("CREATE TABLE notes (id INTEGER PRIMARY KEY AUTOINCREMENT, "
        "title TEXT NOT NULL, age INTEGER NOT NULL, description TEXT NOT NULL, email TEXT)");
  }

  Future<NotesModel> insert(NotesModel notesModel) async {
    var dbClient = await db;
    await dbClient!.insert("notes", notesModel.toMap());

    return notesModel;
  }

  Future<List<NotesModel>> getNotesList() async {
    var dbClient = await db;

    final List<Map<String, dynamic>> queryResult = await dbClient!.query("notes");
    List<NotesModel> notesList = queryResult.map((e) => NotesModel.fromMap(e)).toList();

    return notesList.reversed.toList();
  }
}
