import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:driver_integrated/account.dart';
import 'package:driver_integrated/main.dart';

class UnableWithdrawal extends StatelessWidget {
  const UnableWithdrawal({Key? key}) : super(key: key);

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
              child: Text(
                "Unable to withdraw. Your wallet must have RM 5 balance!",
                style: TextStyle(fontSize: 18),
              ),
            ),
            GFButton(
              color: Colors.orange,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AccountPage(title: "Account")));
              },
              text: "Done",
              shape: GFButtonShape.pills,
            ),
          ],
        )));
  }
}
