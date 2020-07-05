import 'dart:async';

import 'package:flutter_wordpress_app/models/Article.dart';

import 'bookArticleDb.dart';

class BookArticleDao { 
  //FavArticleDatabaseProvider make a favourite.db database create if the no db is present in the app
  //If present get the Intial DB.
  //Calling Simple constructor
  final dbProvider = BookArticleDatabaseProvider.dbProvider;
//Funtion for Adding the favourite Article in the OS Directory System.
  Future<int> createBookArticle(Article article) async {
    //
    final db = await dbProvider.database;
//
    var result = await db.insert(bookArticleTABLE, article.toDatabaseJson());
    return result;
  }

//Getting the Favorite Articles from the Database which is created by sqllite and pathProvider.
  Future<List<Article>> getBookArticles(
      {List<String> columns, String query, int page}) async {
    final db = await dbProvider.database;

    List<Map<String, dynamic>> result;
    if (query != null) {
      if (query.isNotEmpty)
        result = await db.query(
          bookArticleTABLE,
          columns: columns,
          where: 'name LIKE ?',
          whereArgs: ["%$query%"],
        );
    } else {
      result = await db.query(bookArticleTABLE, columns: columns);
    }

    List<Article> articles = result.isNotEmpty
        ? result.map((item) => Article.fromDatabaseJson(item)).toList()
        : [];
    return articles;
  }

//Get or Read Favorite Article Singular
  Future<Article> getBookArticle(int id) async {
    final db = await dbProvider.database;
    List<Map> maps =
        await db.query(bookArticleTABLE, where: 'id = ?', whereArgs: [id]);
    Article article =
        maps.length > 0 ? Article.fromDatabaseJson(maps.first) : null;
    return article;
  }
//Delete the Favourite Article.
  Future<int> deleteBookArticle(int id) async {
    final db = await dbProvider.database;
    var result =
        await db.delete(bookArticleTABLE, where: 'id = ?', whereArgs: [id]);

    return result;
  }
}
