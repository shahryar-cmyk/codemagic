import 'package:flutter/material.dart';

class Membership extends StatelessWidget {
  final String token;
  final String userEmail;
  final String userNicename;
  final String userDisplayName;
  final List<String> userRole;
  final int userId;
  final String avatar;

  const Membership(
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Membership',
          style: TextStyle(color: Color(0xff68617b)),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: (userRole[0] == 'subscriber')
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: InkWell(
                      onTap: null,
                      child: Container(
                        height: 159,
                        width: MediaQuery.of(context).size.width * 0.45,
                        decoration: BoxDecoration(
                          border:
                              Border.all(width: 1, color: Color(0xfff0f5fd)),
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.green,
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromRGBO(124, 116, 146, 0.09),
                              blurRadius:
                                  10.0, // has the effect of softening the shadow
                              spreadRadius:
                                  5.0, // has the effect of extending the shadow
                              offset: Offset(
                                0.0, // horizontal, move right 10
                                10.0, // vertical, move down 10
                              ),
                            )
                          ],
                        ),
                        child: Center(
                          child: Text(
                            'Customer MemberShip',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: InkWell(
                      onTap: () {},
                      child: Container(
                        height: 159,
                        width: MediaQuery.of(context).size.width * 0.45,
                        decoration: BoxDecoration(
                          border:
                              Border.all(width: 1, color: Color(0xfff0f5fd)),
                          borderRadius: BorderRadius.circular(10),
                          color: Color(0xfff0f5fd),
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromRGBO(124, 116, 146, 0.09),
                              blurRadius:
                                  10.0, // has the effect of softening the shadow
                              spreadRadius:
                                  5.0, // has the effect of extending the shadow
                              offset: Offset(
                                0.0, // horizontal, move right 10
                                10.0, // vertical, move down 10
                              ),
                            )
                          ],
                        ),
                        child: Center(
                          child: Text('Business MemberShip'),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: InkWell(
                      onTap: null,
                      child: Container(
                        height: 159,
                        width: MediaQuery.of(context).size.width * 0.45,
                        decoration: BoxDecoration(
                          border:
                              Border.all(width: 1, color: Color(0xfff0f5fd)),
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.green,
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromRGBO(124, 116, 146, 0.09),
                              blurRadius:
                                  10.0, // has the effect of softening the shadow
                              spreadRadius:
                                  5.0, // has the effect of extending the shadow
                              offset: Offset(
                                0.0, // horizontal, move right 10
                                10.0, // vertical, move down 10
                              ),
                            )
                          ],
                        ),
                        child: Center(
                          child: Text(
                            'Customer MemberShip',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: InkWell(
                      onTap: () {},
                      child: Container(
                        height: 159,
                        width: MediaQuery.of(context).size.width * 0.45,
                        decoration: BoxDecoration(
                          border:
                              Border.all(width: 1, color: Color(0xfff0f5fd)),
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.lightGreen,
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromRGBO(124, 116, 146, 0.09),
                              blurRadius:
                                  10.0, // has the effect of softening the shadow
                              spreadRadius:
                                  5.0, // has the effect of extending the shadow
                              offset: Offset(
                                0.0, // horizontal, move right 10
                                10.0, // vertical, move down 10
                              ),
                            )
                          ],
                        ),
                        child: Center(
                          child: Text(
                            'Business MemberShip',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
