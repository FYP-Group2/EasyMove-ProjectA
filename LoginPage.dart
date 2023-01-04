import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:driver_integrated/NavBar.dart';
import 'package:driver_integrated/driver.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:driver_integrated/my_api_service.dart';
import 'package:driver_integrated/firebase_service.dart';


String? response_message;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Driver driver = Driver();
  // NotificationService notificationService = NotificationService();
  bool userIsLoggedIn = false;
  FirebaseService firebaseService = FirebaseService();

  Future<void> getLoggedInState() async{
    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var username = prefs.getString("username");
    var password = prefs.getString("password");

    if(username != null && password != null){
      if(username != "null" && password != "null") {
        print("Username: $username, Password: $password");
        final Map<String, String> body = {
          "username": username,
          "password": password
        };

        Map<String, dynamic> data = await MyApiService.driverLogIn(body);
        dynamic authUser = data["auth_user"];
        int id = authUser["id"];
        int region = authUser["region"];
        int vehicleType = authUser["vehicle_type"];
        String name = authUser["name"];
        int mobileNumber = authUser["mobile_number"];
        driver.initializeDriver(id, region, vehicleType, name, mobileNumber);
        userIsLoggedIn = true;
      }
    }

    print(username);
  }

  @override
  void initState() {
    super.initState();

    getLoggedInState();
    Future.delayed(const Duration(seconds: 3), (){
      if(userIsLoggedIn) {
        MyApiService.updateToken(driver.id, firebaseService.fcmToken!);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => const NavBar( currentPage: PageItem.Home,)),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Future<void> makePostRequest(Map<String, String> requestBody, bool newLogIn) async {
      Map<String, dynamic> data = await MyApiService.driverLogIn(requestBody);
      dynamic authUser = data["auth_user"];
      response_message = (data["auth_user"]["message"]);

      if (response_message == "Login successfully.") {
        int id = authUser["id"];
        int region = authUser["region"];
        int vehicleType = authUser["vehicle_type"];
        String name = authUser["name"];
        int mobileNumber = authUser["mobile_number"];
        driver.initializeDriver(id, region, vehicleType, name, mobileNumber);
        MyApiService.updateToken(driver.id, firebaseService.fcmToken!);
        // notificationService.init();
        // notificationService.start();

        if(newLogIn) {
          await SharedPreferences.getInstance().then((pref){
            pref.setString("username", requestBody["username"]!);
            pref.setString("password", requestBody["password"]!);

            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      const NavBar(
                        currentPage: PageItem.Home,
                      )),
            );
          });
        }

      }
    }

    return Scaffold(
        backgroundColor: Colors.orange[400],
        body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image.asset('assets/images/icon.png'),
                const Padding(
                  padding: EdgeInsets.only(top: 20, bottom: 15),
                  child: Text(
                    "Username",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
                inputusername,
                const Padding(
                  padding: EdgeInsets.only(top: 20, bottom: 15),
                  child: Text(
                    "Password",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
                inputpassword,
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: GFButton(
                    color: Colors.white, //need to change
                    onPressed: () async {
                      final Map<String, String> body = {
                        "username": username_value.text,
                        "password": password_value.text
                      };
                      await makePostRequest(body, true);

                      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_){
                      //   return HomePage(title: 'Home',);
                      // }));
                    },
                    text: "Login",
                    textColor: Colors.orange[400],
                    textStyle: TextStyle(fontSize: 16, color: Colors.orange[400]),
                  ),
                ),
              ],
            )));
  }
}

TextEditingController username_value = new TextEditingController();

var inputusername = SizedBox(
  width: 250.0,
  height: 35,
  child: TextField(
    controller: username_value,
    decoration: InputDecoration(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
    ),
    style: TextStyle(
      fontSize: 16,
      color: Colors.black,
    ),
  ),
);

TextEditingController password_value = new TextEditingController();

var inputpassword = SizedBox(
  width: 250.0,
  height: 35,
  child: TextField(
    controller: password_value,
    obscureText: true,
    enableSuggestions: false,
    autocorrect: false,
    decoration: InputDecoration(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
    ),
    style: TextStyle(
      fontSize: 16,
      color: Colors.black,
    ),
  ),
);
