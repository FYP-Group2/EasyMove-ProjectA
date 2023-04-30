import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:driver_integrated/driver.dart';
import 'package:driver_integrated/LoginPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:driver_integrated/screen_size.dart';
import 'package:driver_integrated/SignupDetails.dart';
import 'package:driver_integrated/my_api_service.dart';
import 'package:driver_integrated/firebase_service.dart';
import 'package:driver_integrated/notification_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

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
      body: Stack(
        children: [
          Container(
            width: ScreenSize.screenWidth(context),
            height: ScreenSize.screenHeight(context),
            padding: EdgeInsets.symmetric(
                horizontal: ScreenSize.screenWidth(context) * 0.05,
                vertical: ScreenSize.screenHeight(context) * 0.15
            ),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: <Color>[
                      Color(0xFFffcc33),
                      Colors.orange.shade700
                    ]
                )
            ),
            child: Column(
              children: <Widget> [
                // Title
                Text(
                  "Welcome",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
                SizedBox(height: ScreenSize.screenHeight(context) * 0.1),
                // Company Logo
                Image.asset(
                  'assets/images/EMXicon.png',
                  width: 220,
                ),
                SizedBox(height: ScreenSize.screenHeight(context) * 0.1),
                // Login and Sign-Up Buttons
                Column(
                  children: <Widget>[
                    // Login Button
                    Container(
                        width: double.infinity,
                        height: 60,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white70),
                          borderRadius: BorderRadius.circular(50)
                              .copyWith(bottomRight: Radius.circular(0)
                          ),
                          gradient:  LinearGradient(
                              colors: <Color>[
                                Color(0xFFffcc33),
                                Colors.orange.shade700
                              ]
                          ),
                        ),
                        child: ElevatedButton(
                          onPressed: (){
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context)=> const LoginPage()
                                )
                            );
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
                            "Login",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 18
                            ),
                          ),
                        )
                    ),
                    // creating the signup button
                    SizedBox(height: ScreenSize.screenHeight(context) * 0.02),
                    // Sign-Up Button
                    Container(
                        width: double.infinity,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50)
                              .copyWith(bottomRight: Radius.circular(0)
                          ),
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 4,
                                color: Colors.black12.withOpacity(0.2),
                                offset: Offset(2,2)
                            )
                          ],
                          gradient:  LinearGradient(
                              colors: <Color>[
                                Color(0xFFffcc33),
                                Colors.orange.shade700
                              ]
                          ),
                        ),
                        child: ElevatedButton(
                          onPressed: (){
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context)=> SignupDetails()
                                )
                            );
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
          ),
          // Floating Noti Button
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
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
                onPressed: () async {
                await SharedPreferences.getInstance().then((pref) async{
                  if(pref.getString("tempusername") != null && pref.getString("tempusername") != "null") {
                    await MyApiService.getDriverId(pref.getString("tempusername")!).then((data) {
                      int id = data["auth_user"]["id"];
                      driver.initializeDriverId(id);
                      Navigator.push(context,
                        MaterialPageRoute(
                            builder: (context) => const NotificationView()
                        ),
                      );
                    });
                  } else if(pref.getString("username") != null && pref.getString("username") != "null") {
                    await MyApiService.getDriverId(pref.getString("username")!).then((data) {
                      int id = data["auth_user"]["id"];
                      driver.initializeDriverId(id);
                      Navigator.push(context,
                        MaterialPageRoute(
                            builder: (context) => const NotificationView()
                        ),
                      );
                    });
                  }
                });
              }
            ),
          )
        ],
      ),
    );
  }
}