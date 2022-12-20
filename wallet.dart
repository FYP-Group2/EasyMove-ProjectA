import 'package:driver_integrated/merit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:getwidget/getwidget.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:driver_integrated/driver.dart';
import 'package:driver_integrated/withdrawal.dart';
import 'package:driver_integrated/my_api_service.dart';

final String url = "awcgroup.com.my";
final Map<String, String> header = {'Content-Type': 'application/json; charset=UTF-8'};
bool withdraw = false;

void makePostRequestWithdrawal(String url,String unencodedPath, Map<String,String> requestBody) async {
  final response = await http.post(
      Uri.http(url,unencodedPath),
      body: requestBody
  );
  // print(response.statusCode);
  // print(response.body);
  final data = json.decode(response.body);
  print(data);
  String msg = (data["message"]);
  if (msg == "Request sent successfully.")
  {
    withdraw = true;
  }
}

class Wallet extends StatefulWidget {
  Map<String, dynamic> text = {};
  @override
  walletPageState createState() {
    return walletPageState();
  }
}

class walletPageState extends State<Wallet> {
  Driver driver = Driver();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Wallet", style: const TextStyle(color: Colors.white),),
          backgroundColor: const Color.fromARGB(255, 255, 168, 0),
        ),
        body:Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _commission(),
            _requestbutton(context),
            _merit(),
            _requestbutton(context),
            // _commissionlist(),
          ],
        ));
  }

  //apiservice for wallet
  Future<Map<String, dynamic>> initWallet() async{
    final meritData = await MyApiService.getCommissionStatement(driver.id.toString());
    widget.text = meritData;
    return meritData;
  }

  //commission + bonus
  Widget _commission() {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(left: 50, right: 50, top: 30),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black, width: 0.1),
        borderRadius: BorderRadius.circular(5.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("COMMISSION + BONUS",
            style: TextStyle(color: Colors.orange[400], fontSize: 18),),
          FutureBuilder(
              future: initWallet(),
              builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
                if(snapshot.hasData){
                  return Text("RM ${widget.text["commission_bonus"].toString()}",
                    style: const TextStyle(fontSize: 30, color: Colors.black),);
                }else{
                  return const Text("Loading");
                }
              }
          ),
        ],
      ),
    );
  }

  //merit
  Widget _merit() {
    return FutureBuilder(
      future: initWallet(),
      builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
        return Container(
          width: double.maxFinite,
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.only(left: 50, right: 50, top: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black, width: 0.1),
            borderRadius: BorderRadius.circular(5.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3),
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if(snapshot.hasData)...[
                Text("MERIT",
                  style: TextStyle(color: Colors.orange[400], fontSize: 18),),
                Text(
                  "RM ${widget.text["withdrawable_merit"].toString()}",
                  style: const TextStyle(fontSize: 30, color: Colors.black),
                ),
              ]else...[
                const Text("Loading"),
              ]
            ],
          ),
        );
      }
    );
  }

  //withdrawal button/function
  Widget _requestbutton(context) {
    String? user_id = driver.id.toString();
    final Map<String, String> body = {
      'uid': user_id,
      'withdraw_mert': display_merit_value
    };
    final String unencodedPath = "/easymovenpick.com/api/request_withdraw.php";
    return Padding (
        padding: EdgeInsets.only(top:10,left:175),
        child: GFButton(
        color: Colors.orange,
        onPressed: () {
          makePostRequestWithdrawal(url, unencodedPath, body);
          if (withdraw == true) {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Withdrawal()));
          }
          withdraw = false;
        },
        child: Text("Request Withdrawal"),
        shape: GFButtonShape.pills,
      ));
  }
}