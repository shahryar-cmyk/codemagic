import 'package:flutter/material.dart';
// import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_wordpress_app/models/Article.dart';
// import 'package:html/dom.dart' as dom;

Widget articleBox(BuildContext context, Article article, String heroId) {
  return Card(
      child: Container(
    height: 70,
    width: double.infinity,
    child: ListTile(
      title: Text(article.title),
      leading: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: const Offset(0.0, 10.0),
              blurRadius: 10.0,
              spreadRadius: 1.0,
            ),
          ],
          // border: Border.all(width: 1),
          image: DecorationImage(image: NetworkImage('${article.image}')),
          // border: Border.all(width: 1),
        ),
      ),
      trailing: IconButton(
          icon: Icon(
            Icons.add_circle,
            size: 35,
            color: Color.fromRGBO(104, 97, 123, 1),
          ),
          onPressed: () {}),
    ),
  ));
}
