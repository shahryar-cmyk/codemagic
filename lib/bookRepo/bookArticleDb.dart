import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

final bookArticleTABLE = 'bookarticle';

class BookArticleDatabaseProvider { 
  // Constructor of  FavArticleDatabaseProvider
  static final BookArticleDatabaseProvider dbProvider =
      BookArticleDatabaseProvider();

  Database _database;
//Checking whether the database is created or not
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await createDatabase();
    return _database;
  }


  createDatabase() async {
    //Geting the path directory system of the Application by Path provider Plugin
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    //Joins the given path parts into a single path using the current platform's [separator].
    String path = join(documentsDirectory.path, 'bookarticle.db');
    //Creating the specific database of application in specified path obtained from path provider and path plugin.
    var database = await openDatabase(path, version: 1, onCreate: initDB);
    return database;
  }

//Creating the Database
  void initDB(Database database, int version) async {
    //For My project tip simple save the content to extract the images.
    await database.execute(
        'CREATE TABLE $bookArticleTABLE (id INTEGER PRIMARY KEY, title TEXT, content TEXT, image TEXT, video TEXT, author TEXT, avatar TEXT, category TEXT, date TEXT, link TEXT, catId INTEGER)');
  }
}
