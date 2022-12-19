import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:driver_integrated/main.dart';

class Notice extends StatelessWidget {
  const Notice({Key? key}) : super(key: key);
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
      body: Center(
        child:Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("h"),
          GFButton(
            color: Colors.orange,
            onPressed: () {
              Navigator.popUntil(context,ModalRoute.withName(Navigator.defaultRouteName));
            },
            text: "Done",
            shape: GFButtonShape.pills,
          ),
        ],
      )
      )
    );
  }
}
