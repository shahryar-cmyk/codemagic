import 'dart:async';

import 'package:flutter_wordpress_app/models/Article.dart';
import 'package:flutter_wordpress_app/bookRepo/bookArticleRepo.dart';

class BookArticleBloc {
  //Favourite Article Repository Class Instance
  final _articleRepository = BookArticleRepository();

  final _articlesController = StreamController<List<Article>>.broadcast();

  Stream<List<Article>> get articles => _articlesController.stream;

  BookArticleBloc() {
    getBookArticles();
  }

  Future<List<Article>> getBookArticles({String query, int page}) async {
    final List<Article> articles =
        await _articleRepository.getAllBookArticles(query: query, page: page);
    _articlesController.sink.add(articles);
    return articles;
  }

  getBookArticle(int id) async {
    final Article article = await _articleRepository.getBookArticle(id);
    return article;
  }

  addBookArticle(Article article) async {
    await _articleRepository.insertBookArticle(article);
    getBookArticles();
  }

  deleteBookArticleById(int id) async {
    _articleRepository.deleteBookArticleById(id);
    getBookArticles();
  }

  dispose() {
    _articlesController.close();
  }
}
