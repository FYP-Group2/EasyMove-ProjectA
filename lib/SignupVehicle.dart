import 'package:flutter/material.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:getwidget/getwidget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:driver_integrated/Notice.dart';

final String url = "awcgroup.com.my";
final String unencodedPath = "/easymovenpick.com/api/driver_apply.php";
final Map<String, String> headers = {'Content-Type': 'application/json; charset=UTF-8'};


void makePostRequest(String url, String unencodedPath, Map<String, String> header, Map<String,String> requestBody) async {
  final response = await http.post(
      Uri.http(url,unencodedPath),
      // headers: header,
      body: requestBody
  );
  print(response.statusCode);
  print(response.body);
}

final _formKey = GlobalKey<FormState>();
//for uploading image
XFile? driver_license_image;
XFile? back_vehicle_image;
XFile? front_vehicle_image;

class SignupVehicle extends StatelessWidget {
  SignupVehicle(this.fullname,this.ic,this.mobilenumber,this.emergencycontact,this.employmenttype,this.region,this.frontic,this.backic,this.username,this.password);
  final String fullname;
  final String ic;
  final String mobilenumber;
  final String emergencycontact;
  final String employmenttype;
  final String region;
  final XFile? frontic;
  final XFile? backic;
  final String username;
  final String password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: AppBar(
          title: Image.asset(
              'assets/images/icon.png', height: 100),
          centerTitle: true,
          backgroundColor: Color(0xFFFFA600),
        ),
      ),
      body: signupForm(),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
        gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Colors.grey.shade300,Colors.white],
        stops: [0.05,0.2],
        ),
        ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          new GestureDetector(
            onTap:(){
              if (_formKey.currentState!.validate() && driver_license_image != null && back_vehicle_image != null && front_vehicle_image != null) {
                final Map<String, String> body = {'region':region,
                                                  "type":vehicle_type_value,
                                                  "name":fullname,
                                                  "time":employmenttype,
                                                  "mobile":mobilenumber,
                                                  "emergency":emergencycontact,
                                                  "plate":vehicleplate_value.text,
                                                  "owner": vehicleowner_value.text,
                                                  "username" : username,
                                                  "password": password};
                makePostRequest(url, unencodedPath, headers, body);
                Navigator.push(context,
                  MaterialPageRoute(builder:(context) => Notice()),
                );
              }
            },
            child: Container(
              child: Text("Done", style: TextStyle(color: Colors.orange[400],fontSize: 30),),
              padding: EdgeInsets.only(right:40, bottom: 5,top:10),
            ),
          ),
        ],
    )
      )
      );
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

  // void httpMessage(String message){
  //   showDialog(
  //       context: context,
  //       builder: (BuildContext context){
  //         return AlertDialog(
  //             shape:
  //             RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  //             title: Text('Error'),
  //             content: Container(
  //               height: MediaQuery.of(context).size.height / 6,
  //               child: Text("k"),
  //             )
  //         );
  //       });
  // }

  //we can upload image from camera or from gallery based on parameter
  Future getImage(ImageSource media, String info) async {
    var img = await picker.pickImage(source: media);

    if (info == "driverlicense") {
      setState(() {
        driver_license_image = img;
      });
    }
    if(info == "frontvehicle"){
      setState(() {
        front_vehicle_image = img;
      });
    }
    if(info == "backvehicle"){
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
                      getImage(ImageSource.gallery,info);
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
                      getImage(ImageSource.camera,info);
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
  Widget build(BuildContext context){
    return Form(
      key: _formKey,
      child: new SingleChildScrollView(
        padding: EdgeInsets.only(left:15,right:15),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[

            //input vehicle type
            DropdownButton(
              value: vehicle_type_value,
              items: vehicle_type.map((String vehicle_type) {
                return DropdownMenuItem(
                  value: vehicle_type,
                  child: Text(vehicle_type),
                );
              }).toList(),
              icon: const Icon(Icons.keyboard_arrow_down),
              onChanged: (String? newValue) {
                setState(() {
                  vehicle_type_value = newValue!;
            });
            },
            ),

            //input vehicle owner
            inputvehicleowner,

            //input vehicle plate
            Padding(
              padding: EdgeInsets.only(bottom:10),
            child: inputvehicleplate,
            ),



            //input driver's license
            Column(
              children: [
                Text("Front Of Driver's Driving License",style: TextStyle(fontSize: 18),),
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
              padding: const EdgeInsets.only(left: 5, right:5 ,bottom:20),
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
                Text("Front Of Vehicle",style: TextStyle(fontSize: 18),),
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
              padding: const EdgeInsets.only(left: 5, right:5 ,bottom:20),
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
                Text("Back Of Vehicle",style: TextStyle(fontSize: 18),),
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
              padding: const EdgeInsets.only(left: 5, right:5 ,bottom:20),
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

      ]
    )
    )
    );
  }
}

//vehicle type drop down list values
var vehicle_type = [
  'Motorcycle',
  'Sedan',
  'SUV',
  'Pickup Truck',
  'Van',
  'Lorry',
];
String vehicle_type_value = 'Motorcycle';

TextEditingController vehicleplate_value = TextEditingController();

//input for vehicle plate
var inputvehicleplate = TextFormField(
  controller: vehicleplate_value,
  validator: (value){
    if (value == null || value.isEmpty){
      return 'Please enter the vehicle registered plate';
    }
    return null;
  },
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
  validator: (value){
    if (value == null || value.isEmpty){
      return 'Please enter the owner of the vehicle';
    }
    return null;
  },
  decoration: const InputDecoration(
    // icon: const Icon(Icons.person),
    hintText: 'Enter owner of vehicle',
    labelText: 'Vehicle Owner',
  ),
);