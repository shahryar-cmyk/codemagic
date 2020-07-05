import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_wordpress_app/common/constants.dart';
import 'package:flutter_wordpress_app/models/Category.dart';
import 'package:flutter_wordpress_app/pages/category_articles.dart';
import 'package:flutter_wordpress_app/pages/search.dart';
import 'package:http/http.dart' as http;
import 'package:loading/indicator/ball_beat_indicator.dart';
import 'package:loading/loading.dart';

class Categories extends StatefulWidget {
  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  Future<List<dynamic>> _futureCategories;
  List<dynamic> categories = [];

  @override
  void initState() {
    super.initState();
    _futureCategories = fetchCategories();
  }

  Future<List<dynamic>> fetchCategories() async {
    try {
      var response = await http
          .get("$WORDPRESS_URL/wp-json/wp/v2/categories?per_page=100");

      if (this.mounted) {
        if (response.statusCode == 200) {
          setState(() {
            categories = json
                .decode(response.body)
                .map((m) => Category.fromJson(m))
                .toList();
          });

          return categories;
        }
      }
    } on SocketException {
      throw 'No Internet connection';
    }
    return categories;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            // color: Color.fromRGBO(124, 116, 146, 1)
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(color: Colors.white),
          child: Column(children: <Widget>[
            MyCustomForm(),
            getCategoriesList(_futureCategories),
          ]),
        ),
      ),
    );
  }

  Widget getCategoriesList(Future<List<dynamic>> categories) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      child: FutureBuilder<List<dynamic>>(
        future: categories,
        builder: (context, categorySnapshot) {
          if (categorySnapshot.hasData) {
            if (categorySnapshot.data.length == 0) return Text('No Data Found');
            return ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: categorySnapshot.data.length,
                itemBuilder: (BuildContext ctxt, int index) {
                  Category category = categorySnapshot.data[index];
                  if (category.parent == 0) {
                    return Column(
                      children: <Widget>[
                        Card(
                          elevation: 0,
                          margin: EdgeInsets.all(8),
                          child: ExpansionTile(
                            initiallyExpanded: false,
                            backgroundColor: Color(0xFFF9F9F9),
                            title: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CategoryArticles(
                                        category.id, category.name),
                                  ),
                                );
                              },
                              child: Text(
                                category.name,
                                style: Theme.of(context).textTheme.subtitle2,
                              ),
                            ),
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.all(4.0),
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: categorySnapshot.data.length,
                                    itemBuilder:
                                        (BuildContext ctxt2, int index2) {
                                      Category subCategory =
                                          categorySnapshot.data[index2];
                                      if (subCategory.parent == category.id) {
                                        return InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      CategoryArticles(
                                                          subCategory.id,
                                                          subCategory.name),
                                                ),
                                              );
                                            },
                                            child: ListTile(
                                              title: Text(subCategory.name),
                                            ));
                                      }
                                      return Container();
                                    }),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 1,
                          color: Theme.of(context).dividerColor,
                        ),
                      ],
                    );
                  }
                  return Container();
                });
          } else if (categorySnapshot.hasError) {
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
                      _futureCategories = fetchCategories();
                    },
                  )
                ],
              ),
            );
          }
          return Container(
              alignment: Alignment.center,
              child: Loading(
                  indicator: BallBeatIndicator(),
                  size: 60.0,
                  color: Theme.of(context).accentColor));
        },
      ),
    );
  }
}

class MyCustomForm extends StatefulWidget {
  @override
  _MyCustomFormState createState() => _MyCustomFormState();
}

// Define a corresponding State class.
// This class holds the data related to the Form.
class _MyCustomFormState extends State<MyCustomForm> {
  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final myController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30.0, right: 20.0, bottom: 40),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(width: 1, color: Color(0xfff0f5fd)),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(124, 116, 146, 0.1),
              blurRadius: 10.0, // has the effect of softening the shadow
              spreadRadius: 5.0, // has the effect of extending the shadow
              offset: Offset(
                0.0, // horizontal, move right 10
                10.0, // vertical, move down 10
              ),
            )
          ],
        ),
        child: Form(
          autovalidate: true,
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.only(left: 40.0),
            child: TextFormField(
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Search For Companies',
                labelText: 'Search For Companies',
                suffixIcon: IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Search()));
                      }
                    }),
              ),
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value.length < 2) {
                  return 'Name not long enough';
                }
              },
              controller: myController,
            ),
          ),
        ),
      ),
    );
  }
}
