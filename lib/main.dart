// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:driver_integrated/my_api_service.dart';
import 'package:flutter/material.dart';
import 'package:driver_integrated/LoginPage.dart';
import 'package:driver_integrated/SignupDetails.dart';
import 'package:getwidget/getwidget.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:driver_integrated/firebase_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:driver_integrated/driver.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:driver_integrated/notification_view.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'firebase_options.dart';

@pragma('vm:entry-point')
Future<void> backgroundMessageHandler(RemoteMessage message) async {
  FirebaseService firebaseService = FirebaseService();
  await FlutterAppBadger.isAppBadgeSupported().then((value) => value?FlutterAppBadger.updateBadgeCount(1):null);
  firebaseService.show(message.data["title"], message.data["body"]);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(backgroundMessageHandler);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
        title: "EasyMove",
        theme: ThemeData(primarySwatch: Colors.indigo),
        home: const Homepage(),
    );
  }
}

class Homepage extends StatefulWidget {
  const Homepage({super.key});
  @override
  HomepageState createState() => HomepageState();
}

class HomepageState extends State<Homepage>{
  Driver driver = Driver();
  FirebaseService firebaseService = FirebaseService();

  void initMyApp() async {
    await firebaseService.initialize();
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
            padding: const EdgeInsets.only(top:30),
            child: GFButton(
              color: Colors.white,
              textColor: Colors.orange[400],
              onPressed: () {
                Navigator.push(context,
                  MaterialPageRoute(builder:(context) => const LoginPage()),
                );
              },
              text: "Log In",
              textStyle: TextStyle(fontSize: 16,color: Colors.orange[400]),
              shape: GFButtonShape.pills,
            ),
          ),

          //sign up button
          Padding(
            padding: const EdgeInsets.only(top:30),
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
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange[100],
        child: const Icon(Icons.notifications),
        onPressed: () async{
          await SharedPreferences.getInstance().then((pref) async{
            if(pref.getString("tempusername") != null && pref.getString("tempusername") != "null") {
              await MyApiService.getDriverId(pref.getString("tempusername")!).then((data) {
                int id = data["auth_user"]["id"];
                driver.initializeDriverId(id);
                Navigator.push(context,
                  MaterialPageRoute(
                      builder: (context) => const NotificationView()),
                );
              });
            }else if(pref.getString("username") != null && pref.getString("username") != "null"){
              await MyApiService.getDriverId(pref.getString("username")!).then((data) {
                int id = data["auth_user"]["id"];
                driver.initializeDriverId(id);
                Navigator.push(context,
                  MaterialPageRoute(
                      builder: (context) => const NotificationView()),
                );
              });
            }
          });

        }),

    );
  }
}