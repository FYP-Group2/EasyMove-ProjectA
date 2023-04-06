import 'package:flutter/material.dart';
import 'dart:io';
import 'package:getwidget/getwidget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:driver_integrated/Notice.dart';
import 'package:driver_integrated/my_api_service.dart';
import 'package:driver_integrated/firebase_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:driver_integrated/validation_helpers.dart';
import 'package:fluttertoast/fluttertoast.dart';

final _formKey = GlobalKey<FormState>();
//for uploading image
XFile? driver_license_image;
XFile? back_vehicle_image;
XFile? front_vehicle_image;

bool agree = false;

class SignupVehicle extends StatelessWidget {
  SignupVehicle(
      this.fullname,
      this.ic,
      this.mobilenumber,
      this.emergencycontact,
      this.employmenttype,
      this.region,
      this.frontic,
      this.backic,
      this.username,
      this.password);
  final String fullname;
  final String ic;
  final String mobilenumber;
  final String emergencycontact;
  final String employmenttype;
  final int region;
  final XFile? frontic;
  final XFile? backic;
  final String username;
  final String password;
  FirebaseService firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(80.0),
          child: AppBar(
            title: Image.asset('assets/images/icon.png', height: 100),
            centerTitle: true,
            backgroundColor: const Color(0xFFFFA600),
          ),
        ),
        body: signupForm(),
        bottomNavigationBar: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.grey.shade300, Colors.white],
                stops: const [0.05, 0.2],
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () async {
                    if (agree == true) {
                      if (!_formKey.currentState!.validate()) {
                        return;
                      } else if (driver_license_image == null ||
                          back_vehicle_image == null ||
                          front_vehicle_image == null) {
                        Fluttertoast.showToast(
                            msg: "Please provide the required images",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      } else {
                        final Map<String, String> body = {
                          'region': "$region",
                          "type": "${vehicleMap[vehicle_type_value]}",
                          "name": fullname,
                          "time": employmenttype,
                          "mobile": mobilenumber,
                          "emergency": emergencycontact,
                          "plate": vehicleplate_value.text,
                          "owner": vehicleowner_value.text,
                          "username": username,
                          "password": password,
                          "token" : firebaseService.fcmToken!
                        };

                        await MyApiService.driverApply(body)
                            .then((result) async {
                          if (result) {
                            String icPath = File(frontic!.path).path;
                            String licensePath =
                                File(driver_license_image!.path).path;
                            String frontVehiclePath =
                                File(front_vehicle_image!.path).path;
                            String backVehiclePath =
                                File(back_vehicle_image!.path).path;
                            MyApiService.photoRegister(username, icPath,
                                licensePath, frontVehiclePath, backVehiclePath);

                            await MyApiService.getDriverId(username)
                                .then((data) {
                              dynamic authUser = data["auth_user"];
                              int id = authUser["id"];
                              // MyApiService.updateToken(
                              //     id, firebaseService.fcmToken!, driver.jwtToken);
                            });

                            await SharedPreferences.getInstance().then((pref) {
                              pref.setString("tempusername", username);
                            });
                          }
                        });

                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Notice()),
                        );
                      }
                    }
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.only(right: 40, bottom: 5, top: 10),
                    child: Text(
                      "Done",
                      style: TextStyle(color: Colors.orange[400], fontSize: 30),
                    ),
                  ),
                ),
              ],
            )));
  }
}

class signupForm extends StatefulWidget {
  @override
  signupFormState createState() {
    return signupFormState();
  }
}

class signupFormState extends State<signupForm> {
  final ImagePicker picker = ImagePicker();

  Future<List> getVehicles() async {
    vehicles = await MyApiService.getVehicles();
    vehicleMap = vehicles[0];
    vehicleType = vehicles[1];
    if (vehicle_type_value == "") {
      vehicle_type_value = vehicleType[0];
    }
    return vehicles;
  }

  //we can upload image from camera or from gallery based on parameter
  Future getImage(ImageSource media, String info) async {
    var img = await picker.pickImage(source: media);

    if (info == "driverlicense") {
      setState(() {
        driver_license_image = img;
      });
    }
    if (info == "frontvehicle") {
      setState(() {
        front_vehicle_image = img;
      });
    }
    if (info == "backvehicle") {
      setState(() {
        back_vehicle_image = img;
      });
    }
  }

  //function for uploading image
  void myAlert(String info) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: Text('Please choose media to select'),
            content: Container(
              height: MediaQuery.of(context).size.height / 6,
              child: Column(
                children: [
                  ElevatedButton(
                    //if user click this button, user can upload image from gallery
                    onPressed: () {
                      Navigator.pop(context);
                      getImage(ImageSource.gallery, info);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.image),
                        Text('From Gallery'),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    //if user click this button. user can upload image from camera
                    onPressed: () {
                      Navigator.pop(context);
                      getImage(ImageSource.camera, info);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.camera),
                        Text('From Camera'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: SingleChildScrollView(
            padding: EdgeInsets.only(left: 15, right: 15),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
                    Widget>[
              //input vehicle type
              Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text("Vehicle Type"),
                  ),
                  FutureBuilder(
                    future: getVehicles(),
                    builder: (context, snapshot) {
                      return DropdownButton(
                        value: vehicle_type_value,
                        items: vehicleType.map<DropdownMenuItem<String>>(
                            (String vehicleType) {
                          return DropdownMenuItem(
                            value: vehicleType,
                            child: Text(vehicleType),
                          );
                        }).toList(),
                        icon: const Icon(Icons.keyboard_arrow_down),
                        onChanged: (String? newValue) {
                          setState(() {
                            vehicle_type_value = newValue!;
                          });
                        },
                      );
                    },
                  )
                ],
              ),

              //input vehicle owner
              inputvehicleowner,

              //input vehicle plate
              Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: inputvehicleplate,
              ),

              //input driver's license
              Column(
                children: [
                  Text(
                    "Front Of Driver's Driving License",
                    style: TextStyle(fontSize: 18),
                  ),
                  GFButton(
                    color: Colors.orange,
                    onPressed: () {
                      myAlert('driverlicense');
                    },
                    text: "Upload Image",
                    shape: GFButtonShape.pills,
                  ),
                ],
              ),

              //show image
              driver_license_image != null
                  ? Padding(
                      padding:
                          const EdgeInsets.only(left: 5, right: 5, bottom: 20),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          //to show image
                          File(driver_license_image!.path),
                          fit: BoxFit.cover,
                          width: MediaQuery.of(context).size.width,
                          height: 300,
                        ),
                      ),
                    )
                  : Text(
                      "",
                      style: TextStyle(fontSize: 20),
                    ),

              //input for front of vehicle
              Column(
                children: [
                  Text(
                    "Front Of Vehicle",
                    style: TextStyle(fontSize: 18),
                  ),
                  GFButton(
                    color: Colors.orange,
                    onPressed: () {
                      myAlert('frontvehicle');
                    },
                    text: "Upload Image",
                    shape: GFButtonShape.pills,
                  ),
                ],
              ),

              //show image
              front_vehicle_image != null
                  ? Padding(
                      padding:
                          const EdgeInsets.only(left: 5, right: 5, bottom: 20),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          //to show image
                          File(front_vehicle_image!.path),
                          fit: BoxFit.cover,
                          width: MediaQuery.of(context).size.width,
                          height: 300,
                        ),
                      ),
                    )
                  : Text(
                      "",
                      style: TextStyle(fontSize: 20),
                    ),

              //input for back of vehicle
              Column(
                children: [
                  Text(
                    "Back Of Vehicle",
                    style: TextStyle(fontSize: 18),
                  ),
                  GFButton(
                    color: Colors.orange,
                    onPressed: () {
                      myAlert('backvehicle');
                    },
                    text: "Upload Image",
                    shape: GFButtonShape.pills,
                  ),
                ],
              ),

              //show image
              back_vehicle_image != null
                  ? Padding(
                      padding:
                          const EdgeInsets.only(left: 5, right: 5, bottom: 20),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          //to show image
                          File(back_vehicle_image!.path),
                          fit: BoxFit.cover,
                          width: MediaQuery.of(context).size.width,
                          height: 300,
                        ),
                      ),
                    )
                  : Text(
                      "",
                      style: TextStyle(fontSize: 20),
                    ),

              Row(
                children: [
                  Material(
                    child: Checkbox(
                      value: agree,
                      onChanged: (value) {
                        setState(() {
                          agree = value ?? false;
                        });
                      },
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      const url = "https://easysuperapps.com/policy.php";
                      final uri = Uri.parse(url);
                      try {
                        if (await launchUrl(uri)) {
                          setState(() {});
                        }
                      } catch (e) {
                        showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                                  title: const Text(
                                    "Problem redirecting to T&C",
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                  content: const Text("Please try again later"),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(ctx).pop();
                                      },
                                      child: Container(
                                        color: Colors.orange,
                                        padding: const EdgeInsets.all(14),
                                        child: const Text("Close",
                                            style:
                                                TextStyle(color: Colors.white)),
                                      ),
                                    ),
                                  ],
                                ));
                      }
                      // showDialog(
                      //     context: context,
                      //     builder: (ctx) => AlertDialog(
                      //       title: const Text(
                      //         "Constitution and laws",
                      //         style: TextStyle(color: Colors.blue),
                      //       ),
                      //       content: const Text(""),
                      //       actions: <Widget>[
                      //         TextButton(
                      //           onPressed: () {
                      //             Navigator.of(ctx).pop();
                      //           },
                      //           child: Container(
                      //             color: Colors.orange,
                      //             padding: const EdgeInsets.all(14),
                      //             child: const Text("Close",
                      //                 style:
                      //                 TextStyle(color: Colors.white)),
                      //           ),
                      //         ),
                      //       ],
                      //     ));
                    },
                    child: const Text(
                      'I have read and accept terms and conditions',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Color.fromARGB(255, 16, 145, 251)),
                    ),
                  )
                ],
              ),
            ])));
  }
}

//vehicle type drop down list values
List vehicles = [];
List<String> vehicleType = [];
late Map<String, int> vehicleMap;
String vehicle_type_value = "";

TextEditingController vehicleplate_value = TextEditingController();

//input for vehicle plate
var inputvehicleplate = TextFormField(
  controller: vehicleplate_value,
  validator: (value) => validateStringNotEmpty(value, "vehicle plate"),
  decoration: const InputDecoration(
    // icon: const Icon(Icons.person),
    hintText: 'Enter your vehicle plate',
    labelText: 'Vehicle Plate',
  ),
);

TextEditingController vehicleowner_value = TextEditingController();

//input for vehicle owner
var inputvehicleowner = TextFormField(
  controller: vehicleowner_value,
  validator: (value) => validateName(value, "owner of vehicle"),
  decoration: const InputDecoration(
    // icon: const Icon(Icons.person),
    hintText: 'Enter owner of vehicle',
    labelText: 'Vehicle Owner',
  ),
);
