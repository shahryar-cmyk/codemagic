import 'package:flutter/material.dart';
import 'package:flutter_wordpress_app/pages/search.dart';
import 'package:share/share.dart';
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart' as dom;
import 'package:flutter_icons/flutter_icons.dart';
import 'package:social_share/social_share.dart';
import 'package:flutter_html/flutter_html.dart';

class UserPostDetail extends StatefulWidget {
  final String title;
  final String image;
  final String content;
  final String excerpt;
  final String link;

  const UserPostDetail(
      {Key key, this.title, this.image, this.content, this.excerpt, this.link})
      : super(key: key);
  @override
  _UserPostDetailState createState() => _UserPostDetailState();
}

class _UserPostDetailState extends State<UserPostDetail> {
  void share(BuildContext ctx) {
    Share.share('This is the Example App Check it out');
  }

  Future<bool> onLikeButtonTapped(bool isLiked) async {
    /// send your request here
    // final bool success= await sendRequest();

    /// if failed, you can do nothing
    // return success? !isLiked:isLiked;
    print(isLiked);
    return !isLiked;
  }

  @override
  Widget build(BuildContext context) {
    Future<List<String>> _getData() {
      String jsonString = '''${widget.content}''';
      String result = jsonString.replaceAll("\n", "\\n");
      String result2 = result.replaceAll("\\n", "");
      var document = parse(result2);
      var imgList = document.querySelectorAll("img");
      List<String> imageList = [];
      for (dom.Element img in imgList) {
        print(img.attributes["src"]);
        imageList.add(img.attributes["src"]);
      }
      return Future.value(imageList);
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Search()));
              }),
          // LikeButton(
          //   padding: EdgeInsets.only(right: 10),
          //   onTap: onLikeButtonTapped,
          // ),
        ],
        title: Text(
          'Company Profile',
          style: Theme.of(context).textTheme.bodyText1,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Stack(
              overflow: Overflow.visible,
              children: <Widget>[
                Container(
                  height: 250,
                  width: MediaQuery.of(context).size.width * 0.8,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.white),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromRGBO(124, 116, 146, 0.4),
                        blurRadius:
                            10.0, // has the effect of softening the shadow
                        spreadRadius:
                            1.0, // has the effect of extending the shadow
                        offset: Offset(
                          0.0, // horizontal, move right 10
                          10.0, // vertical, move down 10
                        ),
                      )
                    ],
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 40.0, right: 70, top: 40),
                    child: Text(
                      widget.title,
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1
                          .copyWith(color: Color.fromRGBO(124, 116, 146, 1)),
                    ),
                  ),
                ),
                Positioned(
                  top: 100,
                  child: Row(children: <Widget>[
                    IconButton(
                      icon: Icon(
                        SimpleLineIcons.social_twitter,
                        color: Color.fromRGBO(124, 116, 146, 1),
                      ),
                      onPressed: () async {
                        SocialShare.shareTwitter(
                                '${widget.title} is a new Trend',
                                hashtags: ["hello", "world", "foo", "bar"],
                                url: "${widget.link}",
                                trailingText: "\nhello")
                            .then((data) {
                          print(data);
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(FontAwesome.whatsapp,
                          color: Color.fromRGBO(124, 116, 146, 1)),
                      onPressed: () async {
                        SocialShare.shareWhatsapp("${widget.link}")
                            .then((data) {
                          print(data);
                        });
                      },
                    ),
                    IconButton(
                        icon: Icon(Feather.message_circle,
                            color: Color.fromRGBO(124, 116, 146, 1)),
                        onPressed: () async {
                          SocialShare.shareSms("${widget.title}",
                                  url: "${widget.link}",
                                  trailingText: "\nhello")
                              .then((data) {
                            print(data);
                          });
                        }),
                    IconButton(
                      icon: Icon(SimpleLineIcons.share,
                          color: Color.fromRGBO(124, 116, 146, 1)),
                      onPressed: () => share(context),
                    ),
                  ]),
                ),
                // Positioned(
                //   left: 0.0,
                //   bottom: 0.0,
                //   child: Container(
                //     height: 100,
                //     width: MediaQuery.of(context).size.width * 0.8,
                //     decoration: BoxDecoration(
                //       // color: Color.fromRGBO(251, 251, 251, 1),
                //       borderRadius: BorderRadius.only(
                //         bottomRight: Radius.circular(10),
                //       ),
                //     ),
                //     child: Padding(
                //       padding:
                //           const EdgeInsets.only(left: 40.0, right: 70, top: 20),
                //       child: ListTile(
                //         leading: Icon(Icons.location_on,
                //             color: Color.fromRGBO(124, 116, 146, 1)),
                //         title: Text(
                //           'Location',
                //           style: TextStyle(
                //               color: Color.fromRGBO(124, 116, 146, 1)),
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                Positioned(
                  left: MediaQuery.of(context).size.width * 0.6,
                  top: 40,
                  child: Container(
                    height: 190,
                    width: 160,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                          image: widget.image == 'assets/IMG_2382.PNG'
                              ? AssetImage('assets/IMG_2382.PNG')
                              : NetworkImage('${widget.image}'),
                          fit: BoxFit.fill),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 39, left: 40),
              child: Text(
                'About',
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 40),
              child: Html(data: widget.excerpt),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 40),
              child: Text(
                'Pictures',
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.5,
              child: FutureBuilder<List<String>>(
                  future: _getData(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<String>> snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                        return Text('Input a URL to start');
                      case ConnectionState.waiting:
                        return Center(child: CircularProgressIndicator());
                      case ConnectionState.active:
                        return Text('');
                      case ConnectionState.done:
                        if (snapshot.hasError) {
                          return Text(
                            '${snapshot.error}',
                            style: TextStyle(color: Colors.red),
                          );
                        } else {
                          return GridView.builder(
                              shrinkWrap: true,
                              padding: EdgeInsets.all(
                                  MediaQuery.of(context).size.height * 0.01),
                              physics: ClampingScrollPhysics(),
                              gridDelegate:
                                  new SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount:
                                          (MediaQuery.of(context).orientation ==
                                                  Orientation.portrait)
                                              ? 3
                                              : 4),
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  elevation: 0.0,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: NetworkImage(
                                                snapshot.data[index]),
                                            fit: BoxFit.fill)),
                                    child: Transform.translate(
                                      offset: Offset(50, -50),
                                      child: Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 65, vertical: 63),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                );
                              });
                        }
                    }
                    return CircularProgressIndicator();
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
