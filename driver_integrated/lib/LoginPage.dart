// import 'package:flutter/material.dart';
// import 'package:getwidget/getwidget.dart';
// import 'package:driver_integrated/NavBar.dart';
// import 'package:driver_integrated/driver.dart';
// import 'dart:async';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:driver_integrated/my_api_service.dart';
// import 'package:driver_integrated/firebase_service.dart';


// String? response_message;

// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});

//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   Driver driver = Driver();
//   // NotificationService notificationService = NotificationService();
//   bool userIsLoggedIn = false;
//   FirebaseService firebaseService = FirebaseService();

//   Future<void> getLoggedInState() async{
//     WidgetsFlutterBinding.ensureInitialized();
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     var username = prefs.getString("username");
//     var password = prefs.getString("password");

//     if(username != null && password != null){
//       if(username != "null" && password != "null") {

//         final Map<String, String> body = {
//           "username": username,
//           "password": password
//         };

//         Map<String, dynamic> data = await MyApiService.driverLogIn(body);
//         dynamic authUser = data["auth_user"];
//         int id = authUser["id"];
//         int region = authUser["region"];
//         int vehicleType = authUser["vehicle_type"];
//         String name = authUser["name"];
//         int mobileNumber = authUser["mobile_number"];
//         String plateNumber = authUser["plate_number"];
//         driver.initializeDriver(id, region, vehicleType, name, mobileNumber, plateNumber);
//         userIsLoggedIn = true;
//       }
//     }

//   }

//   @override
//   void initState() {
//     super.initState();

//     getLoggedInState();
//     Future.delayed(const Duration(seconds: 3), (){
//       if(userIsLoggedIn) {
//         MyApiService.updateToken(driver.id, firebaseService.fcmToken!);
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//               builder: (context) => const NavBar( currentPage: PageItem.Home,)),
//         );
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     Future<void> makePostRequest(Map<String, String> requestBody, bool newLogIn) async {
//       Map<String, dynamic> data = await MyApiService.driverLogIn(requestBody);
//       dynamic authUser = data["auth_user"];
//       response_message = (data["auth_user"]["message"]);

//       if (response_message == "Login successfully.") {
//         int id = authUser["id"];
//         int region = authUser["region"];
//         int vehicleType = authUser["vehicle_type"];
//         String name = authUser["name"];
//         int mobileNumber = authUser["mobile_number"];
//         String plateNumber = authUser["plate_number"];
//         driver.initializeDriver(id, region, vehicleType, name, mobileNumber, plateNumber);
//         MyApiService.updateToken(driver.id, firebaseService.fcmToken!);
//         // notificationService.init();
//         // notificationService.start();

//         if(newLogIn) {
//           await SharedPreferences.getInstance().then((pref){
//             pref.setString("username", requestBody["username"]!);
//             pref.setString("password", requestBody["password"]!);

//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                   builder: (context) =>
//                   const NavBar(
//                     currentPage: PageItem.Home,
//                   )),
//             );
//           });
//         }

//       }
//     }

//     return Scaffold(
//         backgroundColor: Colors.orange[400],
//         body: Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: <Widget>[
//                 Image.asset('assets/images/icon.png'),
//                 const Padding(
//                   padding: EdgeInsets.only(top: 20, bottom: 15),
//                   child: Text(
//                     "Username",
//                     style: TextStyle(color: Colors.white, fontSize: 20),
//                   ),
//                 ),
//                 inputusername,
//                 const Padding(
//                   padding: EdgeInsets.only(top: 20, bottom: 15),
//                   child: Text(
//                     "Password",
//                     style: TextStyle(color: Colors.white, fontSize: 20),
//                   ),
//                 ),
//                 inputpassword,
//                 Padding(
//                   padding: const EdgeInsets.only(top: 30),
//                   child: GFButton(
//                     color: Colors.white, //need to change
//                     onPressed: () async {
//                       final Map<String, String> body = {
//                         "username": username_value.text,
//                         "password": password_value.text
//                       };
//                       await makePostRequest(body, true);

//                       // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_){
//                       //   return HomePage(title: 'Home',);
//                       // }));
//                     },
//                     text: "Login",
//                     textColor: Colors.orange[400],
//                     textStyle: TextStyle(fontSize: 16, color: Colors.orange[400]),
//                   ),
//                 ),
//               ],
//             )));
//   }
// }

// TextEditingController username_value = new TextEditingController();

// var inputusername = SizedBox(
//   width: 250.0,
//   height: 35,
//   child: TextField(
//     controller: username_value,
//     decoration: InputDecoration(
//       filled: true,
//       fillColor: Colors.white,
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(10.0),
//       ),
//     ),
//     style: TextStyle(
//       fontSize: 16,
//       color: Colors.black,
//     ),
//   ),
// );

// TextEditingController password_value = new TextEditingController();

// var inputpassword = SizedBox(
//   width: 250.0,
//   height: 35,
//   child: TextField(
//     controller: password_value,
//     obscureText: true,
//     enableSuggestions: false,
//     autocorrect: false,
//     decoration: InputDecoration(
//       filled: true,
//       fillColor: Colors.white,
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(10.0),
//       ),
//     ),
//     style: TextStyle(
//       fontSize: 16,
//       color: Colors.black,
//     ),
//   ),
// );

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
  bool userIsLoggedIn = false;
  FirebaseService firebaseService = FirebaseService();

  Future<void> getLoggedInState() async {
    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var username = prefs.getString("username");
    var password = prefs.getString("password");

    if (username != null && password != null) {
      if (username != "null" && password != "null") {
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
        String plateNumber = authUser["plate_number"];
        driver.initializeDriver(
            id, region, vehicleType, name, mobileNumber, plateNumber);
        userIsLoggedIn = true;
      }
    }
  }

  @override
  void initState() {
    super.initState();

    getLoggedInState();
    Future.delayed(const Duration(seconds: 3), () {
      if (userIsLoggedIn) {
        MyApiService.updateToken(driver.id, firebaseService.fcmToken!);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => const NavBar(currentPage: PageItem.Home,)),
        );
      }
    });
  }

  final _loginformKey = GlobalKey<FormState>();
  final username_value = TextEditingController();
  final password_value = TextEditingController();
  final reset_password = TextEditingController();

  @override
  void dispose() {
    username_value.dispose();
    password_value.dispose();
    reset_password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future<void> makePostRequest(Map<String, String> requestBody,
        bool newLogIn) async {
      Map<String, dynamic> data = await MyApiService.driverLogIn(requestBody);
      dynamic authUser = data["auth_user"];
      response_message = (data["auth_user"]["message"]);

      if (response_message == "Login successfully.") {
        int id = authUser["id"];
        int region = authUser["region"];
        int vehicleType = authUser["vehicle_type"];
        String name = authUser["name"];
        int mobileNumber = authUser["mobile_number"];
        String plateNumber = authUser["plate_number"];
        driver.initializeDriver(
            id, region, vehicleType, name, mobileNumber, plateNumber);
        MyApiService.updateToken(driver.id, firebaseService.fcmToken!);
        // notificationService.init();
        // notificationService.start();

        if (newLogIn) {
          await SharedPreferences.getInstance().then((pref) {
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

    double screenWidth = MediaQuery
        .of(context)
        .size
        .width;

    return Stack(
      children: [
        Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.orange[400],
          body: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      'assets/images/logo.png',
                      width: 218,
                      height: 217,
                    ),
                    Form(
                      key: _loginformKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 50.0, right: 30.0, left: 30.0),
                            child: Container(
                              height: 60,
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black.withOpacity(0.5),
                                        spreadRadius: 2,
                                        blurRadius: 5,
                                        offset: const Offset(0, 2)),
                                  ],
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white),
                              child: TextFormField(
                                controller: username_value,
                                decoration: const InputDecoration(
                                    label: Text("Email"),
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.all(16.0)),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter email';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 15.0, right: 30.0, left: 30.0),
                            child: Container(
                              height: 60,
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black.withOpacity(0.5),
                                        spreadRadius: 2,
                                        blurRadius: 5,
                                        offset: const Offset(0, 2)),
                                  ],
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white),
                              child: TextFormField(
                                controller: password_value,
                                decoration: const InputDecoration(
                                    label: Text("Password"),
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.all(16.0)),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter password';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 10.0, right: 30.0),
                            child: GestureDetector(
                              onTap: () async {
                                showModalBottomSheet(
                                    isScrollControlled: true,
                                    context: context,
                                    builder: (BuildContext context) {
                                      return SingleChildScrollView(
                                          child: Container(
                                            height: 450,
                                            color: Colors.white,
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment
                                                  .center,
                                              children: <Widget>[
                                                const Icon(
                                                    Icons.error_rounded,
                                                    color: Colors.red, size: 100
                                                ),
                                                const SizedBox(height: 16.0),
                                                const Text(
                                                  "Forgot Password",
                                                  style: TextStyle(
                                                    fontSize: 35,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                const Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 10.0,
                                                      left: 30.0,
                                                      right: 30.0),
                                                  child: SizedBox(
                                                    height: 40,
                                                    child: Text(
                                                      "A reset password link will send to the registered email.",
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.black
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 20.0),
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .only(top: 10.0,
                                                      right: 30.0,
                                                      left: 30.0),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        boxShadow: [
                                                          BoxShadow(
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                  0.5),
                                                              spreadRadius: 2,
                                                              blurRadius: 5,
                                                              offset:
                                                              const Offset(
                                                                  0, 2))
                                                        ],
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                        color: Colors.white),
                                                    child: TextFormField(
                                                      controller: reset_password,
                                                      decoration: const InputDecoration(
                                                        hintText: 'Email',
                                                        border: InputBorder
                                                            .none,
                                                        contentPadding:
                                                        EdgeInsets.all(16),
                                                      ),
                                                      validator: (value) {
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          return 'Please enter email';
                                                        }
                                                        return null; // change in future for when the email is not registered as a acc b4
                                                      },
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 15.0),
                                                ElevatedButton(
                                                  onPressed: () async {
                                                    ScaffoldMessenger.of(
                                                        context).showSnackBar(
                                                        const SnackBar(
                                                          content: Text(
                                                              'Reset Link Sent'),
                                                          backgroundColor: Colors
                                                              .green,
                                                          duration: Duration(
                                                              seconds: 4),
                                                        ));

                                                    Future.delayed(
                                                        const Duration(
                                                            seconds: 2)).then((
                                                        _) {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (
                                                                context) => const LoginPage()),
                                                      );
                                                    });
                                                  },
                                                  style: ButtonStyle(
                                                    minimumSize: MaterialStateProperty
                                                        .all(
                                                        const Size(160, 40)),
                                                    shape: MaterialStateProperty
                                                        .all<
                                                        RoundedRectangleBorder>(
                                                      RoundedRectangleBorder(
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                      ),
                                                    ),
                                                    elevation: MaterialStateProperty
                                                        .all<double>(8.0),
                                                    backgroundColor: MaterialStateProperty
                                                        .all<Color>(const Color(
                                                        0xFFB09A73)),
                                                  ),
                                                  child: const Text(
                                                    "Receive Link",
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight: FontWeight
                                                            .bold),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                      );
                                    });
                              },
                              child: const Text(
                                "Forgot Password?",
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF3E3D3D)
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 30.0, right: 30.0, left: 30.0),
                            child: Row(
                              children: <Widget>[
                                ElevatedButton(
                                  onPressed: () async {
                                    final Map<String, String> body = {
                                      "username": username_value.text,
                                      "password": password_value.text
                                    };
                                    await makePostRequest(body, true);

                                    // Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //       builder: (
                                    //           context) => const HomePage()),
                                    // );
                                  },
                                  style: ButtonStyle(
                                    minimumSize: MaterialStateProperty.all(
                                        Size(screenWidth - 246, 40)),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                10.0)
                                        )
                                    ),
                                    elevation: MaterialStateProperty.all<
                                        double>(8),
                                    backgroundColor: MaterialStateProperty.all<
                                        Color>(const Color(0xFFB09A73)),
                                  ),
                                  child: Text(
                                    "Login",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.orange[400],
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                // const SizedBox(width: 20),
                                // ElevatedButton(
                                //   onPressed: () async {
                                //     Navigator.push(
                                //       context,
                                //       MaterialPageRoute(
                                //           builder: (context) =>
                                //           const SignUpDetails()),
                                //     );
                                //   },
                                //   style: ButtonStyle(
                                //     minimumSize: MaterialStateProperty.all(
                                //         Size(screenWidth - 246, 40)),
                                //     shape: MaterialStateProperty.all<
                                //         RoundedRectangleBorder>(
                                //         RoundedRectangleBorder(
                                //             borderRadius:
                                //             BorderRadius.circular(10.0)
                                //         )
                                //     ),
                                //     elevation: MaterialStateProperty.all<
                                //         double>(8.0),
                                //     backgroundColor: MaterialStateProperty.all<
                                //         Color>(const Color(0xFFB09A73)),
                                //   ),
                                //   child: const Text(
                                //     "Sign-Up",
                                //     style: TextStyle(
                                //         fontSize: 15,
                                //         fontWeight: FontWeight.bold
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
          ),
        )
      ],
    );
  }
}
