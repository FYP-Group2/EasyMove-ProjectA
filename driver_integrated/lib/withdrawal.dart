import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:driver_integrated/NavBar.dart';

class Withdrawal extends StatelessWidget {
  const Withdrawal({Key? key, required this.withdrawableAmount, required this.withdrawType}) : super(key: key);

  final double withdrawableAmount;
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
                      ? Text(
                          "Your request for withdrawal of amount RM $withdrawableAmount has been sent. Please allow a maximum of 3 working days "
                              "for your request to be processed.",
                          style: const TextStyle(fontSize: 18),
                        )
                      : Text(
                          "Your request for withdrawal of amount RM $withdrawableAmount (your wallet must have RM 30.00 left after withdrawal) "
                              "has been sent. Please allow a maximum of 3 working days for your request to be processed.",
                          style: const TextStyle(fontSize: 18),
                        )
                ,),
                GFButton(
                  color: Colors.orange,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NavBar(
                              currentPage: PageItem.Account,
                            )));
                  },
                  text: "Done",
                  shape: GFButtonShape.pills,
                ),
              ],
            )));
  }
}