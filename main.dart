// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:driver_integrated/LoginPage.dart';
import 'package:driver_integrated/SignupDetails.dart';
import 'package:getwidget/getwidget.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "EasyMove",
        theme: ThemeData(primarySwatch: Colors.indigo),
        home: Homepage(),
    );
  }
}

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.orange[400],
      body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.asset('assets/images/icon.png'),

          //log in button
          Padding(
            padding: EdgeInsets.only(top:30),
            child: GFButton(
              color: Colors.white,
              textColor: Colors.orange[400],
              onPressed: () {
                Navigator.push(context,
                  MaterialPageRoute(builder:(context) => LoginPage()),
                );
              },
              text: "Log In",
              textStyle: TextStyle(fontSize: 16,color: Colors.orange[400]),
              shape: GFButtonShape.pills,
            ),
          ),

          //sign up button
          Padding(
            padding: EdgeInsets.only(top:30),
            child: GFButton(
              color: Colors.white,
              textColor: Colors.orange[400],
              onPressed: () {
                Navigator.push(context,
                  MaterialPageRoute(builder:(context) => SignupDetails()),
                );
              },
              text: "Sign Up",
              textStyle: TextStyle(fontSize: 16,color: Colors.orange[400]),
              shape: GFButtonShape.pills,
            ),
          )
        ],
      ),
      )
    );
  }
}