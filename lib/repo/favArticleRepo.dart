import 'package:flutter_wordpress_app/models/Article.dart';

import 'favArticleDao.dart';

class FavArticleRepository { 
  //Favorite Article Respository where we create Database.
  final favArticleDao = FavArticleDao();
//Getting All the favourite Articles in the database
  Future getAllFavArticles({String query, int page}) =>
      favArticleDao.getFavArticles(query: query, page: page);
//Get a Specific favorite Article
  Future getFavArticle(int id) => favArticleDao.getFavArticle(id);
//Inserting the Article in the favourite database
  Future insertFavArticle(Article article) =>
      favArticleDao.createFavArticle(article);
//Delete the Favourite Article By ID
  Future deleteFavArticleById(int id) => favArticleDao.deleteFavArticle(id);
}
