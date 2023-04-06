import 'dart:io';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:driver_integrated/my_api_service.dart';
import 'package:driver_integrated/firebase_service.dart';
import 'package:driver_integrated/validation_helpers.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'Notice.dart';

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
    //function for uploading image
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
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80.0),
          child: AppBar(
            title: Image.asset('assets/images/icon.png', height: 100),
            centerTitle: true,
            backgroundColor: const Color(0xFFFFA600),
          ),
        ),
        // body: signupForm(),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Form(
                      key: _signupformKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Padding(
                              padding: const EdgeInsets.only(
                                  right: 30.0, left: 30.0),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    height: 60,
                                    decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.5),
                                              spreadRadius: 2,
                                              blurRadius: 5,
                                              offset: const Offset(0, 2)),
                                        ],
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.white),
                                    child: TextFormField(
                                      controller: fullname_value,
                                      decoration: const InputDecoration(
                                          hintText: 'Enter your name',
                                          labelText: 'Full Name As Per IC *',
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.all(16)),
                                      validator: (value) => validateName(
                                          value, "Full name as per IC"),
                                    ),
                                  ),
                                  const SizedBox(height: 15.0),
                                  Container(
                                    height: 60,
                                    decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.5),
                                              spreadRadius: 2,
                                              blurRadius: 5,
                                              offset: const Offset(0, 2)),
                                        ],
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.white),
                                    child: TextFormField(
                                      controller: username_value,
                                      decoration: const InputDecoration(
                                          hintText: 'Create your username',
                                          labelText: 'Login Username *',
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.all(16)),
                                      validator: (value) =>
                                          validateStringNotEmpty(
                                              value, "username"),
                                    ),
                                  ),
                                  const SizedBox(height: 15.0),
                                  Container(
                                    height: 60,
                                    decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.5),
                                              spreadRadius: 2,
                                              blurRadius: 5,
                                              offset: const Offset(0, 2)),
                                        ],
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.white),
                                    child: TextFormField(
                                      controller: password_value,
                                      decoration: const InputDecoration(
                                          hintText: 'Create your password',
                                          labelText: 'Login Password *',
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.all(16)),
                                      validator: validatePassword,
                                    ),
                                  ),
                                  const SizedBox(height: 15.0),
                                  Container(
                                    height: 60,
                                    decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.5),
                                              spreadRadius: 2,
                                              blurRadius: 5,
                                              offset: const Offset(0, 2)),
                                        ],
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.white),
                                    child: TextFormField(
                                      controller: ic_value,
                                      decoration: const InputDecoration(
                                          hintText: 'Enter your I.C. number',
                                          labelText: 'Identity Card Number *',
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.all(16)),
                                      validator: validateIcNumber,
                                    ),
                                  ),
                                  const SizedBox(height: 15.0),
                                  Container(
                                    height: 60,
                                    decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.5),
                                              spreadRadius: 2,
                                              blurRadius: 5,
                                              offset: const Offset(0, 2)),
                                        ],
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.white),
                                    child: TextFormField(
                                      controller: mobilenumber_value,
                                      decoration: const InputDecoration(
                                          hintText: 'Enter your mobile number',
                                          labelText: 'Mobile Phone Number *',
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.all(16)),
                                      validator: (value) => validatePhoneNumber(
                                          value, "Phone Number"),
                                    ),
                                  ),
                                  const SizedBox(height: 15.0),
                                  Container(
                                    height: 60,
                                    decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.5),
                                              spreadRadius: 2,
                                              blurRadius: 5,
                                              offset: const Offset(0, 2)),
                                        ],
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.white),
                                    child: TextFormField(
                                      controller: emergencycontact_value,
                                      decoration: const InputDecoration(
                                          hintText:
                                              'Enter your emergency contact mobile number',
                                          labelText:
                                              'Emergency Contact Mobile Phone Number *',
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.all(16)),
                                      validator: (value) => validatePhoneNumber(
                                          value, "Emergency Phone Number"),
                                    ),
                                  ),
                                  const SizedBox(height: 15.0),
                                  // employment type and region dropdown
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Padding(
                                              padding:
                                                  EdgeInsets.only(bottom: 10.0),
                                              child: Text("Employment Type")),
                                          Container(
                                            height: 50,
                                            width: (screenWidth - 75) / 2,
                                            decoration: BoxDecoration(
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(0.5),
                                                      spreadRadius: 2,
                                                      blurRadius: 5,
                                                      offset:
                                                          const Offset(0, 2))
                                                ],
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: Colors.white),
                                            child:
                                                DropdownButtonFormField<String>(
                                              value: employment_type_value,
                                              items: employment_type.map(
                                                  (String employment_type) {
                                                return DropdownMenuItem(
                                                  value: employment_type,
                                                  child: Text(employment_type),
                                                );
                                              }).toList(),
                                              icon: const Icon(
                                                  Icons.keyboard_arrow_down),
                                              onChanged: (String? newValue) {
                                                setState(() {
                                                  employment_type_value =
                                                      newValue!;
                                                });
                                              },
                                              decoration: const InputDecoration(
                                                hintText: 'Zone',
                                                border: InputBorder.none,
                                                contentPadding:
                                                    EdgeInsets.all(16),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(width: 10.0),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Padding(
                                              padding:
                                                  EdgeInsets.only(bottom: 10.0),
                                              child: Text("Region")),
                                          Container(
                                              height: 50,
                                              width: (screenWidth - 75) / 2,
                                              decoration: BoxDecoration(
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: Colors.black
                                                            .withOpacity(0.5),
                                                        spreadRadius: 2,
                                                        blurRadius: 5,
                                                        offset:
                                                            const Offset(0, 2))
                                                  ],
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: Colors.white),
                                              child: FutureBuilder(
                                                  future: getRegions(),
                                                  builder: (context, snapshot) {
                                                    //input field for region
                                                    return DropdownButtonFormField<
                                                        String>(
                                                      value: region_value,
                                                      items: region.map<
                                                              DropdownMenuItem<
                                                                  String>>(
                                                          (String region) {
                                                        return DropdownMenuItem(
                                                            value: region,
                                                            child:
                                                                Text(region));
                                                      }).toList(),
                                                      icon: const Icon(Icons
                                                          .keyboard_arrow_down),
                                                      onChanged:
                                                          (String? newValue) {
                                                        setState(() {
                                                          region_value =
                                                              newValue!;
                                                        });
                                                      },
                                                      decoration:
                                                          const InputDecoration(
                                                        hintText: 'Zone',
                                                        border:
                                                            InputBorder.none,
                                                        contentPadding:
                                                            EdgeInsets.all(16),
                                                      ),
                                                    );
                                                  })),
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              )),
                          const SizedBox(height: 15.0),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 20.0, left: 30.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                // upload front ic
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("Front Of Driver's I.C. *",
                                        style: TextStyle(fontSize: 18)),
                                    GFButton(
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
                                        style: TextStyle(fontSize: 18)),
                                    GFButton(
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
                          ),
                          const SizedBox(height: 15.0),
                          Padding(
                            padding:
                                const EdgeInsets.only(right: 30.0, left: 30.0),
                            child: Column(
                              children: <Widget>[
                                // vehicle type drop down
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(bottom: 10.0),
                                      child: Text("Vehicle Type"),
                                    ),
                                    Container(
                                        height: 50,
                                        decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.5),
                                                  spreadRadius: 2,
                                                  blurRadius: 5,
                                                  offset: const Offset(0, 2))
                                            ],
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Colors.white),
                                        child: FutureBuilder(
                                          future: getVehicles(),
                                          builder: (context, snapshot) {
                                            return DropdownButtonFormField<
                                                String>(
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
                                                  Icons.keyboard_arrow_down),
                                              onChanged: (String? newValue) {
                                                setState(() {
                                                  vehicle_type_value =
                                                      newValue!;
                                                });
                                              },
                                              decoration: const InputDecoration(
                                                hintText: 'Vehicle Type',
                                                border: InputBorder.none,
                                                contentPadding:
                                                    EdgeInsets.all(16),
                                              ),
                                            );
                                          },
                                        )),
                                  ],
                                ),
                                const SizedBox(height: 15.0),
                                Container(
                                  height: 60,
                                  decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.5),
                                            spreadRadius: 2,
                                            blurRadius: 5,
                                            offset: const Offset(0, 2)),
                                      ],
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white),
                                  child: TextFormField(
                                      controller: vehicleplate_value,
                                      decoration: const InputDecoration(
                                          hintText: 'Enter your vehicle plate',
                                          labelText: 'Vehicle Plate',
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.all(16)),
                                      validator: (value) =>
                                          validateStringNotEmpty(
                                              value, "vehicle plate")),
                                ),
                                const SizedBox(height: 15.0),
                                Container(
                                  height: 60,
                                  decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.5),
                                            spreadRadius: 2,
                                            blurRadius: 5,
                                            offset: const Offset(0, 2)),
                                      ],
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white),
                                  child: TextFormField(
                                      controller: vehicleowner_value,
                                      decoration: const InputDecoration(
                                          hintText: 'Enter owner of vehicle',
                                          labelText: 'Vehicle Owner',
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.all(16)),
                                      validator: (value) => validateName(
                                          value, "owner of vehicle")),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 15.0),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 20.0, left: 30.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                        "Front Of Driver's Driving License",
                                        style: TextStyle(fontSize: 18)),
                                    GFButton(
                                      color: Colors.orange,
                                      onPressed: () {
                                        myAlert('driverlicense');
                                      },
                                      text: "Upload Image",
                                      shape: GFButtonShape.pills,
                                    )
                                  ],
                                ),
                                driver_license_image != null
                                    ? Padding(
                                        padding: const EdgeInsets.only(
                                            left: 5.0,
                                            right: 5.0,
                                            bottom: 20.0),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: Image.file(
                                            File(driver_license_image!.path),
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
                                    const Text("Front Of Vehicle",
                                        style: TextStyle(fontSize: 18)),
                                    GFButton(
                                      color: Colors.orange,
                                      onPressed: () {
                                        myAlert('frontvehicle');
                                      },
                                      text: "Upload Image",
                                      shape: GFButtonShape.pills,
                                    )
                                  ],
                                ),
                                front_vehicle_image != null
                                    ? Padding(
                                        padding: const EdgeInsets.only(
                                            left: 5.0,
                                            right: 5.0,
                                            bottom: 20.0),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: Image.file(
                                            File(front_vehicle_image!.path),
                                            fit: BoxFit.cover,
                                            width: screenWidth,
                                            height: 250,
                                          ),
                                        ),
                                      )
                                    : const Text("",
                                        style: TextStyle(fontSize: 20)),
                                const SizedBox(height: 15.0),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("Back Of Vehicle",
                                        style: TextStyle(fontSize: 18)),
                                    GFButton(
                                      color: Colors.orange,
                                      onPressed: () {
                                        myAlert('backvehicle');
                                      },
                                      text: "Upload Image",
                                      shape: GFButtonShape.pills,
                                    )
                                  ],
                                ),
                                back_vehicle_image != null
                                    ? Padding(
                                        padding: const EdgeInsets.only(
                                            left: 5.0,
                                            right: 5.0,
                                            bottom: 20.0),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: Image.file(
                                            File(back_vehicle_image!.path),
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
                          ),
                          const SizedBox(height: 15.0),
                          Padding(
                            padding:
                                const EdgeInsets.only(right: 30.0, left: 30.0),
                            child: Column(
                              children: [
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
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(14),
                                                          child: const Text(
                                                              "Close",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white)),
                                                        ),
                                                      ),
                                                    ],
                                                  ));
                                        }
                                      },
                                      child: const Text(
                                        'I have read and accept terms and conditions',
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            decoration:
                                                TextDecoration.underline,
                                            color: Color.fromARGB(
                                                255, 16, 145, 251)),
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(height: 15.0),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 20.0),
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
                                            msg:
                                                "Please provide the required images",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.red,
                                            textColor: Colors.white,
                                            fontSize: 16.0);
                                      } else {
                                        final Map<String, String> body = {
                                          'region': "$region",
                                          "type":
                                              "${vehicleMap[vehicle_type_value]}",
                                          "name": fullname_value.text,
                                          "time": employment_type_value,
                                          "mobile": mobilenumber_value.text,
                                          "emergency":
                                              emergencycontact_value.text,
                                          "plate": vehicleplate_value.text,
                                          "owner": vehicleowner_value.text,
                                          "username": username_value.text,
                                          "password": password_value.text,
                                          "token" : firebaseService.fcmToken!
                                        };

                                        await MyApiService.driverApply(body)
                                            .then((result) async {
                                          if (result) {
                                            String icPath =
                                                File(front_ic_image!.path).path;
                                            String licensePath =
                                                File(driver_license_image!.path)
                                                    .path;
                                            String frontVehiclePath =
                                                File(front_vehicle_image!.path)
                                                    .path;
                                            String backVehiclePath =
                                                File(back_vehicle_image!.path)
                                                    .path;
                                            MyApiService.photoRegister(
                                                username_value.text,
                                                icPath,
                                                licensePath,
                                                frontVehiclePath,
                                                backVehiclePath);

                                            await MyApiService.getDriverId(
                                                    username_value.text)
                                                .then((data) {
                                              dynamic authUser =
                                                  data["auth_user"];
                                              int id = authUser["id"];

                                              // MyApiService.updateToken(id,
                                              //     firebaseService.fcmToken!,driver.jwtToken);
                                            });

                                            await SharedPreferences
                                                    .getInstance()
                                                .then((pref) {
                                              pref.setString("temperature",
                                                  username_value.text);
                                            });
                                          }
                                        });
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const Notice()),
                                        );
                                      }
                                    },
                                    style: ButtonStyle(
                                      minimumSize: MaterialStateProperty.all(
                                          Size(screenWidth - 60, 40)),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      elevation:
                                          MaterialStateProperty.all<double>(8),
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              const Color(0xFFB09A73)),
                                    ),
                                    child: const Text(
                                      "Submit",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      )))
            ],
          ),
        ));
  }
}
