import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mmm_anonymeet/login_page.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return StartState();
  }
}

class StartState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Image(
                image: AssetImage("assets/icon.png"),
                height: 100.0,
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 20)),
            CircularProgressIndicator(
              backgroundColor: Colors.pinkAccent,
              strokeWidth: 2,

            )
          ],
        ),
      ),
    );
  }

  startTimer() async {
    var duration = new Duration(seconds: 6);
    return new Timer(duration, route);
  }

  route() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }
}
