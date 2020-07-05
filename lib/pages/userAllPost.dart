import 'package:flutter/material.dart';

import 'package:flutter_wordpress_app/pages/user_post_detail.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';

class UserAllPost extends StatelessWidget {
  final int userId;

  const UserAllPost({Key key, this.userId}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Future<List> fetchUserPost() async {
      final response = await http.get(
          'https://soleentrepreneur.co.uk/wp-json/wp/v2/posts?author=$userId&_fields=fimg_url,featured_media,title.rendered,content.rendered,excerpt.rendered,date,guid.rendered',
          headers: {"Accept": "application/json"});
      var convertDatattoJson = jsonDecode(response.body);
      return convertDatattoJson;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('All Companies of User'),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.grey,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        child: FutureBuilder(
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  physics: ClampingScrollPhysics(),
                  itemBuilder: (context, index) {
                    Map wppost = snapshot.data[index];
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UserPostDetail(
                                      title: wppost['title']['rendered'],
                                      link: wppost['guid']['rendered'],
                                      image: (wppost['fimg_url']) == false
                                          ? 'assets/IMG_2382.PNG'
                                          : wppost['fimg_url'],
                                      excerpt: wppost['excerpt']['rendered'],
                                      content: wppost['content']['rendered'],
                                    )));
                      },
                      child: Card(
                        child: Column(
                          children: <Widget>[
                            ListTile(
                              leading: CircleAvatar(
                                backgroundImage: (wppost['fimg_url'] == false)
                                    ? AssetImage('')
                                    : NetworkImage(
                                        '${wppost['fimg_url']}',
                                      ),
                              ),
                              title: Text(wppost['title']['rendered']),
                              // subtitle: Text(wppost['date']),
                              // trailing: IconButton(
                              //     icon: Icon(Icons.favorite), onPressed: () {}),
                              // onTap: () {},
                            ),
                            Container(
                              height: 200,
                              color: Colors.white,
                              child: (wppost['fimg_url'] == false)
                                  ? Container()
                                  : Image.network(
                                      '${wppost['fimg_url']}',
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
                    );
                  },
                  itemCount: snapshot.data.length);
            }
            return CircularProgressIndicator();
          },
          future: fetchUserPost(),
        ),
      ),
    );
  }
}
