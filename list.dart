// import 'package:flutter/material.dart';
// import 'package:driver_integrated/order.dart';
// import 'package:driver_integrated/order_details.dart';
// import 'package:driver_integrated/my_api_service.dart';
// import 'package:driver_integrated/driver.dart';
// import 'package:driver_integrated/NavBar.dart';
//
// class MyList extends StatelessWidget {
//   final String child;
//   final int orderId;
//   Driver driver = Driver();
//
//   MyList({required this.child, required this.orderId});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.white),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.2),
//             spreadRadius: 2,
//             blurRadius: 2,
//             offset: const Offset(0, 3),
//           )
//         ],
//       ),
//       child: Dismissible(
//         onDismissed: (direction) {
//           if (direction == DismissDirection.startToEnd) {
//             Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                     builder: (context) => const Order_details(oid: 000406,)));
//           } else if (direction == DismissDirection.endToStart) {
//             myAlertBox(context);
//           }
//         },
//         key: UniqueKey(),
//         background: Container(
//           color: const Color.fromARGB(255, 208, 208, 208),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: const [
//               Icon(Icons.more),
//               Text(
//                 "More",
//                 style: TextStyle(color: Colors.white),
//               )
//             ],
//           ),
//         ),
//         secondaryBackground: Container(
//           color: const Color(0xFF7BC043),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: const [
//               Icon(Icons.arrow_left),
//               Text(
//                 "Accept",
//                 style: TextStyle(color: Colors.white),
//               )
//             ],
//           ),
//         ),
//         child: Container(
//           width: 500,
//           color: const Color.fromARGB(255, 246, 232, 206),
//           padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
//           child: Text(child, textAlign: TextAlign.start, style: const TextStyle(fontSize: 16),),
//         ),
//       ),
//     );
//   }
//
//   void myAlertBox(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           shape:
//             RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//           title: const Text("Are you sure to accept this order?"),
//           content: Container(
//             height: MediaQuery.of(context).size.height / 6,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 ElevatedButton(
//                   onPressed: () =>
//                     Navigator.of(context).pop(false),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.redAccent,
//                   ),
//                   child: const Text(
//                     "No",
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 20,
//                     ),
//                   ),
//                 ),
//                 ElevatedButton(
//                   onPressed: () {
//                     MyApiService.updateOrder(driver.id, orderId, "accept");
//                     Navigator.of(context).pop(true);
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFF7BC043),
//                   ),
//                   child: const Text(
//                     "Yes",
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 20,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       }
//     );
//   }
// }
