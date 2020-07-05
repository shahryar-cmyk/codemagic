import 'package:flutter/material.dart';
import 'package:flutter_wordpress_app/blocs/bookArticleBloc.dart';
import 'package:flutter_wordpress_app/models/Article.dart';
import 'package:flutter_wordpress_app/pages/single_Article.dart';
import 'package:flutter_wordpress_app/widgets/articleBox.dart';
import 'package:loading/indicator/ball_beat_indicator.dart';
import 'package:loading/loading.dart';

class BookmarkArticles extends StatefulWidget {
  BookmarkArticles({Key key}) : super(key: key);
  @override
  _BookmarkArticlesState createState() => _BookmarkArticlesState();
}

class _BookmarkArticlesState extends State<BookmarkArticles> {
  final BookArticleBloc bookArticleBloc = BookArticleBloc();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.black,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text("BookMark",
            textAlign: TextAlign.left,
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20,
                fontFamily: 'Poppins')),
        elevation: 5,
        backgroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(color: Colors.white),
        child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(children: <Widget>[categoryPosts()])),
      ),
    );
  }

  Widget categoryPosts() {
    return FutureBuilder<List<Article>>(
      future: bookArticleBloc.getBookArticles(),
      builder: (context, AsyncSnapshot<List<Article>> articleSnapshot) {
        if (articleSnapshot.hasData) {
          if (articleSnapshot.data.length == 0) return Container();
          return Column(
              children: articleSnapshot.data.map((item) {
            final heroId = item.id.toString() + "-bookpost";
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SingleArticle(item, heroId),
                  ),
                );
              },
              child: articleBox(context, item, heroId),
            );
          }).toList());
        } else if (articleSnapshot.hasError) {
          return Container(
              height: 500,
              alignment: Alignment.center,
              child: Text("${articleSnapshot.error}"));
        }
        return Container(
          alignment: Alignment.center,
          height: 400,
          child: Loading(
              indicator: BallBeatIndicator(),
              size: 60.0,
              color: Theme.of(context).accentColor),
        );
      },
    );
  }
}
