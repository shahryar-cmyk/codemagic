import 'package:flutter_wordpress_app/models/Article.dart';

import 'bookArticleDao.dart';

class BookArticleRepository {
  //Favorite Article Respository where we create Database.
  final bookArticleDao = BookArticleDao();
//Getting All the favourite Articles in the database
  Future getAllBookArticles({String query, int page}) =>
      bookArticleDao.getBookArticles(query: query, page: page);
//Get a Specific favorite Article
  Future getBookArticle(int id) => bookArticleDao.getBookArticle(id);
//Inserting the Article in the favourite database
  Future insertBookArticle(Article article) =>
      bookArticleDao.createBookArticle(article);
//Delete the Favourite Article By ID
  Future deleteBookArticleById(int id) => bookArticleDao.deleteBookArticle(id);
}
