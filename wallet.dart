import 'package:driver_integrated/merit.dart';
import 'package:driver_integrated/unable_withdraw.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:getwidget/getwidget.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:driver_integrated/driver.dart';
import 'package:driver_integrated/withdrawal.dart';
import 'package:driver_integrated/my_api_service.dart';

final String url = "awcgroup.com.my";
final Map<String, String> header = {
  'Content-Type': 'application/json; charset=UTF-8'
};
bool withdraw = false;

void makePostRequestWithdrawal(
    String url, String unencodedPath, Map<String, String> requestBody) async {
  final response =
      await http.post(Uri.http(url, unencodedPath), body: requestBody);
  // print(response.statusCode);
  // print(response.body);
  final data = json.decode(response.body);
  print(data);
  String msg = (data["message"]);
  if (msg == "Request sent successfully.") {
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
          title: Text(
            "Wallet",
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color.fromARGB(255, 255, 168, 0),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _commission(),
            _requestcomsbutton(context),
            _merit(),
            _requestmeritbutton(context),
            // _commissionlist(),
          ],
        ));
  }

  //apiservice for wallet
  Future<Map<String, dynamic>> initWallet() async {
    final meritData =
        await MyApiService.getCommissionStatement(driver.id.toString());
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
          Text(
            "COMMISSION + BONUS",
            style: TextStyle(color: Colors.orange[400], fontSize: 18),
          ),
          FutureBuilder(
              future: initWallet(),
              builder: (BuildContext context,
                  AsyncSnapshot<Map<String, dynamic>> snapshot) {
                if (snapshot.hasData) {
                  return Text(
                    "RM ${widget.text["commission_bonus"].toString()}",
                    style: const TextStyle(fontSize: 30, color: Colors.black),
                  );
                } else {
                  return const Text("Loading");
                }
              }),
        ],
      ),
    );
  }

  //merit
  Widget _merit() {
    return FutureBuilder(
        future: initWallet(),
        builder: (BuildContext context,
            AsyncSnapshot<Map<String, dynamic>> snapshot) {
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
                if (snapshot.hasData &&
                    widget.text["withdrawable_merit"] != null) ...[
                  Text(
                    "MERIT",
                    style: TextStyle(color: Colors.orange[400], fontSize: 18),
                  ),
                  Text(
                    "RM ${widget.text["withdrawable_merit"].toString()}",
                    style: const TextStyle(fontSize: 30, color: Colors.black),
                  ),
                ] else ...[
                  Text(
                    "MERIT",
                    style: TextStyle(color: Colors.orange[400], fontSize: 18),
                  ),
                  const Text(
                    "RM 0",
                    style: TextStyle(fontSize: 30, color: Colors.black),
                  ),
                ]
              ],
            ),
          );
        });
  }

  //withdrawal button/function
  /*Widget _requestbutton(context) {
    String? user_id = driver.id.toString();
    final Map<String, String> body = {
      'uid': user_id,
      'withdraw_merit': display_merit_value
    };
    final String unencodedPath = "/easymovenpick.com/api/request_withdraw.php";
    return Padding(
        padding: EdgeInsets.only(top: 10, left: 175),
        child: GFButton(
          color: Colors.orange,
          onPressed: () {
            makePostRequestWithdrawal(url, unencodedPath, body);
            if (withdraw == true) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Withdrawal()));
            }
            withdraw = false;
          },
          child: Text("Request Withdrawal"),
          shape: GFButtonShape.pills,
        ));
  }*/

  //withdrawal button/function
  Widget _requestmeritbutton(context) {
    String? user_id = driver.id.toString();
    final Map<String, String> body = {
      'uid': user_id,
      'withdraw_merit': display_merit_value
    };
    final String unencodedPath = "/easymovenpick.com/api/request_withdraw.php";
    return Padding(
      padding: EdgeInsets.only(top: 10, left: 175),
      child: FutureBuilder(
          future: initWallet(),
          builder: (BuildContext context,
              AsyncSnapshot<Map<String, dynamic>> snapshot) {
            return GFButton(
              color: Colors.orange,
              onPressed: () {
                if (snapshot.hasData &&
                    widget.text["withdrawable_merit"] != null) {
                  if (int.parse(widget.text["withdrawable_merit"]) > 10) {
                    makePostRequestWithdrawal(url, unencodedPath, body);
                    display_merit_value =
                        (double.parse(widget.text["withdrawable_merit"]) - 10)
                            .toString();
                    if (withdraw == true) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Withdrawal()));
                    }
                    withdraw = false;
                  } else {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UnableWithdrawal()));
                  }
                } else {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text("Sorry,"),
                      content:
                          const Text("You don't have merit in your wallet!"),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(ctx).pop();
                          },
                          child: Container(
                            color: Colors.orange,
                            padding: const EdgeInsets.all(14),
                            child: const Text("okay",
                                style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
              child: Text("Request Withdrawal"),
              shape: GFButtonShape.pills,
            );
          }),
    );
  }

  //withdrawal button/function
  Widget _requestcomsbutton(context) {
    String? user_id = driver.id.toString();
    final Map<String, String> body = {
      'uid': user_id,
      'withdraw_merit': display_merit_value
    };
    final String unencodedPath = "/easymovenpick.com/api/request_withdraw.php";
    return Padding(
      padding: EdgeInsets.only(top: 10, left: 175),
      child: FutureBuilder(
          future: initWallet(),
          builder: (BuildContext context,
              AsyncSnapshot<Map<String, dynamic>> snapshot) {
            return GFButton(
              color: Colors.orange,
              onPressed: () {
                if (snapshot.hasData) {
                  if (double.parse(widget.text["commission_bonus"]) > 5.00) {
                    makePostRequestWithdrawal(url, unencodedPath, body);
                    display_merit_value =
                        (double.parse(widget.text["commission_bonus"]) - 5.00)
                            .floor()
                            .toString();
                    if (withdraw == true) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Withdrawal()));
                    }
                    withdraw = false;
                  } else {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UnableWithdrawal()));
                  }
                }
              },
              child: Text("Request Withdrawal"),
              shape: GFButtonShape.pills,
            );
          }),
    );
  }
}
