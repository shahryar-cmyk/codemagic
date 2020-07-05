import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_wordpress_app/models/wordpress_create_post.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_wordpress_app/widgets/textField.dart';
import 'package:flutter_wordpress_app/widgets/button.dart';

class AddBusiness extends StatefulWidget {
  final String token;

  const AddBusiness({Key key, @required this.token}) : super(key: key);

  @override
  _AddBusinessState createState() => _AddBusinessState();
}

class _AddBusinessState extends State<AddBusiness> {
  File _image;

  Future getImage() async {
    var image = await ImagePicker().getImage(source: ImageSource.gallery);

    setState(() {
      _image = File(image.path);
    });
  }

  //===========================================================================================
  //Getting the Category from DropDown

  int _currentImageId;
  final _formKey = GlobalKey<FormState>();
  CategoryWp _currentCategory;
  // final String uri = 'https://jsonplaceholder.typicode.com/users';

//add at 48 Line of Image_upload
  final String uri2 =
      'https://soleentrepreneur.co.uk/wp-json/wp/v2/categories?per_page=40';
  Future<List<CategoryWp>> _fetchCategory() async {
    var response = await http.get(uri2);

    if (response.statusCode == 200) {
      final categoryItem =
          json.decode(response.body).cast<Map<String, dynamic>>();
      List<CategoryWp> listOfCategories = categoryItem.map<CategoryWp>((json) {
        return CategoryWp.fromJson(json);
      }).toList();
      return listOfCategories;
    } else {
      throw Exception('Failed to load internet');
    }
  }

//==============================================================================================
  //Post Upload Image
  Future<String> upload(File imageFile) async {
    // open a bytestream
    var stream = new http.ByteStream(DelegatingStream(imageFile.openRead()));
    // get file length
    var length = await imageFile.length();

    // string to uri
    var uri = Uri.parse("https://soleentrepreneur.co.uk/wp-json/wp/v2/media");

    // create multipart request
    var request = new http.MultipartRequest("POST", uri);

    // multipart that takes file
    var multipartFile = new http.MultipartFile('file', stream, length,
        filename: basename(imageFile.path));

    // add file to multipart
    request.files.add(multipartFile);

    //multipart that take headers
    Map<String, String> headers = {
      "Authorization": "Bearer ${widget.token}",
      "Content-Disposition": "attachment;filename=1.png",
      "Content-Type": "image/png"
    };

    // add header to multipart
    request.headers.addAll(headers);

    // // send
    // var response = await request.send();
    // print(response.statusCode);

    // // listen for response
    // response.stream.transform(utf8.decoder).listen((value) {
    //   print(value);
    // });
    http.Response response =
        await http.Response.fromStream(await request.send());
    print("Result: ${response.statusCode}");
    var convertDatatoJson = jsonDecode(response.body);
    print('Result2: $convertDatatoJson');
    return response.body;
  }

//Get Categories of WordPress Post

//================================================================================================
//Text Values of Business
  final TextEditingController businessNameController =
      new TextEditingController();
  final TextEditingController businessLogoController =
      new TextEditingController();
  final TextEditingController businessBioController =
      new TextEditingController();
  final TextEditingController businessEmailController =
      new TextEditingController();
  final TextEditingController businessWebsiteController =
      new TextEditingController();
  final TextEditingController businessInstragramController =
      new TextEditingController();
  final TextEditingController businessTwitterController =
      new TextEditingController();
  final TextEditingController businessNumberController =
      new TextEditingController();
  //Post Business Page
  Future<WordPressCreatePost> _futureAlbum;
  // final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Future<WordPressCreatePost> postBusiness(
      String businessName,
      String businessBio,
      String email,
      String businessWebsite,
      String businessInstragram,
      String businessTwitter,
      String businessNumber,
      // int imageID,
      int categoryID,
    ) async {
      final http.Response response = await http.post(
        'https://soleentrepreneur.co.uk/wp-json/wp/v2/posts?_fields=title.rendered,content.rendered',
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}',
        },
        body: jsonEncode(<String, String>{
          "title": "$businessName",
          "content":
              "$businessBio+<br>Email:$email<br>Business Website:$businessWebsite+<br>+Instragram:$businessInstragram<br>Twitter:$businessTwitter<br>Number:$businessNumber",
          // "featured_media": "$imageID",
          "status": "publish",
          "categories": "$categoryID"
        }),
      );

      if (response.statusCode == 201) {
        return WordPressCreatePost.fromJson(json.decode(response.body));
      } else {
        throw Exception('Response Status Code :${response.statusCode}');
      }
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Add Your Business'),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Form(
              key: _formKey,
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(8.0),
                child: (_futureAlbum == null)
                    ? Column(
                        children: <Widget>[
                          textFieldCustom(
                            hintText: 'Business Name',
                            labelText: 'Business Name',
                            icon: Icon(Icons.business),
                            controller: businessNameController,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },
                            inputType: TextInputType.text,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: InkWell(
                              onTap: getImage,
                              child: Container(
                                height: 60,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Color(0xfff0f5fd),
                                  border: Border.all(
                                      width: 1, color: Color(0xfff0f5fd)),
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color.fromRGBO(124, 116, 146, 0.1),
                                      blurRadius:
                                          10.0, // has the effect of softening the shadow
                                      spreadRadius:
                                          5.0, // has the effect of extending the shadow
                                      offset: Offset(
                                        0.0, // horizontal, move right 10
                                        10.0, // vertical, move down 10
                                      ),
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 47.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              Icon(
                                                Icons.all_inclusive,
                                                color: Color(0xff82867d),
                                              ),
                                              SizedBox(
                                                width: 20,
                                              ),
                                              Text(
                                                'Logo',
                                                style: TextStyle(
                                                    color: Color(0xff82867d)),
                                              ),
                                            ],
                                          ),
                                          Container(
                                            padding: EdgeInsets.only(
                                                left: 20, top: 10),
                                            child: _image == null
                                                ? Text('No image selected.')
                                                : Container(
                                                    width: 30,
                                                    height: 30,
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50.0),
                                                      child: Image.file(
                                                        _image,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                          )
                                        ],
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 40.0),
                                        child: Icon(
                                          Icons.add,
                                          size: 15,
                                          color: Color(0xffaab2b7),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Column(
                              children: <Widget>[
                                Stack(
                                  children: <Widget>[
                                    CircleAvatar(
                                      backgroundImage: _image == null
                                          ? NetworkImage(
                                              'https://git.unilim.fr/assets/no_group_avatar-4a9d347a20d783caee8aaed4a37a65930cb8db965f61f3b72a2e954a0eaeb8ba.png')
                                          : FileImage(_image),
                                      radius: 50.0,
                                    ),
                                    InkWell(
                                      onTap: getImage,
                                      child: Container(
                                          padding: EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(40.0),
                                              color: Colors.black),
                                          margin: EdgeInsets.only(
                                              left: 70, top: 70),
                                          child: Icon(
                                            Icons.photo_camera,
                                            size: 25,
                                            color: Colors.white,
                                          )),
                                    ),
                                  ],
                                ),
                                FutureBuilder(
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.none) {
                                      return Text('No Image is Selected');
                                    }
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return CircularProgressIndicator();
                                    }
                                    if (snapshot.hasData) {
                                      var jsonbody = jsonDecode(snapshot.data);

                                      _currentImageId = (jsonbody['id'] == null
                                          ? jsonbody['id']
                                          : 2750);

                                      return Column(
                                        children: <Widget>[
                                          Text('Image Uploaded Successfully'),
                                          SizedBox(
                                            height: 30,
                                          ),
                                          textFieldCustom(
                                            icon: Icon(Icons.event),
                                            hintText: 'Image ID',
                                            labelText: 'Image ID',
                                            enabled: false,
                                            value: jsonbody['id'].toString(),
                                            inputType: TextInputType.text,
                                          ),
                                        ],
                                      );
                                    }

                                    // if (snapshot.connectionState == ConnectionState.done) {
                                    //   return Text(snapshot.data.toString());
                                    // }
                                    return Text('No Image is Selected');
                                  },
                                  future: upload(_image),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Container(
                            height: 300,
                            width: double.infinity,
                            child: textFieldCustom(
                                controller: businessBioController,
                                inputType: TextInputType.text,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter some text';
                                  }
                                  return null;
                                },
                                icon: Icon(
                                  Icons.airport_shuttle,
                                ),
                                labelText: 'Bio',
                                hintText: 'Tell us About your Business'),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          textFieldCustom(
                            labelText: 'Email',
                            hintText: 'Email',
                            icon: Icon(Icons.email),
                            controller: businessEmailController,
                            inputType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          textFieldCustom(
                            icon: Icon(Icons.web),
                            hintText: 'Website',
                            labelText: 'Website',
                            controller: businessWebsiteController,
                            inputType: TextInputType.url,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          textFieldCustom(
                            icon: Icon(Icons.insert_link),
                            hintText: 'Instragram',
                            labelText: 'Instragram',
                            controller: businessInstragramController,
                            inputType: TextInputType.text,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          textFieldCustom(
                            icon: Icon(Icons.insert_link),
                            hintText: 'Twitter',
                            labelText: 'Twitter',
                            controller: businessTwitterController,
                            inputType: TextInputType.text,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          textFieldCustom(
                            icon: Icon(Icons.phone),
                            hintText: 'Business Number',
                            labelText: 'Business Number',
                            controller: businessNumberController,
                            inputType: TextInputType.phone,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                //  Add in ImageUpload Line 409
                                FutureBuilder<List<CategoryWp>>(
                                    future: _fetchCategory(),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<List<CategoryWp>>
                                            snapshot) {
                                      List<CategoryWp> categories =
                                          snapshot.data;

                                      if (!snapshot.hasData) {
                                        return CircularProgressIndicator();
                                      }

                                      return Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                1,
                                        decoration: BoxDecoration(
                                          color: Color(0xfff0f5fd),
                                          border: Border.all(
                                              width: 1,
                                              color: Color(0xfff0f5fd)),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Color.fromRGBO(
                                                  124, 116, 146, 0.2),
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
                                        ),
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.08,
                                        child: DropdownButton<CategoryWp>(
                                            isExpanded: true,
                                            value: categories[0],
                                            hint: Text('Select Category'),
                                            items: categories
                                                .map((cat) => DropdownMenuItem<
                                                        CategoryWp>(
                                                      child: Text(cat.name),
                                                      value: cat,
                                                    ))
                                                .toList(),
                                            onChanged:
                                                (CategoryWp selectedCategory) {
                                              setState(() {
                                                _currentCategory =
                                                    selectedCategory;
                                              });
                                            }),
                                      );
                                    }),
                                SizedBox(height: 20.0),
                                _currentCategory != null
                                    ? Text("Name: " +
                                        _currentCategory.name +
                                        "\n ID: " +
                                        _currentCategory.id.toString())
                                    : Text("No User selected"),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          AppButton(
                              buttonTitle: 'Submit',
                              width: MediaQuery.of(context).size.height * 0.8,
                              onPressed: () {
                                if (_formKey.currentState.validate()) {
                                  setState(() {
                                    _futureAlbum = postBusiness(
                                        businessNameController.text,
                                        businessBioController.text,
                                        businessEmailController.text,
                                        businessWebsiteController.text,
                                        businessInstragramController.text,
                                        businessTwitterController.text,
                                        businessNumberController.text,
                                        // _currentImageId,
                                        (_currentCategory) != null
                                            ? _currentCategory.id
                                            : 1);
                                  });
                                }
                              }),
                          // Container(
                        ],
                      )
                    : FutureBuilder<WordPressCreatePost>(
                        future: _futureAlbum,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            // return Text(snapshot.data.title.rendered);
                            return Center(
                              child: CupertinoAlertDialog(
                                title: Text(
                                  'Business',
                                  style: TextStyle(color: Colors.grey),
                                ),
                                content: Text(
                                    'Your Business is Live in the Community Now.Horray!!!'),
                                actions: <Widget>[
                                  CupertinoDialogAction(
                                    child: Text('Go to Main Page'),
                                    onPressed: () {
                                      Navigator.pushNamed(
                                          context, '/ScreenAfterLogin');
                                    },
                                  ),
                                ],
                              ),
                            );
                          } else if (snapshot.hasError) {
                            return Text("${snapshot.error}");
                          }

                          return CircularProgressIndicator();
                        },
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CategoryWp {
  int id;
  String name;

  CategoryWp({this.id, this.name});

  factory CategoryWp.fromJson(Map<String, dynamic> json) {
    return new CategoryWp(id: json['id'], name: json['name']);
  }
}
