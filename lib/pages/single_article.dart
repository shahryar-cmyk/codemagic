import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter/material.dart';

import 'package:flutter_icons/flutter_icons.dart';

import 'package:flutter_wordpress_app/blocs/favArticleBloc.dart';
import 'package:flutter_wordpress_app/common/constants.dart';
import 'package:flutter_wordpress_app/models/Article.dart';
import 'package:flutter_wordpress_app/pages/search.dart';

import 'package:flutter_wordpress_app/widgets/articleBox.dart';
import 'package:html/dom.dart' as dom;
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
// import 'package:like_button/like_button.dart';
import 'package:loading/indicator/ball_beat_indicator.dart';
import 'package:loading/loading.dart';

import 'package:share/share.dart';

class SingleArticle extends StatefulWidget {
  final dynamic article;
  final String heroId;

  SingleArticle(this.article, this.heroId, {Key key}) : super(key: key);

  @override
  _SingleArticleState createState() => _SingleArticleState();
}

class _SingleArticleState extends State<SingleArticle> {
  // String _platformVersion = 'Unknown';

  //List of Articles to Add in the Related Articles
  List<dynamic> relatedArticles = [];
  //List of Related Articles get from the API when Future Builder Runs.
  // Future<List<dynamic>> _futureRelatedArticles;
//List of
  final FavArticleBloc favArticleBloc = FavArticleBloc();

  Future<dynamic> favArticle;

  @override
  void initState() {
    super.initState();

    // _futureRelatedArticles = fetchRelatedArticles();

    favArticle = favArticleBloc.getFavArticle(widget.article.id);
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    // String platformVersion;

    if (!mounted) return;

    setState(() {
      // _platformVersion = platformVersion;
    });
  }

  Future<List<String>> _getData() {
    String jsonString = '''${widget.article.content}''';
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

  String _parseString(String htmlString) {
    var document = parse(htmlString);

    String parsedString = parse(document.body.text).documentElement.text;

    return parsedString;
  }

  String _parseEmailString(String htmlString) {
    var document = parse(htmlString);

    String parsedString = parse(document.body.text).documentElement.text;
    RegExp exp = new RegExp(
      r"[a-zA-Z0-9-_.]+@[a-zA-Z0-9-_.]+",
      caseSensitive: false,
      multiLine: false,
    );

    Iterable<RegExpMatch> matches = exp.allMatches(parsedString).toList();
    print('$matches');
    print("hasMatch : " + exp.firstMatch("shahryar.rsm@gmail.com").toString());
    var matches2 = "${exp.stringMatch(parsedString).toString()}";

    return matches2;
  }

  String _parseInstragramString(String htmlString) {
    var document = parse(htmlString);

    String parsedString = parse(document.body.text).documentElement.text;

    RegExp instragram = new RegExp(
      r"(?:http:\/\/)?(?:www\.)?instagram\.com\/(?:(?:\w)*#!\/)?(?:pages\/)?(?:[\w\-]*\/)*([\w\-]*)",
      caseSensitive: false,
      multiLine: false,
    );

    var matches2 = "${instragram.stringMatch(parsedString).toString()}";

    return matches2;
  }

  String _parseTwitterString(String htmlString) {
    var document = parse(htmlString);

    String parsedString = parse(document.body.text).documentElement.text;

    RegExp exp2 = new RegExp(
      r"(?:http:\/\/)?(?:www\.)?twitter\.com\/(?:(?:\w)*#!\/)?(?:pages\/)?(?:[\w\-]*\/)*([\w\-]*)",
      caseSensitive: false,
      multiLine: false,
    );

    // Iterable<RegExpMatch> matches = exp.allMatches(parsedString).toList();
    // print('$matches');
    // print("hasMatch : " + exp2.firstMatch("shahryar.rsm@gmail.com").toString());
    var matches2 = "${exp2.stringMatch(parsedString).toString()}";
    // print(matches2);
    // print('Twitter :' + exp2.stringMatch(parsedString).toString());
    // print('Instragram :' + instragram.stringMatch(parsedString).toString());
    return matches2.toString();
  }

  Future<List<dynamic>> fetchRelatedArticles() async {
    try {
      int postId = widget.article.id;
      int catId = widget.article.catId;
      var response = await http.get(
          "$WORDPRESS_URL/wp-json/wp/v2/posts?exclude=$postId&categories[]=$catId&per_page=3");

      if (this.mounted) {
        if (response.statusCode == 200) {
          setState(() {
            relatedArticles = json
                .decode(response.body)
                .map((m) => Article.fromJson(m))
                .toList();
          });

          return relatedArticles;
        }
      }
    } on SocketException {
      throw 'No Internet connection';
    }
    return relatedArticles;
  }

  @override
  void dispose() {
    super.dispose();
    relatedArticles = [];
  }

  @override
  Widget build(BuildContext context) {
    final article = widget.article;

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
            },
          ),
          FutureBuilder<dynamic>(
              future: favArticle,
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.hasData) {
                  return Container(
                    decoration: BoxDecoration(),
                    child: IconButton(
                      padding: EdgeInsets.all(0),
                      icon: Icon(
                        Icons.favorite,
                        color: Colors.red,
                        size: 24.0,
                      ),
                      onPressed: () {
                        // Favourite post
                        favArticleBloc.deleteFavArticleById(article.id);
                        setState(() {
                          favArticle = favArticleBloc.getFavArticle(article.id);
                        });
                      },
                    ),
                  );
                }
                return Container(
                  decoration: BoxDecoration(),
                  child: IconButton(
                    padding: EdgeInsets.all(0),
                    icon: Icon(
                      Icons.favorite_border,
                      color: Colors.red,
                      size: 24.0,
                    ),
                    onPressed: () {
                      favArticleBloc.addFavArticle(article);
                      setState(() {
                        favArticle = favArticleBloc.getFavArticle(article.id);
                      });
                    },
                  ),
                );
              }),
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
                      article.title,
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
                        MaterialCommunityIcons.email,
                        color: Color.fromRGBO(124, 116, 146, 1),
                      ),
                      onPressed: () {
                        var i = _parseEmailString(widget.article.content) ==
                            null.toString();
                        (i == false)
                            ? launch(
                                'mailto:${_parseEmailString(widget.article.content)}')
                            : launch('mailto:Contactus@soleentrepreneur.co.uk');
                      },
                    ),
                    IconButton(
                      icon: Icon(FontAwesome.twitter,
                          color: Color.fromRGBO(124, 116, 146, 1)),
                      onPressed: () {
                        // _parseTwitterString(
                        //             '${_parseTwitterString(widget.article.content)}').isNotEmpty
                        //     ? launch('https://twitter.com/TheSoleEntre')
                        //     : launch('https://twitter.com/TheSoleEntre');
                        var i = _parseTwitterString(widget.article.content) ==
                            null.toString();
                        (i == false)
                            ? launch(
                                'https://${_parseTwitterString(widget.article.content)}')
                            : launch('https://twitter.com/TheSoleEntre');
                      },
                    ),
                    IconButton(
                        icon: Icon(Feather.instagram,
                            color: Color.fromRGBO(124, 116, 146, 1)),
                        onPressed: () async {
                          var i =
                              _parseInstragramString(widget.article.content) ==
                                  null.toString();
                          (i == false)
                              ? launch(
                                  'https://${_parseInstragramString(widget.article.content)}')
                              : launch(
                                  'https://www.instagram.com/soleentrepreneur/');
                        }),
                    IconButton(
                      icon: Icon(SimpleLineIcons.share,
                          color: Color.fromRGBO(124, 116, 146, 1)),
                      onPressed: () {
                        Share.share('Share the Business: ' + article.link);
                      },
                    ),
                  ]),
                ),
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
                          image: NetworkImage('${article.image}'),
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
              child: SelectableText(
                _parseString('${widget.article.content}'),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            //For Email Address
            //  Padding(
            //   padding: const EdgeInsets.only(top: 20, left: 40),
            //   child: SelectableText(
            //     _parseEmailString('${widget.article.content}'),
            //   ),
            // ),
            // SizedBox(
            //   height: 20,
            // ),
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
      // Container(
      //     decoration: BoxDecoration(color: Colors.white70),
      //     child: SingleChildScrollView(
      //       scrollDirection: Axis.vertical,
      //       child: Column(
      //         children: <Widget>[
      //           Stack(
      //             children: <Widget>[
      //               Container(
      //                 child: Hero(
      //                   tag: heroId,
      //                   child: ClipRRect(
      //                     borderRadius: BorderRadius.only(
      //                         bottomLeft: Radius.circular(60.0)),
      //                     child: ColorFiltered(
      //                       colorFilter: ColorFilter.mode(
      //                           Colors.black.withOpacity(0.3),
      //                           BlendMode.overlay),
      //                       child: articleVideo != ""
      //                           ? articleVideo.contains("youtube")
      //                               ? Container(
      //                                   padding: EdgeInsets.fromLTRB(
      //                                       0,
      //                                       MediaQuery.of(context).padding.top,
      //                                       0,
      //                                       0),
      //                                   decoration:
      //                                       BoxDecoration(color: Colors.black),
      //                                   child: HtmlWidget(
      //                                     """
      //                                 <iframe src="https://www.youtube.com/embed/$youtubeUrl" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
      //                                 """,
      //                                     webView: true,
      //                                   ),
      //                                 )
      //                               : articleVideo.contains("dailymotion")
      //                                   ? Container(
      //                                       padding: EdgeInsets.fromLTRB(
      //                                           0,
      //                                           MediaQuery.of(context)
      //                                               .padding
      //                                               .top,
      //                                           0,
      //                                           0),
      //                                       decoration: BoxDecoration(
      //                                           color: Colors.black),
      //                                       child: HtmlWidget(
      //                                         """
      //                                 <iframe frameborder="0"
      //                                 src="https://www.dailymotion.com/embed/video/$dailymotionUrl?autoplay=1&mute=1"
      //                                 allowfullscreen allow="autoplay">
      //                                 </iframe>
      //                                 """,
      //                                         webView: true,
      //                                       ),
      //                                     )
      //                                   : Container(
      //                                       padding: EdgeInsets.fromLTRB(
      //                                           0,
      //                                           MediaQuery.of(context)
      //                                               .padding
      //                                               .top,
      //                                           0,
      //                                           0),
      //                                       decoration: BoxDecoration(
      //                                           color: Colors.black),
      //                                       child: HtmlWidget(
      //                                         """
      //                                 <video autoplay="" playsinline="" controls>
      //                                 <source type="video/mp4" src="$articleVideo">
      //                                 </video>
      //                                 """,
      //                                         webView: true,
      //                                       ),
      //                                     )
      //                           : Image.network(
      //                               article.image,
      //                               fit: BoxFit.cover,
      //                             ),
      //                     ),
      //                   ),
      //                 ),
      //               ),
      //               Positioned(
      //                 top: MediaQuery.of(context).padding.top,
      //                 child: IconButton(
      //                   icon: Icon(Icons.arrow_back),
      //                   color: Colors.white,
      //                   onPressed: () {
      //                     Navigator.of(context).pop();
      //                   },
      //                 ),
      //               ),
      //             ],
      //           ),
      //           Container(
      //             child: Column(
      //               crossAxisAlignment: CrossAxisAlignment.start,
      //               mainAxisAlignment: MainAxisAlignment.start,
      //               children: <Widget>[
      //                 Html(
      //                     data: "<h1>" + article.title + "</h1>",
      //                     padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
      //                     customTextStyle:
      //                         (dom.Node node, TextStyle baseStyle) {
      //                       if (node is dom.Element) {
      //                         switch (node.localName) {
      //                           case "h1":
      //                             return Theme.of(context)
      //                                 .textTheme
      //                                 .headline1
      //                                 .merge(TextStyle(fontSize: 20));
      //                         }
      //                       }
      //                       return baseStyle;
      //                     }),
      //                 Container(
      //                   decoration: BoxDecoration(
      //                       color: Color(0xFFE3E3E3),
      //                       borderRadius: BorderRadius.circular(3)),
      //                   padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
      //                   margin: EdgeInsets.all(16),
      //                   child: Text(
      //                     article.category,
      //                     style: TextStyle(color: Colors.black, fontSize: 11),
      //                   ),
      //                 ),
      //                 SizedBox(
      //                   height: 45,
      //                   child: ListTile(
      //                     leading: CircleAvatar(
      //                       backgroundImage: NetworkImage(article.avatar),
      //                     ),
      //                     title: Text(
      //                       "By " + article.author,
      //                       style: TextStyle(fontSize: 12),
      //                     ),
      //                     subtitle: Text(
      //                       article.date,
      //                       style: TextStyle(fontSize: 11),
      //                     ),
      //                   ),
      //                 ),
      //                 Container(
      //                   padding: EdgeInsets.fromLTRB(16, 36, 16, 50),
      //                   child: HtmlWidget(
      //                     article.content,
      //                     webView: true,
      //                     textStyle: Theme.of(context).textTheme.bodyText1,
      //                   ),
      //                 ),
      //               ],
      //             ),
      //           ),
      //           relatedPosts(_futureRelatedArticles)
      //         ],
      //       ),
      //     )),
      // bottomNavigationBar: BottomAppBar(
      //   child: Container(
      //     decoration: BoxDecoration(color: Colors.white10),
      //     height: 50,
      //     padding: EdgeInsets.all(16),
      //     child: Row(
      //       mainAxisAlignment: MainAxisAlignment.spaceAround,
      //       children: <Widget>[
      //         FutureBuilder<dynamic>(
      //             future: favArticle,
      //             builder:
      //                 (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
      //               if (snapshot.hasData) {
      //                 return Container(
      //                   decoration: BoxDecoration(),
      //                   child: IconButton(
      //                     padding: EdgeInsets.all(0),
      //                     icon: Icon(
      //                       Icons.favorite,
      //                       color: Colors.red,
      //                       size: 24.0,
      //                     ),
      //                     onPressed: () {
      //                       // Favourite post
      //                       favArticleBloc.deleteFavArticleById(article.id);
      //                       setState(() {
      //                         favArticle =
      //                             favArticleBloc.getFavArticle(article.id);
      //                       });
      //                     },
      //                   ),
      //                 );
      //               }
      //               return Container(
      //                 decoration: BoxDecoration(),
      //                 child: IconButton(
      //                   padding: EdgeInsets.all(0),
      //                   icon: Icon(
      //                     Icons.favorite_border,
      //                     color: Colors.red,
      //                     size: 24.0,
      //                   ),
      //                   onPressed: () {
      //                     favArticleBloc.addFavArticle(article);
      //                     setState(() {
      //                       favArticle =
      //                           favArticleBloc.getFavArticle(article.id);
      //                     });
      //                   },
      //                 ),
      //               );
      //             }),
      //         Container(
      //           child: IconButton(
      //             padding: EdgeInsets.all(0),
      //             icon: Icon(
      //               Icons.comment,
      //               color: Colors.blue,
      //               size: 24.0,
      //             ),
      //             onPressed: () {
      //               Navigator.push(
      //                   context,
      //                   MaterialPageRoute(
      //                     builder: (context) => Comments(article.id),
      //                     fullscreenDialog: true,
      //                   ));
      //             },
      //           ),
      //         ),
      //         Container(
      //           child: IconButton(
      //             padding: EdgeInsets.all(0),
      //             icon: Icon(
      //               Icons.share,
      //               color: Colors.green,
      //               size: 24.0,
      //             ),
      //             onPressed: () {
      //               Share.share('Share the news: ' + article.link);
      //             },
      //           ),
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
    );
  }

  Widget relatedPosts(Future<List<dynamic>> latestArticles) {
    return FutureBuilder<List<dynamic>>(
      future: latestArticles,
      builder: (context, articleSnapshot) {
        if (articleSnapshot.hasData) {
          if (articleSnapshot.data.length == 0) return Container();
          return Column(
            children: <Widget>[
              Container(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.all(16),
                child: Text(
                  "Related Posts",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      fontFamily: "Poppins"),
                ),
              ),
              Column(
                children: articleSnapshot.data.map((item) {
                  final heroId = item.id.toString() + "-related";
                  return InkWell(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SingleArticle(item, heroId),
                        ),
                      );
                    },
                    child: articleBox(context, item, heroId),
                  );
                }).toList(),
              ),
              SizedBox(
                height: 24,
              )
            ],
          );
        } else if (articleSnapshot.hasError) {
          return Container(
              height: 500,
              alignment: Alignment.center,
              child: Text("${articleSnapshot.error}"));
        }
        return Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            height: 150,
            child: Loading(
                indicator: BallBeatIndicator(),
                size: 60.0,
                color: Theme.of(context).accentColor));
      },
    );
  }
}
