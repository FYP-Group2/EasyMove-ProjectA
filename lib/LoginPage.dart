import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:driver_integrated/NavBar.dart';
import 'package:driver_integrated/driver.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

final String url = "awcgroup.com.my";
final String unencodedPath = "/easymovenpick.com/api/driver_login.php";
final Map<String, String> headers = {'Content-Type': 'application/json; charset=UTF-8'};
String? response_message;


class LoginPage extends StatelessWidget {
  Driver driver = Driver();

  @override
  Widget build(BuildContext context) {
    void makePostRequest(String url, String unencodedPath, Map<String, String> header, Map<String,String> requestBody) async {
      final response = await http.post(
          Uri.http(url,unencodedPath),
          // headers: header,
          body: requestBody
      );
      final data = json.decode(response.body);
      final auth_user = data["auth_user"];

      int id = auth_user["id"];
      int region = auth_user["region"];
      int vehicleType = auth_user["vehicle_type"];
      String name = auth_user["name"];
      driver.initializeDriver(id, region, vehicleType, name);

      response_message = (data["auth_user"]["message"]);
      print(response.statusCode);
      print(response_message);
      if(response_message == "Login successfully."){
        Navigator.push(context,
          MaterialPageRoute(builder:(context) => NavBar(currentPage: PageItem.Home,)),
        );
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
            Padding(
              padding: EdgeInsets.only(top:20, bottom: 15),
              child: Text("Username",style: TextStyle(color: Colors.white,fontSize: 20),),
            ),
            inputusername,
            Padding(
                padding: EdgeInsets.only(top:20, bottom: 15),
                child: Text("Password",style: TextStyle(color: Colors.white,fontSize: 20),),
            ),
            inputpassword,
            Padding(
                padding: EdgeInsets.only(top:30),
                child: GFButton(
                  color: Colors.white,//need to change
                  onPressed: () {
                    final Map<String, String> body = {'username' : username_value.text, "password": password_value.text};
                    makePostRequest(url, unencodedPath, headers, body);
                  },
                  text: "Login",
                  textColor: Colors.orange[400],
                  textStyle: TextStyle(fontSize: 16,color: Colors.orange[400]),
                  ),
            ),
          ],
        )
        )
    );
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
    style: TextStyle(fontSize: 16, color: Colors.black,),
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
    style: TextStyle(fontSize: 16, color: Colors.black,),
  ),

);

