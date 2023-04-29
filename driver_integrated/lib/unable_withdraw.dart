import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:driver_integrated/NavBar.dart';

class UnableWithdrawal extends StatelessWidget {
  const UnableWithdrawal({Key? key, required this.withdrawType}) : super(key: key);

  final String withdrawType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme:  const IconThemeData(
            color: Colors.black, //change your color here
            size: 35,
          ),
          elevation: 0,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(16.0),
            child: Container(
              color: Colors.orangeAccent,
              height: 4.0,
            ),
          ),
          centerTitle: true,
          title: const Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: Text(
              "Withdrawal",
              style: TextStyle(color: Colors.black, fontSize: 25.0),

            ),
          ),
          backgroundColor: Colors.white,
        ),
        body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 50, right: 50, bottom: 15),
                  padding: EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.orange, width: 3),
                      borderRadius: BorderRadius.circular(25.0)),
                  child: withdrawType == "merit"
                      ? const Text(
                          "Unable to withdraw. Your merit has no balance!",
                          style: TextStyle(fontSize: 18),
                        )
                      : const Text(
                          "Unable to withdraw. Your wallet must have at least RM 30.00 balance!",
                          style: TextStyle(fontSize: 18),
                        )
                ),
                GFButton(
                  color: Colors.orange,
                  onPressed: () {
                    Navigator.pop(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NavBar(
                              currentPage: PageItem.Account,
                            )));
                  },
                  text: "Back",
                  shape: GFButtonShape.pills,
                ),
              ],
            )));
  }
}