import 'package:flutter/material.dart';
// import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_wordpress_app/models/Article.dart';
// import 'package:html/dom.dart' as dom;

Widget articleBox3(BuildContext context, Article article, String heroId) {
  return Padding(
    padding: const EdgeInsets.only(left: 8.0),
    child: Card(
      elevation: 3,
      shape: BeveledRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            image: DecorationImage(
                image: NetworkImage(article.image), fit: BoxFit.fill)),
        child: Transform.translate(
          offset: Offset(50, -50),
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 65, vertical: 63),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              // color: Colors.white
            ),
          ),
        ),
      ),
    ),
  );
}
