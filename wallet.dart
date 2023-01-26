import 'package:driver_integrated/merit.dart';
import 'package:driver_integrated/unable_withdraw.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:driver_integrated/driver.dart';
import 'package:driver_integrated/withdrawal.dart';
import 'package:driver_integrated/my_api_service.dart';

bool withdraw = false;

Future<void> makePostRequestWithdrawal(Map<String, String> body) async {
  String msg = await MyApiService.requestWithdraw(body);
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
          title: const Text(
            "Wallet",
            style: TextStyle(color: Colors.white),
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
    final meritData = await MyApiService.getCommissionStatement(driver.id.toString());
    widget.text = meritData;
    return meritData;
  }

  //commission + bonus
  Widget _commission() {
    return Container(
      width: double.maxFinite,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(left: 50, right: 50, top: 30),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black, width: 0.1),
        borderRadius: BorderRadius.circular(5.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
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
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.only(left: 50, right: 50, top: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black, width: 0.1),
              borderRadius: BorderRadius.circular(5.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (snapshot.hasData &&
                    widget.text["withdrew_merit"] != null) ...[
                  Text(
                    "MERIT",
                    style: TextStyle(color: Colors.orange[400], fontSize: 18),
                  ),
                  Text(
                    "RM ${widget.text["withdrew_merit"].toString()}",
                    style: const TextStyle(fontSize: 30, color: Colors.black),
                  ),
                ] else ...[
                  Text(
                    "MERIT",
                    style: TextStyle(color: Colors.orange[400], fontSize: 18),
                  ),
                  const Text(
                    "Loading",
                  ),
                ]
              ],
            ),
          );
        });
  }

  //withdrawal button/function
  Widget _requestmeritbutton(context) {
    String? user_id = driver.id.toString();
    final Map<String, String> body = {
      'uid': user_id,
      'withdraw_merit': display_merit_value
    };
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 175),
      child: FutureBuilder(
          future: initWallet(),
          builder: (BuildContext context,
              AsyncSnapshot<Map<String, dynamic>> snapshot) {
            return GFButton(
              color: Colors.orange,
              onPressed: () async {
                if (snapshot.hasData && widget.text["withdrew_merit"] != null) {
                  if(widget.text["withdrew_merit"] > 0) {
                    display_merit_value =
                        (widget.text["withdrew_merit"]).toString();
                    body['withdraw_merit'] = display_merit_value;
                    await makePostRequestWithdrawal(body).then((value) {
                      if (withdraw == true) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    Withdrawal(
                                      withdrawableAmount: double.parse(
                                          widget.text["withdrew_merit"]
                                              .toString()),
                                      withdrawType: "merit",
                                    )
                            )
                        );
                        withdraw = false;
                      }
                    });
                  }else{
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const UnableWithdrawal(withdrawType: "merit",)));
                  }
                } else {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text(
                        "Error!",
                        style: TextStyle(color: Colors.red),
                      ),
                      content:
                      const Text("There is a problem, unable to withdraw!"),
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
              shape: GFButtonShape.pills,
              child: const Text("Request Withdrawal"),
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
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 175),
      child: FutureBuilder(
          future: initWallet(),
          builder: (BuildContext context,
              AsyncSnapshot<Map<String, dynamic>> snapshot) {
            return GFButton(
              color: Colors.orange,
              onPressed: () async {
                if (snapshot.hasData) {
                  if (double.parse(widget.text["commission_bonus"].toString()) > 30.00) {
                    display_merit_value =
                        (double.parse(widget.text["commission_bonus"].toString()) - 30.00)
                            .floor()
                            .toString();
                    body['withdraw_merit'] = display_merit_value;
                    await makePostRequestWithdrawal(body).then((value) {
                      if (withdraw == true) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Withdrawal(
                                  withdrawableAmount: double.parse(widget.text["commission_bonus"].toString()) - 30.00,
                                  withdrawType: "commission",
                                )
                            )
                        );
                      }
                      withdraw = false;
                    });
                  } else {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const UnableWithdrawal(withdrawType: "commission",)));
                  }
                }
              },
              shape: GFButtonShape.pills,
              child: const Text("Request Withdrawal"),
            );
          }),
    );
  }
}