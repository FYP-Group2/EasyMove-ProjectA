import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: SignUpPage(title: 'Flutter Demo Home Page'),
    );
  }
}

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key, required this.title});
  final String title;

  @override
  State<SignUpPage> createState() => _MySignUpPageState();
}

class _MySignUpPageState extends State<SignUpPage> {
  var FullTimeSelected = false;
  var PartTimeSelected = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
            appBar:AppBar(
                elevation: 0,
                flexibleSpace: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: <Color>[Color(0xFFffcc33), Colors.orange.shade700]),))
            ),
            resizeToAvoidBottomInset: false,
            body: Container(
              height: double.infinity,
              width: double.infinity,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: <Color>[Color(0xFFffcc33), Colors.orange.shade700]
                  )
              ),

              child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(
                          'assets/icon_2.png',
                          width: 250,
                        ),
                        Form(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(top: 50.0, right: 30.0, left: 30.0),
                                child: Container(
                                  height: 60,
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                        label: Text("Full Name As Per IC  *"),
                                        labelStyle: TextStyle(
                                          color: Colors.white,
                                        ),
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.all(16.0),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(100)
                                                .copyWith(bottomRight: Radius.circular(0)),
                                            borderSide: BorderSide(color: Colors.white54)),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(100)
                                                .copyWith(bottomRight: Radius.circular(0)),
                                            borderSide: BorderSide(color: Colors.white70))
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 15.0, right: 30.0, left: 30.0),
                                child: Container(
                                  height: 60,
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                        label: Text("Login Username  *"),
                                        labelStyle: TextStyle(
                                          color: Colors.white,
                                        ),
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.all(16.0),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(100)
                                                .copyWith(bottomRight: Radius.circular(0)),
                                            borderSide: BorderSide(color: Colors.white54)),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(100)
                                                .copyWith(bottomRight: Radius.circular(0)),
                                            borderSide: BorderSide(color: Colors.white70))
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 15.0, right: 30.0, left: 30.0),
                                child: Container(
                                  height: 60,
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                        label: Text("Login Password  *"),
                                        labelStyle: TextStyle(
                                          color: Colors.white,
                                        ),
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.all(16.0),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(100)
                                                .copyWith(bottomRight: Radius.circular(0)),
                                            borderSide: BorderSide(color: Colors.white54)),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(100)
                                                .copyWith(bottomRight: Radius.circular(0)),
                                            borderSide: BorderSide(color: Colors.white70))
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 15.0, right: 30.0, left: 30.0),
                                child: Container(
                                  height: 60,
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                        label: Text("Identity Card Number  *"),
                                        labelStyle: TextStyle(
                                          color: Colors.white,
                                        ),
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.all(16.0),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(100)
                                                .copyWith(bottomRight: Radius.circular(0)),
                                            borderSide: BorderSide(color: Colors.white54)),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(100)
                                                .copyWith(bottomRight: Radius.circular(0)),
                                            borderSide: BorderSide(color: Colors.white70))
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 15.0, right: 30.0, left: 30.0),
                                child: Container(
                                  height: 60,
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                        label: Text("Mobile Phone Number  *"),
                                        labelStyle: TextStyle(
                                          color: Colors.white,
                                        ),
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.all(16.0),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(100)
                                                .copyWith(bottomRight: Radius.circular(0)),
                                            borderSide: BorderSide(color: Colors.white54)),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(100)
                                                .copyWith(bottomRight: Radius.circular(0)),
                                            borderSide: BorderSide(color: Colors.white70))
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 15.0, right: 30.0, left: 30.0),
                                child: Container(
                                  height: 60,
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                        label: Text("Emergency Contact Number  *"),
                                        labelStyle: TextStyle(
                                          color: Colors.white,
                                        ),
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.all(16.0),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(100)
                                                .copyWith(bottomRight: Radius.circular(0)),
                                            borderSide: BorderSide(color: Colors.white54)),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(100)
                                                .copyWith(bottomRight: Radius.circular(0)),
                                            borderSide: BorderSide(color: Colors.white70))
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 15.0, right: 30.0, left: 30.0, bottom: 5.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      "Employment Type:",
                                      style: TextStyle(color: Colors.white, fontSize: 14),
                                    ),
                                  GestureDetector(
                                      onTap: () {
                                      setState(() {
                                        FullTimeSelected = true;
                                        PartTimeSelected = false;
                                      });
                                      },
                                  child: Row(
                                      children: [
                                        Container(
                                        height: 20,
                                        width: 20,
                                        alignment: Alignment.center,
                                        margin: const EdgeInsets.only(right: 10),
                                        decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(color: Colors.white54)),
                                        child: FullTimeSelected
                                          ?  Container(
                                            margin: const EdgeInsets.all(4),
                                            decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white),
                                            )
                                            : const SizedBox()),
                                            const Text('Full Time',
                                            style: TextStyle(
                                              color: Colors.white, fontSize: 14.5))
                                        ],
                                  ),
                                  ),
                                  GestureDetector(
                                  onTap: () {
                                  setState(() {
                                    PartTimeSelected = true;
                                    FullTimeSelected = false;
                                  });
                                  },
                                  child: Row(
                                      children: [
                                        Container(
                                        height: 20,
                                        width: 20,
                                        alignment: Alignment.center,
                                        margin: const EdgeInsets.only(right: 10),
                                        decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(color: Colors.white54)),
                                        child: PartTimeSelected
                                          ? Container(
                                            margin: const EdgeInsets.all(4),
                                            decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white),
                                            )
                                            : const SizedBox()),
                                              const Text('Part Time',
                                               style: TextStyle(
                                                   color: Colors.white, fontSize: 14.5))
                                      ],
                                  ),
                                  )
                                  ],
                                  ),
                              ),
                              //// Region drop down button
                              Padding(
                                padding: const EdgeInsets.only(top: 15.0, right: 30.0, left: 30.0),
                                child: Container(
                                  height: 60,
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                        label: Text("Region"),
                                        labelStyle: TextStyle(
                                          color: Colors.white,
                                        ),
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.all(16.0),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(100)
                                                .copyWith(bottomRight: Radius.circular(0)),
                                            borderSide: BorderSide(color: Colors.white54)),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(100)
                                                .copyWith(bottomRight: Radius.circular(0)),
                                            borderSide: BorderSide(color: Colors.white70))
                                    ),
                                  ),
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.only(top: 10.0, right: 30.0, left: 30.0),
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                      "Front Of Driver's I.C.  *",
                                      style: TextStyle(color: Colors.white, fontSize: 18),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 5.0),
                                      decoration: BoxDecoration(
                                        gradient:  LinearGradient(
                                            colors: <Color>[Color(0xFFffbd0a), Colors.orange.shade800]),
                                        borderRadius: BorderRadius.circular(50)
                                            .copyWith(bottomRight: Radius.circular(0)),
                                      ),
                                      width: 200,
                                      height: 45,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          //myAlert('frontic');
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.transparent,
                                          shadowColor: Colors.transparent,
                                          shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                              color: Colors.white38,
                                            ),
                                            borderRadius: BorderRadius.circular(50)
                                                .copyWith(bottomRight: Radius.circular(0)),
                                          ),
                                        ),
                                        child: Text(
                                          "Upload Image",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.only(top: 10.0, right: 30.0, left: 30.0),
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                      "Back Of Driver's I.C.  *",
                                      style: TextStyle(color: Colors.white, fontSize: 18),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 5.0),
                                      decoration: BoxDecoration(
                                        gradient:  LinearGradient(
                                            colors: <Color>[Color(0xFFffbd0a), Colors.orange.shade800]),
                                        borderRadius: BorderRadius.circular(50)
                                            .copyWith(bottomRight: Radius.circular(0)),
                                      ),
                                      width: 200,
                                      height: 45,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          //myAlert('backic');
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.transparent,
                                          shadowColor: Colors.transparent,
                                          shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                              color: Colors.white38,
                                            ),
                                            borderRadius: BorderRadius.circular(50)
                                                .copyWith(bottomRight: Radius.circular(0)),
                                          ),
                                        ),
                                        child: Text(
                                          "Upload Image",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              //// Vehicle Type drop down button
                              Padding(
                                padding: const EdgeInsets.only(top: 15.0, right: 30.0, left: 30.0),
                                child: Container(
                                  height: 60,
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                        label: Text("Vehicle Type"),
                                        labelStyle: TextStyle(
                                          color: Colors.white,
                                        ),
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.all(16.0),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(100)
                                                .copyWith(bottomRight: Radius.circular(0)),
                                            borderSide: BorderSide(color: Colors.white54)),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(100)
                                                .copyWith(bottomRight: Radius.circular(0)),
                                            borderSide: BorderSide(color: Colors.white70))
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 15.0, right: 30.0, left: 30.0),
                                child: Container(
                                  height: 60,
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                        label: Text("Vehicle Owner "),
                                        labelStyle: TextStyle(
                                          color: Colors.white,
                                        ),
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.all(16.0),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(100)
                                                .copyWith(bottomRight: Radius.circular(0)),
                                            borderSide: BorderSide(color: Colors.white54)),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(100)
                                                .copyWith(bottomRight: Radius.circular(0)),
                                            borderSide: BorderSide(color: Colors.white70))
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 15.0, right: 30.0, left: 30.0),
                                child: Container(
                                  height: 60,
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                        label: Text("Vehicle Plate "),
                                        labelStyle: TextStyle(
                                          color: Colors.white,
                                        ),
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.all(16.0),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(100)
                                                .copyWith(bottomRight: Radius.circular(0)),
                                            borderSide: BorderSide(color: Colors.white54)),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(100)
                                                .copyWith(bottomRight: Radius.circular(0)),
                                            borderSide: BorderSide(color: Colors.white70))
                                    ),
                                  ),
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                      "Front Of Driver's Driving License",
                                      style: TextStyle(color: Colors.white, fontSize: 18),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 5.0),
                                      decoration: BoxDecoration(
                                        gradient:  LinearGradient(
                                            colors: <Color>[Color(0xFFffbd0a), Colors.orange.shade800]),
                                        borderRadius: BorderRadius.circular(50)
                                            .copyWith(bottomRight: Radius.circular(0)),
                                      ),
                                      width: 200,
                                      height: 45,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          //myAlert('driverlicense');
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.transparent,
                                          shadowColor: Colors.transparent,
                                          shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                              color: Colors.white38,
                                            ),
                                            borderRadius: BorderRadius.circular(50)
                                                .copyWith(bottomRight: Radius.circular(0)),
                                          ),
                                        ),
                                        child: Text(
                                          "Upload Image",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.only(top: 10.0, right: 30.0, left: 30.0),
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                      "Front Of Vehicle",
                                      style: TextStyle(color: Colors.white, fontSize: 18),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 5.0),
                                      decoration: BoxDecoration(
                                        gradient:  LinearGradient(
                                            colors: <Color>[Color(0xFFffbd0a), Colors.orange.shade800]),
                                        borderRadius: BorderRadius.circular(50)
                                            .copyWith(bottomRight: Radius.circular(0)),
                                      ),
                                      width: 200,
                                      height: 45,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          //myAlert('frontvehicle');
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.transparent,
                                          shadowColor: Colors.transparent,
                                          shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                              color: Colors.white38,
                                            ),
                                            borderRadius: BorderRadius.circular(50)
                                                .copyWith(bottomRight: Radius.circular(0)),
                                          ),
                                        ),
                                        child: Text(
                                          "Upload Image",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.only(top: 10.0, right: 30.0, left: 30.0),
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                      "Back Of Vehicle",
                                      style: TextStyle(color: Colors.white, fontSize: 18),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 5.0),
                                      decoration: BoxDecoration(
                                        gradient:  LinearGradient(
                                            colors: <Color>[Color(0xFFffbd0a), Colors.orange.shade800]),
                                        borderRadius: BorderRadius.circular(50)
                                            .copyWith(bottomRight: Radius.circular(0)),
                                      ),
                                      width: 200,
                                      height: 45,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          //myAlert('backvehicle');
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.transparent,
                                          shadowColor: Colors.transparent,
                                          shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                              color: Colors.white38,
                                            ),
                                            borderRadius: BorderRadius.circular(50)
                                                .copyWith(bottomRight: Radius.circular(0)),
                                          ),
                                        ),
                                        child: Text(
                                          "Upload Image",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10.0, right: 30.0, left: 30.0),
                                child:
                                    Text(
                                      "Terms and Condition",
                                      style: TextStyle(color: Colors.white),
                                    ),
                              ),

                              //T&C
                              //----------------------
                              // Row(
                              //   children: [
                              //     Material(
                              //       child: Checkbox(
                              //         value: agree,
                              //         onChanged: (value) {
                              //           setState(() {
                              //             agree = value ?? false;
                              //           });
                              //         },
                              //       ),
                              //     ),
                              //     GestureDetector(
                              //       onTap: () async {
                              //         const url = "https://easysuperapps.com/policy.php";
                              //         final uri = Uri.parse(url);
                              //         try {
                              //           if (await launchUrl(uri)) {
                              //             setState(() {});
                              //           }
                              //         } catch (e) {
                              //           showDialog(
                              //               context: context,
                              //               builder: (ctx) => AlertDialog(
                              //                 title: const Text(
                              //                   "Problem redirecting to T&C",
                              //                   style: TextStyle(color: Colors.blue),
                              //                 ),
                              //                 content: const Text("Please try again later"),
                              //                 actions: <Widget>[
                              //                   TextButton(
                              //                     onPressed: () {
                              //                       Navigator.of(ctx).pop();
                              //                     },
                              //                     child: Container(
                              //                       color: Colors.orange,
                              //                       padding: const EdgeInsets.all(14),
                              //                       child: const Text("Close",
                              //                           style:
                              //                           TextStyle(color: Colors.white)),
                              //                     ),
                              //                   ),
                              //                 ],
                              //               ));
                              //         }
                              //         // showDialog(
                              //         //     context: context,
                              //         //     builder: (ctx) => AlertDialog(
                              //         //       title: const Text(
                              //         //         "Constitution and laws",
                              //         //         style: TextStyle(color: Colors.blue),
                              //         //       ),
                              //         //       content: const Text(""),
                              //         //       actions: <Widget>[
                              //         //         TextButton(
                              //         //           onPressed: () {
                              //         //             Navigator.of(ctx).pop();
                              //         //           },
                              //         //           child: Container(
                              //         //             color: Colors.orange,
                              //         //             padding: const EdgeInsets.all(14),
                              //         //             child: const Text("Close",
                              //         //                 style:
                              //         //                 TextStyle(color: Colors.white)),
                              //         //           ),
                              //         //         ),
                              //         //       ],
                              //         //     ));
                              //       },
                              //       child: const Text(
                              //         'I have read and accept terms and conditions',
                              //         overflow: TextOverflow.ellipsis,
                              //         style: TextStyle(
                              //             decoration: TextDecoration.underline,
                              //             color: Color.fromARGB(255, 16, 145, 251)),
                              //       ),
                              //     )
                              //   ],
                              // ),

                              Padding(
                                padding: const EdgeInsets.all(30.0),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      decoration: BoxDecoration(
                                        gradient:  LinearGradient(
                                            colors: <Color>[Color(0xFFffbd0a), Colors.orange.shade800]),
                                        borderRadius: BorderRadius.circular(50)
                                            .copyWith(bottomRight: Radius.circular(0)),
                                      ),
                                      width: double.infinity,
                                      height: 60,
                                      child: ElevatedButton(
                                            onPressed: () async {
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
                                              "Sign up", style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 18,
                                              color: Colors.white,

                                            ),
                                            ),
                                          ),
                                    ),

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




