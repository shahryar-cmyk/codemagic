import 'package:flutter/material.dart';
import 'package:flutter_wordpress_app/Widgets/button.dart';
import 'package:flutter_wordpress_app/Widgets/textField.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_wordpress_app/models/jsonUser.dart';
import 'package:flutter_wordpress_app/pages/articles.dart';

class LogIn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,
              color: Color.fromRGBO(124, 116, 146, 1)),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height * 1,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Image.asset(
                  'assets/IMG_2382.PNG',
                  height: 150,
                ),
              ),
              SizedBox(
                height: 100,
              ),
              LoginPage()
            ],
          ),
        ),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;
  String vali = '';
  @override
  void setState(fn) {
    vali = 'The Value you enter is false';
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: <Widget>[
                // headerSection(),
                textSection(),
                Center(
                    child: Text(
                  vali,
                  style: TextStyle(color: Colors.red),
                )),
                AppButton(
                  width: MediaQuery.of(context).size.width * 0.7,
                  buttonTitle: 'Continue',
                  onPressed: emailController.text == "" ||
                          passwordController.text == ""
                      ? null
                      : () {
                          setState(() {
                            _isLoading = true;
                          });
                          signIn(emailController.text, passwordController.text);
                        },
                ),
              ],
            ),
    );
  }

//Sign In Fuction and the post request to the Server
  signIn(String email, pass) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {'username': email, 'password': pass};
    var response = await http.post(
      "https://soleentrepreneur.co.uk/wp-json/jwt-auth/v1/token",
      body: data,
      headers: <String, String>{
        'Accept': 'application/json',
      },
    );
    var jsonResponse;
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      if (jsonResponse != null) {
        setState(() {
          _isLoading = false;
        });
        sharedPreferences.setString("token", jsonResponse['token']);
        // print(response.body);
        JsonUser jsonUser = new JsonUser.fromJson(jsonResponse);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (BuildContext context) => Articles(
                      userDisplayName: jsonUser.userDisplayName,
                      userRole: jsonUser.userRole,
                      userId: jsonUser.userId,
                      token: jsonUser.token,
                      userNicename: jsonUser.userNicename,
                      userEmail: jsonUser.userEmail,
                      avatar: jsonUser.avatar,
                    )),
            (Route<dynamic> route) => false);
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      // print(response.body);
      return jsonResponse;
    }
  }

  //
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  Container textSection() {
    return Container(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 40, right: 40, bottom: 30),
            child: textFieldCustom(
              hintText: 'Email',
              labelText: 'Email',
              obscureText: false,
              validator: (str) => !str.contains('@') && !str.contains('.com')
                  ? "Not a Valid Email!"
                  : null,
              controller: emailController,
            ),
          ),
          SizedBox(height: 30.0),
          Padding(
            padding: const EdgeInsets.only(left: 40.0, right: 40),
            child: textFieldCustom(
                hintText: 'Password',
                labelText: 'Password',
                obscureText: true,
                controller: passwordController,
                validator: (str) =>
                    str.length <= 7 ? 'Not Valid Password' : null),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30.0, bottom: 30),
            child: Container(
              width: 20,
              height: 5,
              decoration: BoxDecoration(
                border: Border.all(
                    width: 1, color: Color.fromRGBO(104, 97, 123, 1)),
                borderRadius: BorderRadius.circular(10),
                color: Color.fromRGBO(104, 97, 123, 1),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LoginScreenArguments {
  final String userEmail;
  final String userNicename;
  final String userDisplayName;
  final int userId;
  final String avatar;
  LoginScreenArguments(
      {this.userId,
      this.userEmail,
      this.userDisplayName,
      this.userNicename,
      this.avatar});
}
