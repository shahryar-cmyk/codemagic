import 'package:flutter/material.dart';
import 'package:flutter_wordpress_app/pages/login.dart';
import 'package:flutter_wordpress_app/pages/register.dart';
import 'package:flutter_wordpress_app/widgets/button.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Testing'),
      // ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Image.asset('assets/IMG_2382.PNG'),
          Column(
            children: <Widget>[
              AppButton(
                width: 170,
                buttonTitle: 'Log In',
                onPressed: () => Navigator.push(
                    context, MaterialPageRoute(builder: (context) => LogIn())),
              ),
              SizedBox(
                height: 20,
              ),
              AppButton(
                buttonTitle: 'Register',
                onPressed:() => Navigator.push(
                    context, MaterialPageRoute(builder: (context) => RegisterForm())),
                width: 170,
              ),
            ],
          )
        ],
      ),
    );
  }
}
