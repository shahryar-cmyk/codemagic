import 'package:flutter_wordpress_app/pages/membership.dart';
import 'package:flutter_wordpress_app/widgets/switch.dart';
import 'package:flutter_wordpress_app/widgets/theme_notifier.dart';
import 'package:flutter_wordpress_app/widgets/values.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  final String token;
  final String userEmail;
  final String userNicename;
  final String userDisplayName;
  final List<String> userRole;
  final int userId;
  final String avatar;

  const SettingsPage(
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
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  var _darkTheme = true;
  var _notification = true;

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.of(context).pop()),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text(
              'Settings',
              style: Theme.of(context).textTheme.bodyText1.copyWith(
                    fontSize: MediaQuery.of(context).size.height * 0.05,
                  ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.01,
          ),
          Container(
            height: 2,
            color: Theme.of(context).dividerColor,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.01,
          ),
          ListTile(
            title: Text(
              'Dark Theme',
              style: Theme.of(context).textTheme.bodyText1.copyWith(
                    fontSize: MediaQuery.of(context).size.height * 0.027,
                  ),
            ),
            trailing: CustomSwitch(
              activeColor: Color(0xffd7ddf0),
              value: _darkTheme,
              onChanged: (val) {
                setState(() {
                  _darkTheme = val;
                });
                onThemeChanged(val, themeNotifier);
              },
            ),
          ),
          ListTile(
            leading: Text(
              'Privacy Look',
              style: Theme.of(context).textTheme.bodyText1.copyWith(
                    // color: (status == false) ? Color(0xff68617b) : Colors.white,

                    fontSize: MediaQuery.of(context).size.height * 0.027,
                  ),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: MediaQuery.of(context).size.height * 0.03,
            ),
            onTap: () {
              Navigator.pushNamed(context, '/privacy');
            },
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 2,
            color: Theme.of(context).dividerColor,
          ),
          SizedBox(
            height: 5,
          ),
          ListTile(
            leading: Text(' Notification',
                style: Theme.of(context).textTheme.bodyText1.copyWith(
                      fontSize: MediaQuery.of(context).size.height * 0.027,
                    )),
            trailing: CustomSwitch(
              activeColor: Color(0xffd7ddf0),
              value: _notification,
              onChanged: (val) {
                setState(() {
                  _notification = val;
                });
              },
            ),
          ),
          ListTile(
            leading: Text(
              ' App Badge',
              style: Theme.of(context).textTheme.bodyText1.copyWith(
                    fontSize: MediaQuery.of(context).size.height * 0.027,
                  ),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: MediaQuery.of(context).size.height * 0.03,
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('App Badge'),
                    content: Text('This is the first Realease'),
                  );
                },
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 5),
            child: Text(
              'Applications',
              style: Theme.of(context).textTheme.bodyText1.copyWith(
                    fontSize: MediaQuery.of(context).size.height * 0.05,
                  ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.01,
          ),
          Container(
            height: 2,
            color: Theme.of(context).dividerColor,
          ),
          // SizedBox(
          //   height: 5,
          // ),
          ListTile(
            leading: Text(
              'Upgrade to Business Account',
              style: Theme.of(context).textTheme.bodyText1.copyWith(
                    fontSize: MediaQuery.of(context).size.height * 0.027,
                  ),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: MediaQuery.of(context).size.height * 0.03,
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Membership(
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
            leading: Text(
              'Subscription info',
              style: Theme.of(context).textTheme.bodyText1.copyWith(
                    // color: (status == false) ? Color(0xff68617b) : Colors.white,

                    fontSize: MediaQuery.of(context).size.height * 0.027,
                  ),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: MediaQuery.of(context).size.height * 0.03,
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Subscription info'),
                    content: Text('Business Subscription is free til July'),
                    actions: <Widget>[
                      IconButton(
                        icon: Icon(Icons.touch_app),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Membership(
                                      token: widget.token,
                                      userEmail: widget.userEmail,
                                      userNicename: widget.userNicename,
                                      userDisplayName: widget.userDisplayName,
                                      userRole: widget.userRole,
                                      userId: widget.userId,
                                      avatar: widget.avatar)));
                        },
                      )
                    ],
                  );
                },
              );
            },
          ),
          ListTile(
              leading: Text(
                'About App',
                style: Theme.of(context).textTheme.bodyText1.copyWith(
                      fontSize: MediaQuery.of(context).size.height * 0.027,
                    ),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: MediaQuery.of(context).size.height * 0.03,
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('About App'),
                      content: Text(
                          'We are a new way of searching for a business or service, a simple and easy directory where small businesses are together under one roof. We are The Sole Entrepreneur! Our goal is to help people search and find different services in their local area. This can include anything from a contracted DiY man, catering companies to make up artists and hair vendors.'),
                    );
                  },
                );
              }),
        ],
      ),
    );
  }

  void onThemeChanged(bool value, ThemeNotifier themeNotifier) async {
    (value)
        ? themeNotifier.setTheme(darkTheme)
        : themeNotifier.setTheme(lightTheme);
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool('darkMode', value);
  }
}
