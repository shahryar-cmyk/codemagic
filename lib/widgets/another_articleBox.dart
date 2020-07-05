import 'package:flutter/material.dart';

import 'package:flutter_wordpress_app/models/Article.dart';

Widget articleBox2(BuildContext context, Article article, String heroId) {
  return Column(
    children: <Widget>[
      Container(
        height: 305,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Card(
              child: Column(
                children: <Widget>[
                  ListTile(
                      leading: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              offset: const Offset(0.0, 10.0),
                              blurRadius: 10.0,
                              spreadRadius: 1.0,
                            ),
                          ],
                          shape: BoxShape.circle,
                          color: Colors.white,
                          // border: Border.all(width: 1),
                          image: DecorationImage(
                              image: NetworkImage('${article.image}')),
                          // border: Border.all(width: 1),
                        ),
                      ),
                      title: Text('${article.title}'),
                      // subtitle: Text(wppost['date']),
                      // trailing: IconButton(
                      //   icon: Icon(Icons.favorite),
                      //   onPressed: () {},
                      // )
                      // onTap: () {},
                      ),
                  Container(
                    height: 200,
                    color: Colors.white,
                    child: Image.network(
                      '${article.image}',
                      fit: BoxFit.fill,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        // Icon(Icons.location_on),
                        // Text('San Francisco, CA'),
                      ],
                    ),
                  ),
                  // Text(wppost['guid']['rendered']),
                  // Text(wppost['title']['rendered']),
                  // Text(wppost['content']['rendered']),
                ],
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
