// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:driver_integrated/LoginPage.dart';
import 'package:driver_integrated/SignupDetails.dart';
import 'package:getwidget/getwidget.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:driver_integrated/firebase_service.dart';
import 'package:firebase_core/firebase_core.dart';

@pragma('vm:entry-point')
Future<void> backgroundMessageHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  // await Firebase.initializeApp();
  FirebaseService firebaseService = FirebaseService();
  firebaseService.show(message.data["title"], message.data["body"]);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(backgroundMessageHandler);
  runApp(MyApp());
}

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
  FirebaseService firebaseService = FirebaseService();

  void initMyApp() async {
    await firebaseService.initialize().then((value) =>
        print("\n\n------\nMy Registration token : ${firebaseService.getFcmToken()}\n------"));
  }

  @override
  void initState() {
    super.initState();
    initMyApp();
  }

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