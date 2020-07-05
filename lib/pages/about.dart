import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.of(context).pop()),
        title: Text(
          'About Us',
          style: TextStyle(color: Color(0xff68617b)),
        ),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'We are a new way of searching for a business or service, a simple and easy directory where small businesses are together under one roof. We are The Sole Entrepreneur!.',
            textAlign: TextAlign.justify,
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            'Our goal is to help people search and find different services in their local area. This can include anything from a contracted DiY man, catering companies to make up artists and hair vendors.',
            textAlign: TextAlign.justify,
          ),
          SizedBox(
            height: 12,
          ),
          Text(
            'The Sole Entrepreneur is a listing which will include your details, your reviews and your portfolio.',
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }
}
