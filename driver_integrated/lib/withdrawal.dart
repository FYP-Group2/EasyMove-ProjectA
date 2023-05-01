// import 'package:flutter/material.dart';
// import 'package:getwidget/getwidget.dart';
// import 'package:driver_integrated/NavBar.dart';

// class Withdrawal extends StatelessWidget {
//   const Withdrawal({Key? key, required this.withdrawableAmount, required this.withdrawType}) : super(key: key);

//   final double withdrawableAmount;
//   final String withdrawType;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           iconTheme:  const IconThemeData(
//             color: Colors.black, //change your color here
//             size: 35,
//           ),
//           elevation: 0,
//           bottom: PreferredSize(
//             preferredSize: const Size.fromHeight(16.0),
//             child: Container(
//               color: Colors.orangeAccent,
//               height: 4.0,
//             ),
//           ),
//           centerTitle: true,
//           title: const Padding(
//             padding: EdgeInsets.only(top: 10.0),
//             child: Text(
//               "Withdrawal",
//               style: TextStyle(color: Colors.black, fontSize: 25.0),

//             ),
//           ),
//           backgroundColor: Colors.white,
//         ),
//         body: Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Container(
//                   margin: EdgeInsets.only(left: 50, right: 50, bottom: 15),
//                   padding: EdgeInsets.all(20.0),
//                   decoration: BoxDecoration(
//                       border: Border.all(color: Colors.orange, width: 3),
//                       borderRadius: BorderRadius.circular(25.0)),
//                   child: withdrawType == "merit"
//                       ? Text(
//                           "Your request for withdrawal of amount RM $withdrawableAmount has been sent. Please allow a maximum of 3 working days "
//                               "for your request to be processed.",
//                           style: const TextStyle(fontSize: 18),
//                         )
//                       : Text(
//                           "Your request for withdrawal of amount RM $withdrawableAmount (your wallet must have RM 30.00 left after withdrawal) "
//                               "has been sent. Please allow a maximum of 3 working days for your request to be processed.",
//                           style: const TextStyle(fontSize: 18),
//                         )
//                 ,),
//                 GFButton(
//                   color: Colors.orange,
//                   onPressed: () {
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => NavBar(
//                               currentPage: PageItem.Account,
//                             )));
//                   },
//                   text: "Done",
//                   shape: GFButtonShape.pills,
//                 ),
//               ],
//             )));
//   }
// }

import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:driver_integrated/NavBar.dart';
import 'package:driver_integrated/screen_size.dart';

class Withdrawal extends StatelessWidget {
  const Withdrawal({Key? key, required this.withdrawableAmount, required this.withdrawType}) : super(key: key);

  final double withdrawableAmount;
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
        body: Stack(
          children: [
            Container(
              width: ScreenSize.screenWidth(context),
              height: ScreenSize.screenHeight(context),
              decoration: BoxDecoration(
                  color: Colors.white
              ),
              child: Container(
                margin: EdgeInsets.symmetric(
                  horizontal: ScreenSize.screenWidth(context) * 0.08,
                  vertical: ScreenSize.screenHeight(context) * 0.02
                ),
                padding: EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.orange, width: 3),
                    borderRadius: BorderRadius.circular(25.0)
                ),
                child: Column(
                    children: [
                      withdrawType == "merit"
                          ? Text(
                        "Your request for withdrawal of amount RM $withdrawableAmount has been sent. Please allow a maximum of 3 working days "
                            "for your request to be processed.",
                        style: const TextStyle(fontSize: 18),
                      )
                          : Text(
                        "Your request for withdrawal of amount RM $withdrawableAmount (your wallet must have RM 30.00 left after withdrawal) "
                            "has been sent. Please allow a maximum of 3 working days for your request to be processed.",
                        style: const TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: ScreenSize.screenHeight(context) * 0.06),
                      GFButton(
                        color: Colors.orange,
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => NavBar(
                                    currentPage: PageItem.Account,
                                  )
                              )
                          );
                        },
                        text: "Done",
                        shape: GFButtonShape.pills,
                      )
                    ],
                )
              )
            )
          ],
        )
    );
  }
}