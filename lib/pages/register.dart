import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wordpress_app/Widgets/button.dart';
import 'package:flutter_wordpress_app/Widgets/textField.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class RegisterResponse {
  RegisterResponse({
    this.code,
    this.message,
  });

  int code;
  String message;

  factory RegisterResponse.fromJson(Map<String, dynamic> json) =>
      RegisterResponse(
        code: json["code"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
      };
}

Future<RegisterResponse> createAlbum(
    String firstname, lastname, username, password, email) async {
  final http.Response response = await http.post(
    'https://soleentrepreneur.co.uk/wp-json/wp/v2/users/register',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'first_name': firstname,
      'last_name': lastname,
      'username': username,
      'password': password,
      'email': email
    }),
  );

  if (response.statusCode == 200) {
    return RegisterResponse.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to create album.');
  }
}

class RegisterForm extends StatefulWidget {
  RegisterForm({Key key}) : super(key: key);

  @override
  _RegisterFormState createState() {
    return _RegisterFormState();
  }
}

class _RegisterFormState extends State<RegisterForm> {
  final TextEditingController controllerEmail = TextEditingController();
  final TextEditingController controllerPassword = TextEditingController();
  final TextEditingController controllerFirstName = TextEditingController();
  final TextEditingController controllerLastName = TextEditingController();
  final TextEditingController controllerUserName = TextEditingController();
  Future<RegisterResponse> _futureAlbum;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text('Create Data Example'),
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.of(context).pop()),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(8.0),
            child: (_futureAlbum == null)
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: 150,
                        child: Image.asset('assets/IMG_2382.PNG'),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 40, right: 40, bottom: 10),
                        child: textFieldCustom(
                            hintText: 'First Name',
                            labelText: 'First Name',
                            obscureText: false,
                            controller: controllerFirstName,
                            validator: (str) {
                              if (str.isEmpty) {
                                return 'Please enter First Name';
                              }
                              return null;
                            }),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 40, right: 40, bottom: 10),
                        child: textFieldCustom(
                            hintText: 'Last Name',
                            labelText: 'Last Name',
                            obscureText: false,
                            controller: controllerLastName,
                            validator: (str) {
                              if (str.isEmpty) {
                                return 'Please enter Last Name';
                              }
                              return null;
                            }),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 40, right: 40, bottom: 10),
                        child: textFieldCustom(
                            hintText: 'Username',
                            labelText: 'Username',
                            obscureText: false,
                            controller: controllerUserName,
                            validator: (str) {
                              if (str.isEmpty) {
                                return 'Please enter UserName';
                              }
                              return null;
                            }),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 40, right: 40, bottom: 10),
                        child: textFieldCustom(
                          hintText: 'Email',
                          labelText: 'Email',
                          obscureText: false,
                          validator: (str) =>
                              !str.contains('@') ? "Not a Valid Email!" : null,
                          controller: controllerEmail,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 40.0, right: 40),
                        child: textFieldCustom(
                            hintText: 'Password',
                            labelText: 'Password',
                            obscureText: true,
                            controller: controllerPassword,
                            validator: (str) =>
                                str.length <= 7 ? 'Not Valid Password' : null),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(50),
                        child: Center(
                            child: Text(
                                'By creating an account you agree to our Terms of Service and Privacy Policy')),
                      ),
                      AppButton(
                        buttonTitle: 'Register',
                        width: 170,
                        onPressed: () {
                          setState(() {
                            if (_formKey.currentState.validate()) {
                              _futureAlbum = createAlbum(
                                      controllerFirstName.text,
                                      controllerLastName.text,
                                      controllerUserName.text,
                                      controllerPassword.text,
                                      controllerEmail.text)
                                  .whenComplete(
                                      () => Navigator.pushNamed(context, '/'));
                            }
                          });
                        },
                      ),
                    ],
                  )
                : FutureBuilder<RegisterResponse>(
                    future: _futureAlbum,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Text(snapshot.data.code.toString());
                      } else if (snapshot.hasError) {
                        return Text("${snapshot.error}");
                      }

                      return CircularProgressIndicator();
                    },
                  ),
          ),
        ),
      ),
    );
  }
}
