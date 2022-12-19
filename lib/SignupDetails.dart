import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:driver_integrated/SignupVehicle.dart';
import 'dart:io';

final _formKey = GlobalKey<FormState>();

//for uploading image
XFile? front_ic_image;
XFile? back_ic_image;


class SignupDetails extends StatelessWidget {
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
          )
        ),
      child:Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          new GestureDetector(
              onTap:(){
                if (_formKey.currentState!.validate() && front_ic_image != null && back_ic_image != null) {
                  Navigator.push(context,
                    MaterialPageRoute(builder:(context) => SignupVehicle(fullname_value.text,ic_value.text,mobilenumber_value.text,emergencycontact_value.text,employment_type_value,region_value,front_ic_image,back_ic_image,username_value.text,password_value.text )),
                  );
                }
              },
              child: new Text("Next", style: TextStyle(color: Colors.orange[400],fontSize: 30),),
          ),
          Padding(
            padding: EdgeInsets.only(right: 20),
            child:Icon(
              IconData(0xe09e, fontFamily: 'MaterialIcons', matchTextDirection: true),size: 50, color: Colors.orange[400],
            ),
            ),
          ]

      ),
      ),
      );
  }
}

class signupForm extends StatefulWidget {
  @override
  signupFormState createState() {
    return signupFormState();
  }
}

//signupform (page1)
class signupFormState extends State<signupForm>{

  final ImagePicker picker = ImagePicker();

  //we can upload image from camera or from gallery based on parameter
  Future getImage(ImageSource media, String info) async {
    var img = await picker.pickImage(source: media);

    if (info == "frontic") {
      setState(() {
        front_ic_image = img;
      });
    }
    if(info == "backic"){
      setState(() {
        back_ic_image = img;
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
            title: Text('Please choose a media to upload from'),
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
            //input field for full name
            inputfullname,

            //input field for username
            inputusername,

            //input field for password
            inputpassword,

            //input field for ic number
            inputicnumber,

            //input field for mobile number
            inputmobilenumber,

            //input field for emergency contact number
            Padding(
              padding: EdgeInsets.only(bottom: 15),
              child:inputemergencycontactmobilenumber,
            ),

            //two drop down list
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [

                //employment type
                Column(
                  children: [
                    Text("Employment Type"),
                    //input field for employment type
                    Container(
                    child:DropdownButton(
                      value: employment_type_value,
                      items: employment_type.map((String employment_type) {
                        return DropdownMenuItem(
                          value: employment_type,
                          child: Text(employment_type),
                        );
                      }).toList(),
                      icon: const Icon(Icons.keyboard_arrow_down),
                      onChanged: (String? newValue) {
                        setState(() {
                          employment_type_value = newValue!;
                        });
                      },
                    ),
                    ),
                  ],
                ),

                //region
                Column(
                  children: [
                    Text("Region"),
                    //input field for region
                    DropdownButton(
                      value: region_value,
                      items: region.map((String region) {
                        return DropdownMenuItem(
                          value: region,
                          child: Text(region),
                        );
                      }).toList(),
                      icon: const Icon(Icons.keyboard_arrow_down),
                      onChanged: (String? newValue) {
                        setState(() {
                          region_value = newValue!;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),

            //input for front of driver's IC
            Column(
              children: [
                Text("Front Of Driver's I.C.",style: TextStyle(fontSize: 18),),
                GFButton(
                  color: Colors.orange,
                  onPressed: () {
                    myAlert('frontic');
                  },
                  text: "Upload Image",
                  shape: GFButtonShape.pills,
                ),
              ],
            ),

            //show image
            front_ic_image != null
                ? Padding(
              padding: const EdgeInsets.only(left: 5, right:5 ,bottom:20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  //to show image
                  File(front_ic_image!.path),
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

            //input for back of driver's IC
            Column(
              children: [
                Text("Back Of Driver's I.C.",style: TextStyle(fontSize: 18),),
                GFButton(
                  color: Colors.orange,
                  onPressed: () {
                    myAlert('backic');
                  },
                  text: "Upload Image",
                  shape: GFButtonShape.pills,
                ),
              ],
            ),

            //show image
            back_ic_image != null
                ? Padding(
              padding: const EdgeInsets.only(left: 5, right:5, bottom: 20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  //to show image
                  File(back_ic_image!.path),
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
          ],
        ),
        ),
    );
  }
}

//to get input full name value
TextEditingController fullname_value = TextEditingController();

//input full name
var inputfullname = TextFormField(
  controller: fullname_value,
  decoration: const InputDecoration(
    // icon: const Icon(Icons.person),
    hintText: 'Enter your name',
    labelText: 'Full Name As Per IC',
  ),
  validator: (value){
    if (value == null || value.isEmpty){
      return 'Please enter your full name as per IC';
    }
    return null;
  },
);

//to get input username value
TextEditingController username_value = TextEditingController();

//input full name
var inputusername = TextFormField(
  controller: username_value,
  decoration: const InputDecoration(
    // icon: const Icon(Icons.person),
    hintText: 'Create your username',
    labelText: 'Login Username',
  ),
  validator: (value){
    if (value == null || value.isEmpty){
      return 'Please create your username';
    }
    return null;
  },
);

//to get input password value
TextEditingController password_value = TextEditingController();

//input full name
var inputpassword = TextFormField(
  controller: password_value,
  obscureText: true,
  decoration: const InputDecoration(
    // icon: const Icon(Icons.person),
    hintText: 'Create your password',
    labelText: 'Login Password',
  ),
  validator: (value){
    if (value == null || value.isEmpty){
      return 'Please create your password';
    }
    return null;
  },
);

//to get input full name value
TextEditingController ic_value = TextEditingController();

//input ic number
var inputicnumber = TextFormField(
  controller: ic_value,

  keyboardType: TextInputType.number,
  decoration: const InputDecoration(
    // icon: const Icon(Icons.person),
    hintText: 'Enter your I.C. number',
    labelText: 'Identity Card Number',
  ),
  validator: (value){
    if (value == null || value.isEmpty){
      return 'Please enter your IC number';
    }
    return null;
  },
);

//to get input full name value
TextEditingController mobilenumber_value = TextEditingController();

//input mobile number
var inputmobilenumber = TextFormField(
  controller: mobilenumber_value,
  keyboardType: TextInputType.number,
  decoration: const InputDecoration(
    // icon: const Icon(Icons.person),
    hintText: 'Enter your mobile number',
    labelText: 'Mobile Phone Number',
  ),
  validator: (value){
    if (value == null || value.isEmpty){
      return 'Please enter your mobile number';
    }
    return null;
  },
);

//to get input full name value
TextEditingController emergencycontact_value = TextEditingController();

//input emergency contact number
var inputemergencycontactmobilenumber = TextFormField(
  controller: emergencycontact_value,
  keyboardType: TextInputType.number,
  decoration: const InputDecoration(
    // icon: const Icon(Icons.person),
    hintText: 'Enter your emergency contact mobile number',
    labelText: 'Emergency Contact Mobile Phone Number',
  ),
  validator: (value){
    if (value == null || value.isEmpty){
      return 'Please enter your emergency contact number';
    }
    return null;
  },
);

//employment type drop down list values
var employment_type = [
  'Part-Time',
  'Full-Time',
];
String employment_type_value = 'Part-Time';

//region drop down list values
var region = [
  'Region 1',
  'Region 2',
  'Region 3',
];
String region_value = 'Region 1';


