// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// import 'package:driver_integrated/my_api_service.dart';
// import 'package:flutter/material.dart';
// import 'package:driver_integrated/LoginPage.dart';
// import 'package:driver_integrated/SignupDetails.dart';
// import 'package:getwidget/getwidget.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:driver_integrated/firebase_service.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:driver_integrated/driver.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:driver_integrated/notification_view.dart';
// import 'package:flutter_app_badger/flutter_app_badger.dart';
// import 'firebase_options.dart';

// @pragma('vm:entry-point')
// Future<void> backgroundMessageHandler(RemoteMessage message) async {
//   FirebaseService firebaseService = FirebaseService();
//   await FlutterAppBadger.isAppBadgeSupported().then((value) => value?FlutterAppBadger.updateBadgeCount(1):null);
//   firebaseService.show(message.data["title"], message.data["body"]);
// }

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//   FirebaseMessaging.onBackgroundMessage(backgroundMessageHandler);
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//         title: "EasyMove",
//         theme: ThemeData(primarySwatch: Colors.indigo),
//         home: const Homepage(),
//     );
//   }
// }

// class Homepage extends StatefulWidget {
//   const Homepage({super.key});
//   @override
//   HomepageState createState() => HomepageState();
// }

// class HomepageState extends State<Homepage>{
//   Driver driver = Driver();
//   FirebaseService firebaseService = FirebaseService();

//   void initMyApp() async {
//     await firebaseService.initialize();
//   }

//   @override
//   void initState() {
//     super.initState();
//     initMyApp();
//   }

//   @override
//   Widget build(BuildContext context){
//     return Scaffold(
//       backgroundColor: Colors.orange[400],
//       body: Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: <Widget>[
//           Image.asset('assets/images/icon.png'),

//           //log in button
//           Padding(
//             padding: const EdgeInsets.only(top:30),
//             child: GFButton(
//               color: Colors.white,
//               textColor: Colors.orange[400],
//               onPressed: () {
//                 Navigator.push(context,
//                   MaterialPageRoute(builder:(context) => const LoginPage()),
//                 );
//               },
//               text: "Log In",
//               textStyle: TextStyle(fontSize: 16,color: Colors.orange[400]),
//               shape: GFButtonShape.pills,
//             ),
//           ),

//           //sign up button
//           Padding(
//             padding: const EdgeInsets.only(top:30),
//             child: GFButton(
//               color: Colors.white,
//               textColor: Colors.orange[400],
//               onPressed: () {
//                 Navigator.push(context,
//                   MaterialPageRoute(builder:(context) => SignupDetails()),
//                 );
//               },
//               text: "Sign Up",
//               textStyle: TextStyle(fontSize: 16,color: Colors.orange[400]),
//               shape: GFButtonShape.pills,
//             ),
//           )
//         ],
//       ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: Colors.orange[100],
//         child: const Icon(Icons.notifications),
//         onPressed: () async{
//           await SharedPreferences.getInstance().then((pref) async{
//             if(pref.getString("tempusername") != null && pref.getString("tempusername") != "null") {
//               await MyApiService.getDriverId(pref.getString("tempusername")!).then((data) {
//                 int id = data["auth_user"]["id"];
//                 driver.initializeDriverId(id);
//                 Navigator.push(context,
//                   MaterialPageRoute(
//                       builder: (context) => const NotificationView()),
//                 );
//               });
//             }else if(pref.getString("username") != null && pref.getString("username") != "null"){
//               await MyApiService.getDriverId(pref.getString("username")!).then((data) {
//                 int id = data["auth_user"]["id"];
//                 driver.initializeDriverId(id);
//                 Navigator.push(context,
//                   MaterialPageRoute(
//                       builder: (context) => const NotificationView()),
//                 );
//               });
//             }
//           });

//         }),

//     );
//   }
// }




// updated by alice n angel
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
      body: SafeArea(
        child: Container(
          // we will give media query height
          // double.infinity make it big as my parent allows
          // while MediaQuery make it big as per the screen
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: <Color>[Color(0xFFffcc33), Colors.orange.shade700])
            ),
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 80),
            child: SingleChildScrollView(
              child: Column(
                // even space distribution
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                verticalDirection: VerticalDirection.down,
                children: <Widget>[
                  Column(
                    children: const <Widget>[
                      Text(
                        "Welcome",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 30,

                        ),

                      ),
                      SizedBox(
                        height: 100,
                      ),
                    ],
                  ),
                  Container(
                    child: Image.asset(
                      'assets/images/EMXicon.png',
                      width: 250,
                    ),
                  ),
                  SizedBox(
                    height: 100,
                  ),
                  Column(
                    children: <Widget>[
                      // the login button
                      MaterialButton(
                        minWidth: double.infinity,
                        height: 60,
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));

                        },
                        // defining the shape
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                              color: Colors.white70
                          ),
                          borderRadius: BorderRadius.circular(50)
                              .copyWith(bottomRight: Radius.circular(0)),
                        ),
                        child: Text(
                          "Login",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 18
                          ),
                        ),
                      ),
                      // creating the signup button
                      SizedBox(height:20),
                      Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 4,
                                  color: Colors.black12.withOpacity(0.2),
                                  offset: Offset(2,2)
                              )
                            ],
                            gradient:  LinearGradient(
                                colors: <Color>[Color(0xFFffcc33), Colors.orange.shade700]),
                            borderRadius: BorderRadius.circular(50)
                                .copyWith(bottomRight: Radius.circular(0)),
                          ),
                          width: double.infinity,
                          height: 60,

                          child: ElevatedButton(
                            onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=> SignupDetails()));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)
                                    .copyWith(bottomRight: Radius.circular(0)),
                              ),
                            ),
                            child: Text(
                              "Sign up",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18
                              ),
                            ),
                          )
                      ),
                    ] ,
                  )



                ],
              ),
            )

        ),
      ),

      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Container(
            height: 70,
            width: 70,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white24, width: 1.5),
              color:Color(0xffffcc33) ,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.notifications,
              color: Colors.white,
            ),
          ),
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