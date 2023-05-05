import 'dart:io';
import 'Notice.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:driver_integrated/screen_size.dart';
import 'package:driver_integrated/my_api_service.dart';
import 'package:driver_integrated/firebase_service.dart';
import 'package:driver_integrated/validation_helpers.dart';
import 'package:shared_preferences/shared_preferences.dart';


//for uploading image
XFile? front_ic_image;
XFile? back_ic_image;
XFile? driver_license_image;
XFile? back_vehicle_image;
XFile? front_vehicle_image;

bool agree = false;

class SignupDetails extends StatefulWidget {
  @override
  State<SignupDetails> createState() => signupFormState();
}

class signupFormState extends State<SignupDetails> {
  final _signupformKey = GlobalKey<FormState>();
  final fullname_value = TextEditingController();
  final username_value = TextEditingController();
  final password_value = TextEditingController();
  final ic_value = TextEditingController();
  final mobilenumber_value = TextEditingController();
  final emergencycontact_value = TextEditingController();
  final vehicleplate_value = TextEditingController();
  final vehicleowner_value = TextEditingController();

  @override
  void dispose() {
    fullname_value.dispose();
    username_value.dispose();
    password_value.dispose();
    ic_value.dispose();
    mobilenumber_value.dispose();
    emergencycontact_value.dispose();
    vehicleplate_value.dispose();
    vehicleowner_value.dispose();
    super.dispose();
  }

  // employment type drop down list values
  var employment_type = [
    'Part-Time',
    'Full-Time',
  ];
  String employment_type_value = 'Part-Time';

  // region drop down list values
  List regions = [];
  List<String> region = [];
  late Map<String, int> regionMap;
  String region_value = '';

  // vehicle type drop down list values
  List vehicles = [];
  List<String> vehicleType = [];
  late Map<String, int> vehicleMap;
  String vehicle_type_value = '';

  final ImagePicker picker = ImagePicker();
  FirebaseService firebaseService = FirebaseService();

  Future getImage(ImageSource media, String info) async {
    var img = await picker.pickImage(source: media);
    if (info == "frontic") {
      setState(() {
        front_ic_image = img;
      });
    }
    if (info == "backic") {
      setState(() {
        back_ic_image = img;
      });
    }
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

  Future<List> getRegions() async {
    regions = await MyApiService.getRegions();
    regionMap = regions[0];
    region = regions[1];
    if (region_value == "") {
      region_value = region[0];
    }
    return regions;
  }

  Future<List> getVehicles() async {
    vehicles = await MyApiService.getVehicles();
    vehicleMap = vehicles[0];
    vehicleType = vehicles[1];
    if (vehicle_type_value == "") {
      vehicle_type_value = vehicleType[0];
    }
    return vehicles;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    // Upload Image Window
    void myAlert(String info) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              title: const Text('Please choose a media to upload from'),
              content: SizedBox(
                height: MediaQuery.of(context).size.height / 6,
                child: Column(
                  children: [
                    ElevatedButton(
                      //upload image from gallery
                      onPressed: () {
                        Navigator.pop(context);
                        getImage(ImageSource.gallery, info);
                      },
                      child: Row(
                        children: const <Widget>[
                          Icon(Icons.image),
                          Text('From Gallery'),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      //upload image from camera
                      onPressed: () {
                        Navigator.pop(context);
                        getImage(ImageSource.camera, info);
                      },
                      child: Row(
                        children: const <Widget>[
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

    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
        centerTitle: true,
        backgroundColor: Colors.orange.shade700,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          Container(
            width: ScreenSize.screenWidth(context),
            height: ScreenSize.screenHeight(context),
            padding: EdgeInsets.symmetric(
              horizontal: ScreenSize.screenWidth(context) * 0.05,
              vertical: ScreenSize.screenHeight(context) * 0.02
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
                    // Sign-Up Form
                    Form(
                        key: _signupformKey,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              SizedBox(height: ScreenSize.screenHeight(context) * 0.01),
                              Container(
                                height: 60,
                                child: TextFormField(
                                  controller: fullname_value,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(16),
                                    prefixIconConstraints: BoxConstraints(
                                        minWidth: 55
                                    ),
                                    prefixIcon: Icon(
                                      Icons.person,
                                      color: Colors.white70,
                                      size: 22,
                                    ),
                                    labelText: 'Full Name As Per IC *',
                                    labelStyle: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14.5
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(100)
                                            .copyWith(bottomRight: Radius.circular(0)),
                                        borderSide: BorderSide(color: Colors.white38)
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(100)
                                            .copyWith(bottomRight: Radius.circular(0)),
                                        borderSide: BorderSide(color: Colors.white70)
                                    ),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(100)
                                            .copyWith(bottomRight: Radius.circular(0)),
                                        borderSide: BorderSide(color: Colors.white38)
                                    ),
                                  ),
                                  validator: (value) => validateName (
                                      value, "Full name as per IC"
                                  ),
                                ),
                              ),
                              SizedBox(height: ScreenSize.screenHeight(context) * 0.01),
                              Container(
                                height: 60,
                                child: TextFormField(
                                  controller: username_value,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(16),
                                    prefixIconConstraints: BoxConstraints(
                                        minWidth: 55
                                    ),
                                    prefixIcon: Icon(
                                      Icons.account_circle,
                                      color: Colors.white70,
                                      size: 22,
                                    ),
                                    labelText: 'Login Username *',
                                    labelStyle: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14.5
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(100)
                                            .copyWith(bottomRight: Radius.circular(0)),
                                        borderSide: BorderSide(color: Colors.white38)
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(100)
                                            .copyWith(bottomRight: Radius.circular(0)),
                                        borderSide: BorderSide(color: Colors.white70)
                                    ),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(100)
                                            .copyWith(bottomRight: Radius.circular(0)),
                                        borderSide: BorderSide(color: Colors.white38)
                                    ),
                                  ),
                                  validator: (value) => validateStringNotEmpty (
                                      value, "username"
                                  ),
                                ),
                              ),
                              SizedBox(height: ScreenSize.screenHeight(context) * 0.01),
                              Container(
                                height: 60,
                                child: TextFormField(
                                  controller: password_value,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(16),
                                    prefixIconConstraints: BoxConstraints(
                                        minWidth: 55
                                    ),
                                    prefixIcon: Icon(
                                      Icons.lock,
                                      color: Colors.white70,
                                      size: 22,
                                    ),
                                    labelText: 'Login Password *',
                                    labelStyle: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14.5
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(100)
                                            .copyWith(bottomRight: Radius.circular(0)),
                                        borderSide: BorderSide(color: Colors.white38)
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(100)
                                            .copyWith(bottomRight: Radius.circular(0)),
                                        borderSide: BorderSide(color: Colors.white70)
                                    ),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(100)
                                            .copyWith(bottomRight: Radius.circular(0)),
                                        borderSide: BorderSide(color: Colors.white38)
                                    ),
                                  ),
                                  validator: validatePassword,
                                ),
                              ),
                              SizedBox(height: ScreenSize.screenHeight(context) * 0.01),
                              Container(
                                height: 60,
                                child: TextFormField(
                                  controller: ic_value,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(16),
                                    prefixIconConstraints: BoxConstraints(
                                        minWidth: 55
                                    ),
                                    prefixIcon: Icon(
                                      Icons.credit_card_rounded,
                                      color: Colors.white70,
                                      size: 22,
                                    ),
                                    labelText: 'Identity Card Number *',
                                    labelStyle: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14.5
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(100)
                                            .copyWith(bottomRight: Radius.circular(0)),
                                        borderSide: BorderSide(color: Colors.white38)
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(100)
                                            .copyWith(bottomRight: Radius.circular(0)),
                                        borderSide: BorderSide(color: Colors.white70)
                                    ),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(100)
                                            .copyWith(bottomRight: Radius.circular(0)),
                                        borderSide: BorderSide(color: Colors.white38)
                                    ),
                                  ),
                                  validator: validateIcNumber,
                                ),
                              ),
                              SizedBox(height: ScreenSize.screenHeight(context) * 0.01),
                              Container(
                                height: 60,
                                child: TextFormField(
                                  controller: mobilenumber_value,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(16),
                                    prefixIconConstraints: BoxConstraints(
                                        minWidth: 55
                                    ),
                                    prefixIcon: Icon(
                                      Icons.phone,
                                      color: Colors.white70,
                                      size: 22,
                                    ),
                                    labelText: 'Mobile Phone Number *',
                                    labelStyle: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14.5
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(100)
                                            .copyWith(bottomRight: Radius.circular(0)),
                                        borderSide: BorderSide(color: Colors.white38)
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(100)
                                            .copyWith(bottomRight: Radius.circular(0)),
                                        borderSide: BorderSide(color: Colors.white70)
                                    ),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(100)
                                            .copyWith(bottomRight: Radius.circular(0)),
                                        borderSide: BorderSide(color: Colors.white38)
                                    ),
                                  ),
                                  validator: (value) => validatePhoneNumber (
                                      value, "Phone Number"
                                  ),
                                ),
                              ),
                              SizedBox(height: ScreenSize.screenHeight(context) * 0.01),
                              Container(
                                height: 60,
                                child: TextFormField(
                                  controller: emergencycontact_value,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(16),
                                    prefixIconConstraints: BoxConstraints(
                                        minWidth: 55
                                    ),
                                    prefixIcon: Icon(
                                      Icons.emergency,
                                      color: Colors.white70,
                                      size: 22,
                                    ),
                                    labelText: 'Emergency Contact Number *',
                                    labelStyle: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14.5
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(100)
                                            .copyWith(bottomRight: Radius.circular(0)),
                                        borderSide: BorderSide(color: Colors.white38)
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(100)
                                            .copyWith(bottomRight: Radius.circular(0)),
                                        borderSide: BorderSide(color: Colors.white70)
                                    ),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(100)
                                            .copyWith(bottomRight: Radius.circular(0)),
                                        borderSide: BorderSide(color: Colors.white38)
                                    ),
                                  ),
                                  validator: (value) => validatePhoneNumber (
                                      value, "Emergency Phone Number"
                                  ),
                                ),
                              ),
                              SizedBox(height: ScreenSize.screenHeight(context) * 0.01),
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            "Employment Type",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(color: Colors.white)
                                        ),
                                        SizedBox(height: ScreenSize.screenHeight(context) * 0.01),
                                        Container(
                                          height: 50,
                                          width: (screenWidth - 75) / 2,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(100)
                                                .copyWith(bottomRight: Radius.circular(0)
                                            ),
                                            border: Border.all(color: Colors.white38, width: 1.0),
                                            color: Colors.transparent,
                                          ),
                                          child: DropdownButtonFormField<String>(
                                            dropdownColor: Colors.orange,
                                            style: const TextStyle(
                                              color: Colors.white,
                                            ),
                                            value: employment_type_value,
                                            items: employment_type.map((String employment_type) {
                                              return DropdownMenuItem(
                                                value: employment_type,
                                                child: Text(employment_type),
                                              );
                                            }).toList(),
                                            icon: const Icon(
                                              Icons.keyboard_arrow_down,
                                              color: Colors.white70,
                                            ),
                                            onChanged: (String? newValue) {
                                              setState(() {
                                                employment_type_value = newValue!;
                                              } );
                                            },
                                            decoration: const InputDecoration(
                                              labelStyle: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16
                                              ),
                                              border: InputBorder.none,
                                              contentPadding: EdgeInsets.all(10),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                            padding: EdgeInsets.only(bottom: 10.0),
                                            child: Text("Region", style: TextStyle(color: Colors.white),)
                                        ),
                                        Container(
                                            height: 50,
                                            width: (screenWidth - 75) / 2,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(100)
                                                  .copyWith(bottomRight: Radius.circular(0)
                                              ),
                                              border: Border.all(color: Colors.white38, width: 1.0),
                                              color: Colors.transparent,
                                            ),
                                            child: FutureBuilder(
                                                future: getRegions(),
                                                builder: (context, snapshot) {
                                                  return DropdownButtonFormField<String>(
                                                    dropdownColor: Colors.orange,
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                    value: region_value,
                                                    items: region.map<DropdownMenuItem<String>>((String region) {
                                                      return DropdownMenuItem(
                                                          value: region,
                                                          child: Text(region)
                                                      );
                                                    }).toList(),
                                                    icon: const Icon(
                                                      Icons.keyboard_arrow_down,
                                                      color: Colors.white70,
                                                    ),
                                                    onChanged: (String? newValue) {
                                                      setState(() {
                                                        region_value = newValue!;
                                                      });
                                                    },
                                                    decoration: const InputDecoration(
                                                      labelStyle: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 16
                                                      ),
                                                      border: InputBorder.none,
                                                      contentPadding: EdgeInsets.all(10),
                                                    ),
                                                  );
                                                }
                                            )
                                        ),
                                      ],
                                    )
                                  ),
                                ],
                              ),
                              SizedBox(height: ScreenSize.screenHeight(context) * 0.02),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  // upload front ic
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text("Front Of Driver's I.C. *",
                                          style: TextStyle(fontSize: 18, color: Colors.white)),
                                      GFButton(
                                        padding: EdgeInsets.only(left: 20,right: 20),
                                        color: Colors.orange,
                                        onPressed: () {
                                          myAlert('frontic');
                                        },
                                        text: "Upload Image",
                                        shape: GFButtonShape.pills,
                                      )
                                    ],
                                  ),
                                  front_ic_image != null
                                      ? Padding(
                                    padding:
                                    const EdgeInsets.only(bottom: 20.0),
                                    child: ClipRRect(
                                      borderRadius:
                                      BorderRadius.circular(8),
                                      child: Image.file(
                                        File(front_ic_image!.path),
                                        fit: BoxFit.cover,
                                        width: screenWidth,
                                        height: 250,
                                      ),
                                    ),
                                  )
                                      : const Text("",
                                      style: TextStyle(fontSize: 20)),
                                  const SizedBox(height: 15.0),
                                  // upload back ic
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text("Back Of Driver's I.C. *",
                                          style: TextStyle(fontSize: 18, color: Colors.white)),
                                      GFButton(
                                        padding: EdgeInsets.only(left: 20,right: 20),
                                        color: Colors.orange,
                                        onPressed: () {
                                          myAlert('backic');
                                        },
                                        text: "Upload Image",
                                        shape: GFButtonShape.pills,
                                      )
                                    ],
                                  ),
                                  back_ic_image != null
                                      ? Padding(
                                    padding: const EdgeInsets.only(
                                        left: 5.0,
                                        right: 5.0,
                                        bottom: 20.0),
                                    child: ClipRRect(
                                      borderRadius:
                                      BorderRadius.circular(8),
                                      child: Image.file(
                                        File(back_ic_image!.path),
                                        fit: BoxFit.cover,
                                        width: screenWidth,
                                        height: 250,
                                      ),
                                    ),
                                  )
                                      : const Text("",
                                      style: TextStyle(fontSize: 20)),
                                ],
                              ),
                              SizedBox(height: ScreenSize.screenHeight(context) * 0.01),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(bottom: 10.0),
                                    child: Text("Vehicle Type", style: TextStyle(color: Colors.white),),
                                  ),
                                  Container(
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(100)
                                            .copyWith(bottomRight: Radius.circular(0)
                                        ),
                                        border: Border.all(color: Colors.white38, width: 1.0),
                                        color: Colors.transparent,
                                      ),
                                      child: FutureBuilder(
                                        future: getVehicles(),
                                        builder: (context, snapshot) {
                                          return DropdownButtonFormField<String>(
                                            dropdownColor: Colors.orange,
                                            style: const TextStyle(
                                              color: Colors.white,
                                            ),
                                            value: vehicle_type_value,
                                            items: vehicleType.map<
                                                DropdownMenuItem<String>>(
                                                    (String vehicleType) {
                                                  return DropdownMenuItem(
                                                    value: vehicleType,
                                                    child: Text(vehicleType),
                                                  );
                                                }).toList(),
                                            icon: const Icon(
                                              Icons.keyboard_arrow_down,
                                              color: Colors.white70,
                                            ),
                                            onChanged: (String? newValue) {
                                              setState(() {
                                                vehicle_type_value =
                                                newValue!;
                                              });
                                            },
                                            decoration: const InputDecoration(
                                              labelStyle: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16
                                              ),
                                              border: InputBorder.none,
                                              contentPadding: EdgeInsets.all(10),
                                            ),
                                          );
                                        },
                                      )
                                  ),
                                ],
                              ),
                              SizedBox(height: ScreenSize.screenHeight(context) * 0.01),
                              Container(
                                height: 60,
                                child: TextFormField(
                                    controller: vehicleplate_value,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(16),
                                      labelText: 'Vehicle plate',
                                      labelStyle: TextStyle(
                                          color: Colors.white, fontSize: 14.5
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(100)
                                              .copyWith(bottomRight: Radius.circular(0)),
                                          borderSide: BorderSide(color: Colors.white38)
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(100)
                                              .copyWith(bottomRight: Radius.circular(0)),
                                          borderSide: BorderSide(color: Colors.white70)
                                      ),
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(100)
                                              .copyWith(bottomRight: Radius.circular(0)),
                                          borderSide: BorderSide(color: Colors.white38)
                                      ),
                                    ),
                                    validator: (value) => validateStringNotEmpty(
                                        value, "vehicle plate"
                                    )
                                ),
                              ),
                              SizedBox(height: ScreenSize.screenHeight(context) * 0.01),
                              Container(
                                height: 60,
                                child: TextFormField(
                                    controller: vehicleowner_value,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(16),
                                      labelText: 'Vehicle Owner',
                                      labelStyle: TextStyle(
                                          color: Colors.white, fontSize: 14.5
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(100)
                                              .copyWith(bottomRight: Radius.circular(0)),
                                          borderSide: BorderSide(color: Colors.white38)
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(100)
                                              .copyWith(bottomRight: Radius.circular(0)),
                                          borderSide: BorderSide(color: Colors.white70)
                                      ),
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(100)
                                              .copyWith(bottomRight: Radius.circular(0)),
                                          borderSide: BorderSide(color: Colors.white38)
                                      ),
                                    ),
                                    validator: (value) => validateName(
                                        value, "owner of vehicle"
                                    )
                                ),
                              ),
                              SizedBox(height: ScreenSize.screenHeight(context) * 0.01),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                          "Front Of Driver's Driving License",
                                          style: TextStyle(fontSize: 18, color: Colors.white)),
                                      GFButton(
                                        padding: EdgeInsets.only(left: 20,right: 20),
                                        color: Colors.orange,
                                        onPressed: () {
                                          myAlert('driverlicense');
                                        },
                                        text: "Upload Image",
                                        shape: GFButtonShape.pills,
                                      )
                                    ],
                                  ),
                                  driver_license_image != null ? Padding(
                                    padding: const EdgeInsets.only(left: 5.0, right: 5.0, bottom: 20.0
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.file(
                                        File(driver_license_image!.path),
                                        fit: BoxFit.cover,
                                        width: screenWidth,
                                        height: 250,
                                      ),
                                    ),
                                  )
                                      : const Text(
                                      "",
                                      style: TextStyle(
                                          fontSize: 20
                                      )
                                  ),
                                  const SizedBox(height: 15.0),
                                  // upload back ic
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text("Front Of Vehicle",
                                          style: TextStyle(fontSize: 18, color: Colors.white)),
                                      GFButton(
                                        padding: EdgeInsets.only(left: 20,right: 20),
                                        color: Colors.orange,
                                        onPressed: () {
                                          myAlert('frontvehicle');
                                        },
                                        text: "Upload Image",
                                        shape: GFButtonShape.pills,
                                      )
                                    ],
                                  ),
                                  front_vehicle_image != null ? Padding(
                                    padding: const EdgeInsets.only(left: 5.0, right: 5.0, bottom: 20.0
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.file(
                                        File(front_vehicle_image!.path),
                                        fit: BoxFit.cover,
                                        width: screenWidth,
                                        height: 250,
                                      ),
                                    ),
                                  )
                                      : const Text(
                                      "",
                                      style: TextStyle(fontSize: 20)
                                  ),
                                  const SizedBox(height: 15.0),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget> [
                                      const Text(
                                          "Back Of Vehicle",
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.white,
                                          )
                                      ),
                                      GFButton(
                                        padding: EdgeInsets.only(left: 20,right: 20),
                                        color: Colors.orange,
                                        onPressed: () {
                                          myAlert('backvehicle');
                                        },
                                        text: "Upload Image",
                                        shape: GFButtonShape.pills,
                                      )
                                    ],
                                  ),
                                  back_vehicle_image != null ? Padding(
                                    padding: const EdgeInsets.only(left: 5.0, right: 5.0, bottom: 20.0
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.file(
                                        File(back_vehicle_image!.path),
                                        fit: BoxFit.cover,
                                        width: screenWidth,
                                        height: 250,
                                      ),
                                    ),
                                  )
                                      : const Text(
                                      "",
                                      style: TextStyle(
                                          fontSize: 20
                                      )
                                  ),
                                ],
                              ),
                              SizedBox(height: ScreenSize.screenHeight(context) * 0.01),
                              Row(
                                children: <Widget> [
                                  Checkbox(
                                    value: agree,
                                    checkColor: Colors.white,
                                    activeColor: Colors.transparent,
                                    onChanged: (value) {
                                      setState(() {
                                        agree = value ?? false;
                                      });
                                    },
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      const url =
                                          "https://easysuperapps.com/policy.php";
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
                                                style: TextStyle(
                                                    color: Colors.blue),
                                              ),
                                              content: const Text(
                                                  "Please try again later"),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(ctx)
                                                        .pop();
                                                  },
                                                  child: Container(
                                                    color: Colors.orange,
                                                    padding: const EdgeInsets.all(14),
                                                    child: const Text(
                                                        "Close",
                                                        style: TextStyle(color: Colors
                                                            .white)
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                        );
                                      }
                                    },
                                    child: const Text(
                                      'I have read and accept terms and conditions',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          decoration:
                                          TextDecoration.underline,
                                          color: Color.fromARGB(255, 16, 145, 251)
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(height: ScreenSize.screenHeight(context) * 0.01),
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
                                      if (!_signupformKey.currentState!
                                          .validate()) {
                                        return;
                                      } else if (front_ic_image == null ||
                                          back_ic_image == null ||
                                          driver_license_image == null ||
                                          back_vehicle_image == null ||
                                          front_vehicle_image == null) {
                                        Fluttertoast.showToast(
                                            msg: "Please provide the required images",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.red,
                                            textColor: Colors.white,
                                            fontSize: 16.0
                                        );
                                      } else {
                                        final Map<String, String> body = {
                                          'region': "$region",
                                          "type": "${vehicleMap[vehicle_type_value]}",
                                          "name": fullname_value.text,
                                          "time": employment_type_value,
                                          "mobile": mobilenumber_value.text,
                                          "emergency": emergencycontact_value.text,
                                          "plate": vehicleplate_value.text,
                                          "owner": vehicleowner_value.text,
                                          "username": username_value.text,
                                          "password": password_value.text,
                                          "token" : firebaseService.fcmToken!
                                        };

                                        await MyApiService.driverApply(body)
                                            .then((result) async {
                                          if (result) {
                                            String icPath = File(front_ic_image!.path).path;
                                            String licensePath = File(driver_license_image!.path).path;
                                            String frontVehiclePath = File(front_vehicle_image!.path).path;
                                            String backVehiclePath = File(back_vehicle_image!.path).path;
                                            MyApiService.photoRegister(
                                                username_value.text,
                                                icPath,
                                                licensePath,
                                                frontVehiclePath,
                                                backVehiclePath);

                                            await MyApiService.getDriverId(username_value.text).then((data) {
                                              dynamic authUser =
                                              data["auth_user"];
                                              int id = authUser["id"];

                                              // MyApiService.updateToken(id, firebaseService.fcmToken!);
                                            });

                                            await SharedPreferences.getInstance().then((pref) {
                                              pref.setString("temperature", username_value.text);
                                            });
                                          }
                                        });
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => const Notice()
                                          ),
                                        );
                                      }
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
                                      "Submit",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                                  )
                              ),
                              SizedBox(height: ScreenSize.screenHeight(context) * 0.01),
                            ]
                        )
                    )
                  ],
                ),
            )
          ),
        ],
      )
    );
  }
}
