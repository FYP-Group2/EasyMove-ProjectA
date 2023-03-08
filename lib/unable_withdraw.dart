import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:driver_integrated/NavBar.dart';

class UnableWithdrawal extends StatelessWidget {
  const UnableWithdrawal({Key? key, required this.withdrawType}) : super(key: key);

  final String withdrawType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(80.0),
          child: AppBar(
            title: Image.asset('assets/images/icon.png', height: 100),
            centerTitle: true,
            backgroundColor: Color(0xFFFFA600),
          ),
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