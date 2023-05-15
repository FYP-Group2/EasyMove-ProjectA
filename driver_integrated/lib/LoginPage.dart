import 'dart:async';
import 'package:flutter/material.dart';
import 'package:driver_integrated/NavBar.dart';
import 'package:driver_integrated/driver.dart';
import 'package:driver_integrated/screen_size.dart';
import 'package:driver_integrated/SignupDetails.dart';
import 'package:driver_integrated/my_api_service.dart';
import 'package:driver_integrated/firebase_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

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
        String jwtToken = authUser["jwt_token"];
        driver.initializeDriver(
            id, region, vehicleType, name, mobileNumber, plateNumber, jwtToken);
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
        MyApiService.updateToken(driver.id, firebaseService.fcmToken!, driver.jwtToken);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => const NavBar(currentPage: PageItem.Home,)
          ),
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
    Future<void> makePostRequest(
        Map<String, String> requestBody, bool newLogIn) async {
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
          String jwtToken = authUser["jwt_token"];
          driver.initializeDriver(
              id, region, vehicleType, name, mobileNumber, plateNumber, jwtToken);
          MyApiService.updateToken(driver.id, firebaseService.fcmToken!, driver.jwtToken);
          // notificationService.init();
          // notificationService.start();

        if (newLogIn) {
          await SharedPreferences.getInstance().then((pref) {
            pref.setString("username", requestBody["username"]!);
            pref.setString("password", requestBody["password"]!);

            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context)
                  => const NavBar(currentPage: PageItem.Home),
              ),
            ).then((value) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text(
                    "Login successfully.",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  backgroundColor: Colors.green,
                ),
              );
            });
          });
        }
      } else {
          // handle login error
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Stack(
                  children:[
                    Container(
                      padding: EdgeInsets.all(16),
                      height: 90,
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black ,
                                blurRadius: 2.0,
                                offset: Offset(2.0,2.0)
                            )
                          ]
                      ),
                      child: Row(
                        children: [
                          if(username_value.text == "" && password_value.text != "")...[
                            const Text("Username is empty.", style: TextStyle(fontSize: 18, color: Colors.red, fontWeight: FontWeight.bold),),
                          ]else if(username_value.text != "" && password_value.text == "")...[
                            const Text("Password is empty.", style: TextStyle(fontSize: 18, color: Colors.red, fontWeight: FontWeight.bold),),
                          ]else if(username_value.text == "" && password_value.text == "")...[
                            const Text("Username and Password is empty.", style: TextStyle(fontSize: 18, color: Colors.red, fontWeight: FontWeight.bold),),
                          ]else if(response_message == null && username_value.text != "" && password_value.text != "")...[
                            const Text("Incorrect Username or Password.", style: TextStyle(fontSize: 18, color: Colors.red, fontWeight: FontWeight.bold),)
                          ]else ...[
                            const SizedBox.shrink(),
                          ]
                        ],
                      ),
                    ),
                  ]
                ),
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.transparent,
                elevation: 0,
                margin: EdgeInsets.only(bottom: 30.0),
              )
          );
        }
    }

    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: ScreenSize.screenWidth(context),
            height: ScreenSize.screenHeight(context),
            padding: EdgeInsets.symmetric(
                horizontal: ScreenSize.screenWidth(context) * 0.05,
                vertical: ScreenSize.screenHeight(context) * 0.1
            ),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: <Color>[
                      Color(0xFFffcc33),
                      Colors.orange.shade700
                    ]
                )
            ),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  // Title
                  Text(
                    "Login",
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
                  // Login Form
                  Form(
                    key: _loginformKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        // Username Input Field
                        Container(
                          height: 60,
                          child: TextFormField(
                            controller: username_value,
                            decoration: InputDecoration(
                                label: Text("Username"),
                                labelStyle: TextStyle(
                                  color: Colors.white,
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.all(16.0),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white38),
                                    borderRadius: BorderRadius.circular(100)
                                        .copyWith(bottomRight: Radius.circular(0)
                                    )
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white70),
                                  borderRadius: BorderRadius.circular(100)
                                      .copyWith(bottomRight: Radius.circular(0)
                                  ),
                                )
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter username';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(height: ScreenSize.screenHeight(context) * 0.01),
                        // Password Input Field
                        Container(
                          height: 60,
                          child: TextFormField(
                            obscureText: true,
                            enableSuggestions: false,
                            autocorrect: false,
                            controller: password_value,
                            decoration: InputDecoration(
                                label: Text("Password"),
                                labelStyle: TextStyle(
                                  color: Colors.white,
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.all(16.0),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white38),
                                  borderRadius: BorderRadius.circular(100)
                                      .copyWith(bottomRight: Radius.circular(0)
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white70),
                                  borderRadius: BorderRadius.circular(100)
                                      .copyWith(bottomRight: Radius.circular(0)
                                  ),
                                )
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter password';
                              }
                              return null;
                            },
                          ),
                        ),
                        // Forgot Password Modal
                        GestureDetector(
                          onTap: () async {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  content: SingleChildScrollView(
                                      child: Container(
                                        height: ScreenSize.screenHeight(context) * 0.5,
                                        color: Colors.white,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            const Icon(
                                                Icons.error_rounded,
                                                color: Colors.red,
                                                size: 90),
                                            const SizedBox(height: 16.0),
                                            const Text(
                                              "Forgot Password",
                                              style: TextStyle(
                                                fontSize: 30,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                            const Padding(
                                              padding: EdgeInsets.only(top: 10.0),
                                              child: SizedBox(
                                                height: 40,
                                                child: Text(
                                                  "A reset password link will send to the registered email.",
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.black),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 20.0),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 10.0),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    boxShadow: [
                                                      BoxShadow(
                                                          color: Colors.black.withOpacity(0.5),
                                                          spreadRadius: 2,
                                                          blurRadius: 5,
                                                          offset: const Offset(0, 2))
                                                    ],
                                                    borderRadius: BorderRadius.circular(10),
                                                    color: Colors.white
                                                ),
                                                child: TextFormField(
                                                  controller: reset_password,
                                                  decoration: const InputDecoration(
                                                    hintText: 'Registered Email',
                                                    border: InputBorder.none,
                                                    contentPadding: EdgeInsets.all(16),
                                                  ),
                                                  validator: (value) {
                                                    if (value == null || value.isEmpty) {
                                                      return 'Please enter email';
                                                    }
                                                    return null; // change in future for when the email is not registered as a acc b4
                                                  },
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: ScreenSize.screenHeight(context) * 0.05),
                                            ElevatedButton(
                                              onPressed: () async {
                                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                                  content: Text('Reset Link Sent'),
                                                  backgroundColor: Colors.green,
                                                  duration: Duration(seconds: 4),
                                                ));

                                                await MyApiService.forgotPassword(reset_password.text);

                                                Future.delayed(const Duration(seconds: 2)).then((_) {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) => const LoginPage()),
                                                  );
                                                });
                                              },
                                              style: ButtonStyle(
                                                minimumSize: MaterialStateProperty.all(const Size(160, 40)),
                                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(10)
                                                    )
                                                ),
                                                elevation: MaterialStateProperty.all<double>(8.0),
                                                backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF000000)),
                                              ),
                                              child: const Text(
                                                "Send Link",
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: ScreenSize.screenHeight(context) * 0.01),
                                            GestureDetector(
                                              onTap: () async {
                                                Future.delayed(const Duration(seconds: 2)).then((_) {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) => const LoginPage()),
                                                  );
                                                });
                                              },
                                              child: const Text(
                                                "Cancel",
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    decoration: TextDecoration.underline
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                  )
                                );
                              }
                            );
                          },
                          child: const Text(
                            "Forgot Password?",
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.white
                            ),
                          ),
                        ),
                        SizedBox(height: ScreenSize.screenHeight(context) * 0.05),
                        // Login Button
                        Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 4,
                                    color: Colors.black12.withOpacity(0.2),
                                    offset: Offset(2,2)
                                )
                              ],
                              gradient: LinearGradient(
                                  colors: <Color>[
                                    Color(0xFFffcc33),
                                    Colors.orange.shade700
                                  ]
                              ),
                              borderRadius: BorderRadius.circular(50)
                                  .copyWith(bottomRight: Radius.circular(0)),
                            ),
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () async {
                                // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                //       content: Stack(
                                //         children: [
                                //           Container(
                                //             padding: EdgeInsets.all(16),
                                //             height: 90,
                                //             decoration: const BoxDecoration(
                                //                 color: Colors.white,
                                //                 borderRadius: BorderRadius.all(Radius.circular(20)),
                                //                 boxShadow: [
                                //                   BoxShadow(
                                //                       color: Colors.black ,
                                //                       blurRadius: 2.0,
                                //                       offset: Offset(2.0,2.0)
                                //                   )
                                //                 ]
                                //             ),
                                //             child: Row(
                                //               children: [
                                //                 if(username_value.text == "" && password_value.text != "")...[
                                //                   const Text("Username is empty.", style: TextStyle(fontSize: 18, color: Colors.red, fontWeight: FontWeight.bold),),
                                //                 ]else if(username_value.text != "" && password_value.text == "")...[
                                //                   const Text("Password is empty.", style: TextStyle(fontSize: 18, color: Colors.red, fontWeight: FontWeight.bold),),
                                //                 ]else if(username_value.text == "" && password_value.text == "")...[
                                //                   const Text("Username and Password is empty.", style: TextStyle(fontSize: 18, color: Colors.red, fontWeight: FontWeight.bold),),
                                //                 ]else if(response_message == null && username_value.text != "" && password_value.text != "")...[
                                //                   const Text("Incorrect Username or Password.", style: TextStyle(fontSize: 18, color: Colors.red, fontWeight: FontWeight.bold),)
                                //                 ]else if(response_message == "Login successfully.")...[
                                //                   const SizedBox.shrink(),
                                //                 ]else ...[
                                //                   const SizedBox.shrink(),
                                //                 ]
                                //               ],
                                //             ),
                                //           ),
                                //         ],
                                //       ),
                                //       behavior: SnackBarBehavior.floating,
                                //       backgroundColor: Colors.transparent,
                                //       elevation: 0,
                                //       margin: EdgeInsets.only(bottom: 30.0),
                                //     ));
                                // Future.delayed(const Duration(seconds: 2)).then((_) {
                                //   Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) => const NavBar(currentPage: PageItem.Home,)
                                //     ),
                                //   );
                                // });
                                final Map<String, String> body = {
                                  "username": username_value.text,
                                  "password": password_value.text
                                };
                                await makePostRequest(body, true);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50)
                                      .copyWith(bottomRight: Radius.circular(0)),
                                ),
                              ),
                              child: const Text(
                                "Login",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                            )
                        ),
                        SizedBox(height: ScreenSize.screenHeight(context) * 0.01),
                        // Sign-Up Link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("Don't have an account?   ",
                                style: TextStyle(
                                  color: Colors.white,
                                )
                            ),
                            GestureDetector(onTap: () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignupDetails()),
                              );
                            },
                              child: const Text(
                                "Sign-Up",
                                style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
          ),
          // Back Button
          Positioned(
            top: 40,
            left: 20,
            child: Container(
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        ],
      )
    );

    return Stack(
      children: [
        Scaffold(
          appBar:AppBar(
            elevation: 0,
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: <Color>[
                      Color(0xFFffcc33),
                      Colors.orange.shade700
                    ]
                  ),
                )
              )
          ),
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.orange[400],
          body: Container(
            height: double.infinity,
            width: double.infinity,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: <Color>[
                  Color(0xFFffcc33),
                  Colors.orange.shade700
                ]
              )
            ),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Login",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),
                    SizedBox(height: 80),
                    Image.asset(
                      'assets/images/EMXicon.png',
                      width: 220,
                    ),
                    Form(
                      key: _loginformKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 50.0, right: 30.0, left: 30.0),
                            child: Container(
                              height: 60,
                              child: TextFormField(
                                controller: username_value,
                                decoration: InputDecoration(
                                    label: Text("Username"),
                                    labelStyle: TextStyle(
                                      color: Colors.white,
                                    ),
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.all(16.0),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.white38),
                                      borderRadius: BorderRadius.circular(100)
                                          .copyWith(bottomRight: Radius.circular(0)
                                      )
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.white70),
                                      borderRadius: BorderRadius.circular(100)
                                          .copyWith(bottomRight: Radius.circular(0)
                                      ),
                                    )
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter username';
                                  }
                                  return null;
                                  },
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 15.0, right: 30.0, left: 30.0),
                            child: Container(
                              height: 60,
                              child: TextFormField(
                                obscureText: true,
                                enableSuggestions: false,
                                autocorrect: false,
                                controller: password_value,
                                decoration: InputDecoration(
                                    label: Text("Password"),
                                    labelStyle: TextStyle(
                                      color: Colors.white,
                                    ),
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.all(16.0),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.white38),
                                      borderRadius: BorderRadius.circular(100)
                                          .copyWith(bottomRight: Radius.circular(0)
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.white70),
                                      borderRadius: BorderRadius.circular(100)
                                          .copyWith(bottomRight: Radius.circular(0)
                                      ),
                                    )
                                ),
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
                            padding: const EdgeInsets.only(top: 10.0, right: 30.0),
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
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              children: <Widget>[
                                                const Icon(
                                                    Icons.error_rounded,
                                                    color: Colors.red,
                                                    size: 100),
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
                                                  padding: EdgeInsets.only(top: 10.0, left: 30.0, right: 30.0),
                                                  child: SizedBox(
                                                    height: 40,
                                                    child: Text(
                                                      "A reset password link will send to the registered email.",
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 20.0),
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 10.0, right: 30.0, left: 30.0),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        boxShadow: [
                                                          BoxShadow(
                                                              color: Colors.black.withOpacity(0.5),
                                                              spreadRadius: 2,
                                                              blurRadius: 5,
                                                              offset: const Offset(0, 2))
                                                        ],
                                                        borderRadius: BorderRadius.circular(10),
                                                        color: Colors.white
                                                    ),
                                                    child: TextFormField(
                                                      controller: reset_password,
                                                      decoration: const InputDecoration(
                                                        hintText: 'Email',
                                                        border: InputBorder.none,
                                                        contentPadding: EdgeInsets.all(16),
                                                      ),
                                                      validator: (value) {
                                                        if (value == null || value.isEmpty) {
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
                                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                                      content: Text('Reset Link Sent'),
                                                      backgroundColor: Colors.green,
                                                      duration: Duration(seconds: 4),
                                                    ));
                                                    Future.delayed(const Duration(seconds: 2)).then((_) {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) => const LoginPage()),
                                                      );
                                                    });
                                                  },
                                                  style: ButtonStyle(
                                                    minimumSize: MaterialStateProperty.all(const Size(160, 40)),
                                                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                        RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(10)
                                                        )
                                                    ),
                                                    elevation: MaterialStateProperty.all<double>(8.0),
                                                    backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF000000)),
                                                  ),
                                                  child: const Text(
                                                    "Receive Link",
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.bold),
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
                                    color: Colors.white
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 30.0, right: 30.0, left: 30.0),
                            child: Column(
                              children: <Widget>[
                                Container(
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                            blurRadius: 4,
                                            color: Colors.black12.withOpacity(0.2),
                                            offset: Offset(2,2)
                                        )
                                      ],
                                      gradient: LinearGradient(
                                          colors: <Color>[
                                            Color(0xFFffcc33),
                                            Colors.orange.shade700
                                          ]
                                      ),
                                      borderRadius: BorderRadius.circular(50)
                                          .copyWith(bottomRight: Radius.circular(0)),
                                    ),
                                    width: double.infinity,
                                    height: 50,
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        // setState(() {
                                        //
                                        // });
                                        final Map<String, String> body = {
                                          "username": username_value.text,
                                          "password": password_value.text
                                        };
                                        await makePostRequest(body, true);
                                    },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        shadowColor: Colors.transparent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(50)
                                              .copyWith(bottomRight: Radius.circular(0)),
                                        ),
                                      ),
                                      child: const Text(
                                        "Login",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18,
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                ),
                                const SizedBox(width: 35, height: 35),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text("Don't have an account?   ",
                                        style: TextStyle(
                                          color: Colors.white,
                                        )
                                    ),
                                    GestureDetector(onTap: () async {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => SignupDetails()),
                                      );
                                    },
                                      child: const Text(
                                        "Sign-Up",
                                        style: TextStyle(
                                            decoration: TextDecoration.underline,
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 50),
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
        )
      ],
    );
  }
}
