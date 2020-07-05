import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
//Used for the Featured Category ID, and the WordPress Rest Api Url
import 'package:flutter_wordpress_app/common/constants.dart';
//Used for the model of the Articles.
import 'package:flutter_wordpress_app/models/Article.dart';
import 'package:flutter_wordpress_app/pages/about.dart';
import 'package:flutter_wordpress_app/pages/categories.dart';
import 'package:flutter_wordpress_app/pages/favoutite_articles.dart';

import 'package:flutter_wordpress_app/pages/mainScreen.dart';
import 'package:flutter_wordpress_app/pages/membership.dart';
import 'package:flutter_wordpress_app/pages/profile.dart';
import 'package:flutter_wordpress_app/pages/setting.dart';

import 'package:flutter_wordpress_app/pages/single_Article.dart';
import 'package:flutter_wordpress_app/widgets/articleBox.dart';
import 'package:flutter_wordpress_app/widgets/articleBoxFeatured.dart';
//For Api Call we used the Http Package
import 'package:http/http.dart' as http;
//Used for Making Custom Beat indicator forLoading
import 'package:loading/indicator/ball_beat_indicator.dart';
import 'package:loading/loading.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Articles extends StatefulWidget {
  final String token;
  final String userEmail;
  final String userNicename;
  final String userDisplayName;
  final List<String> userRole;
  final int userId;
  final String avatar;

  const Articles(
      {Key key,
      @required this.token,
      @required this.userEmail,
      @required this.userNicename,
      @required this.userDisplayName,
      @required this.userRole,
      @required this.userId,
      @required this.avatar})
      : super(key: key);
  @override
  _ArticlesState createState() => _ArticlesState();
}

class _ArticlesState extends State<Articles> {
  //List of Featured Articles Used to Add the data from Api Call Future function
  List<dynamic> featuredArticles = [];
  //List of Latest Articles Used to Add the data from Api Call Future function
  List<dynamic> latestArticles = [];
  //List of Latest Articles get from the API when Future Builder Runs.
  Future<List<dynamic>> _futureLastestArticles;
  //List of Featured Article get from the API When Future Builder Runs.
  Future<List<dynamic>> _futureFeaturedArticles;
  //Scrolling Controller which load Data as the you Scroll UP
  ScrollController _controller;
  //Wordpress Post which is passed to the Api and get 10 post in Each Request.
  int page = 1;
  //For the Scroll Loading
  bool _infiniteStop;
  SharedPreferences sharedPreferences;

  @override
  void initState() {
    super.initState();
    _futureLastestArticles = fetchLatestArticles(1);
    _futureFeaturedArticles = fetchFeaturedArticles(1);
    //Intializing the Controller
    _controller =
        ScrollController(initialScrollOffset: 0.0, keepScrollOffset: true);
    //Add the Listner function which listen the scrolling
    _controller.addListener(_scrollListener);
    //Intializing the Scrolling to false because don't want to load all the data at once
    _infiniteStop = false;
    checkLoginStatus();
  }

  checkLoginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("token") == null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => MainScreen()),
          (Route<dynamic> route) => false);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

//Future Function for the fectching the Latest Posts from the API
  Future<List<dynamic>> fetchLatestArticles(int page) async {
    try {
      var response = await http.get(
          '$WORDPRESS_URL/wp-json/wp/v2/posts/?page=$page&per_page=10&_fields=id,date,title,content,custom,link');
      //All widgets have a bool this.mounted property. It is turns true when the buildContext is assigned. It is an error to call setState when a widget is unmounted.
      if (this.mounted) {
        if (response.statusCode == 200) {
          setState(
            () {
              //Add all the latest articles post to the Empty List of Articles named latestArticles
              latestArticles.addAll(json
                  .decode(response.body)
                  .map((m) => Article.fromJson(m))
                  .toList());
              //Stop the Scroll Loading When the post Articles are less than 10
              if (latestArticles.length % 10 != 0) {
                _infiniteStop = true;
              }
              print(_infiniteStop);
            },
          );
          return latestArticles;
        }
        setState(() {
          _infiniteStop = true;
        });
      }
      //Error Handling for No Internet Connection
    } on SocketException {
      throw 'No Internet connection';
    }
    return latestArticles;
  }

//Future Function for the fectching the Featured Post from the API Which is Simply a Category post Named as Featured
  Future<List<dynamic>> fetchFeaturedArticles(int page) async {
    try {
      var response = await http.get(
          "$WORDPRESS_URL/wp-json/wp/v2/posts/?categories[]=$FEATURED_ID&page=$page&per_page=10&_fields=id,date,title,content,custom,link");
//All widgets have a bool this.mounted property. It is turns true when the buildContext is assigned. It is an error to call setState when a widget is unmounted.
      if (this.mounted) {
        if (response.statusCode == 200) {
          setState(() {
            //Add all the Featured articles to the Empty List of Articles named featuredArticles
            featuredArticles.addAll(json
                .decode(response.body)
                .map((m) => Article.fromJson(m))
                .toList());
          });
          //Stop the Scroll Loading When the post Articles are less than 10
          // if (latestArticles.length % 10 != 0) {
          //   _infiniteStop = true;
          // }
          // print(_infiniteStop);

          return featuredArticles;
        } else {
          setState(() {
            _infiniteStop = true;
          });
        }
      }
    } on SocketException {
      throw 'No Internet connection';
    }
    return featuredArticles;
  }

//
  _scrollListener() {
    //
    var isEnd = _controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange;
    if (isEnd) {
      setState(() {
        //if we are at the End of the ScrollView then set the page number of the rest api to 2 and call the future Latest Posts.
        page += 1;
        _futureLastestArticles = fetchLatestArticles(page);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: InkWell(
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,

                image: DecorationImage(
                  image: NetworkImage('${widget.avatar}'),
                ),
                // border: Border.all(width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    offset: const Offset(0.0, 5.0),
                    blurRadius: 10.0,
                    spreadRadius: 0.0,
                  ),
                ],
              ),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Profile(
                          token: widget.token,
                          userEmail: widget.userEmail,
                          userNicename: widget.userNicename,
                          userDisplayName: widget.userDisplayName,
                          userRole: widget.userRole,
                          userId: widget.userId,
                          avatar: widget.avatar)));
            },
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingsPage(
                        token: widget.token,
                        userEmail: widget.userEmail,
                        userNicename: widget.userNicename,
                        userDisplayName: widget.userDisplayName,
                        userRole: widget.userRole,
                        userId: widget.userId,
                        avatar: widget.avatar),
                  ),
                );
              },
            )
          ],
        ),
        drawer: Drawer(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                DrawerHeader(
                  decoration: BoxDecoration(color: Colors.white),
                  child: Image.asset(
                    'assets/IMG_2382.PNG',
                  ),
                ),
                Column(
                  children: <Widget>[
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 1 / 10,
                    ),
                    ListTile(
                      leading: Icon(Icons.dashboard),
                      title: Text('Dashbord'),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Articles(
                                    userDisplayName: widget.userDisplayName,
                                    userRole: widget.userRole,
                                    userId: widget.userId,
                                    token: widget.token,
                                    userNicename: widget.userNicename,
                                    userEmail: widget.userEmail,
                                    avatar: widget.avatar)));
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.comment),
                      title: Text('Categories'),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        // Navigator.of(context).pushNamed('/search');
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Categories()));
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.category),
                      title: Text('About us'),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AboutPage()));
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.favorite),
                      title: Text('Favourite'),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FavouriteArticles(),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.shopping_basket),
                      title: Text('Membership'),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        // Navigator.pushNamed(context, Membership.routeName,
                        //     arguments: JsonUser(
                        //         avatar: args.avatar,
                        //         userDisplayName: args.userDisplayName,
                        //         userId: args.userId,
                        //         token: args.token,
                        //         userEmail: args.userEmail,
                        //         userNicename: args.userNicename,
                        //         userRole: args.userRole));
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Membership(
                                    userDisplayName: widget.userDisplayName,
                                    userRole: widget.userRole,
                                    userId: widget.userId,
                                    token: widget.token,
                                    userNicename: widget.userNicename,
                                    userEmail: widget.userEmail,
                                    avatar: widget.avatar)));
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.person),
                      title: Text('My Profile'),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Profile(
                                    token: widget.token,
                                    userEmail: widget.userEmail,
                                    userNicename: widget.userNicename,
                                    userDisplayName: widget.userDisplayName,
                                    userRole: widget.userRole,
                                    userId: widget.userId,
                                    avatar: widget.avatar)));
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.exit_to_app),
                      title: Text('Log Out'),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        sharedPreferences.clear();

                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    MainScreen()),
                            (Route<dynamic> route) => false);
                      },
                    )
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Colors.grey[200], width: 1),
                    ),
                  ),
                  height: 50,
                  child: ListTile(
                    leading: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,

                        image: DecorationImage(
                          image: NetworkImage('${widget.avatar}'),
                        ),
                        // border: Border.all(width: 1),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            offset: const Offset(0.0, 10.0),
                            blurRadius: 10.0,
                            spreadRadius: 1.0,
                          ),
                        ],
                      ),
                    ),
                    title: Text('${widget.userDisplayName}'),
                    trailing: Icon(Icons.more_horiz),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Profile(
                                  token: widget.token,
                                  userEmail: widget.userEmail,
                                  userNicename: widget.userNicename,
                                  userDisplayName: widget.userDisplayName,
                                  userRole: widget.userRole,
                                  userId: widget.userId,
                                  avatar: widget.avatar)));
                    },
                  ),
                )
              ],
            ),
          ),
        ),
        body: Container(
          decoration: BoxDecoration(color: Colors.white70),
          child: SingleChildScrollView(
            controller: _controller,
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Featured Posts',
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2
                      .copyWith(fontSize: 20),
                ),
                SizedBox(
                  height: 20,
                ),
                featuredPost(_futureFeaturedArticles),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Trending Posts',
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2
                      .copyWith(fontSize: 20),
                ),
                SizedBox(
                  height: 20,
                ),
                featuredPost(_futureFeaturedArticles),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Picks For You',
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2
                      .copyWith(fontSize: 20),
                ),
                latestPosts(_futureLastestArticles)
              ],
            ),
          ),
        ));
  }

  Widget latestPosts(Future<List<dynamic>> latestArticles) {
    return FutureBuilder<List<dynamic>>(
      future: latestArticles,
      builder: (context, articleSnapshot) {
        if (articleSnapshot.hasData) {
          if (articleSnapshot.data.length == 0) return Container();
          return Column(
            children: <Widget>[
              Column(
                  children: articleSnapshot.data.map((item) {
                //Hero Id is the ID of the WordPress Post
                final heroId = item.id.toString() + "-latest";
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        //Go to the Article Decription Page Where You Mark the Field Favourite
                        builder: (context) => SingleArticle(item, heroId),
                      ),
                    );
                  },
                  //Comming Back After
                  child: articleBox(context, item, heroId),
                );
              }).toList()),
              //Check the Condition for if the
              !_infiniteStop
                  ? Container(
                      alignment: Alignment.center,
                      height: 30,
                      child: Loading(
                          indicator: BallBeatIndicator(),
                          size: 60.0,
                          color: Theme.of(context).accentColor))
                  : Container()
            ],
          );
        } else if (articleSnapshot.hasError) {
          return Container();
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

  Widget featuredPost(Future<List<dynamic>> featuredArticles) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: FutureBuilder<List<dynamic>>(
        future: featuredArticles,
        builder: (context, articleSnapshot) {
          if (articleSnapshot.hasData) {
            if (articleSnapshot.data.length == 0) return Container();
            return Row(
                children: articleSnapshot.data.map((item) {
              final heroId = item.id.toString() + "-featured";
              return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SingleArticle(item, heroId),
                      ),
                    );
                  },
                  child: articleBoxFeatured(context, item, heroId));
            }).toList());
          } else if (articleSnapshot.hasError) {
            return Container(
              alignment: Alignment.center,
              margin: EdgeInsets.fromLTRB(0, 60, 0, 0),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: <Widget>[
                  Image.asset(
                    "assets/no-internet.png",
                    width: 250,
                  ),
                  Text("No Internet Connection."),
                  FlatButton.icon(
                    icon: Icon(Icons.refresh),
                    label: Text("Reload"),
                    onPressed: () {
                      _futureLastestArticles = fetchLatestArticles(1);
                      _futureFeaturedArticles = fetchFeaturedArticles(1);
                      // Text('Data is Loading Please Wait.');
                    },
                  )
                ],
              ),
            );
          }
          return Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              height: 280,
              child: Loading(
                  indicator: BallBeatIndicator(),
                  size: 60.0,
                  color: Theme.of(context).accentColor));
        },
      ),
    );
  }
}
