// import 'package:driver_integrated/order.dart';
// import 'package:flutter/material.dart';
// import 'package:driver_integrated/my_order.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:map_launcher/map_launcher.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:flutter_launch/flutter_launch.dart';

// class Order_details extends StatelessWidget {
//   const Order_details({super.key, required this.order});
//   final MyOrder order;

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Order Details Page',
//       debugShowCheckedModeBanner: false,
//       home: _RowOrder(order),
//     );
//   }
// }

// //open map
// class _RowOrder extends StatelessWidget {
//   final MyOrder order;

//   const _RowOrder(this.order);

//   openMapsList(context) async {
//     try {
//       final oCoords =
//       Coords(double.parse(order.oLat), double.parse(order.oLon));
//       final dCoords =
//       Coords(double.parse(order.dLat), double.parse(order.dLon));
//       final availableMaps = await MapLauncher.installedMaps;

//       showModalBottomSheet(
//         context: context,
//         builder: (BuildContext context) {
//           return SafeArea(
//             child: SingleChildScrollView(
//               child: Container(
//                 child: Wrap(
//                   children: <Widget>[
//                     for (var map in availableMaps)
//                       ListTile(
//                         // onTap: () => map.showMarker(
//                         //   coords: coords,
//                         //   title: title,
//                         // ),
//                         onTap: () => map.showDirections(
//                             origin: oCoords,
//                             destination: dCoords,
//                             originTitle: order.origin,
//                             destinationTitle: order.destination),
//                         title: Text(map.mapName),
//                         leading: SvgPicture.asset(
//                           map.icon,
//                           height: 30.0,
//                           width: 30.0,
//                         ),
//                       ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         },
//       );
//     } catch (e) {
//       print(e);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//             icon: Icon(
//               Icons.arrow_back,
//               color: Colors.black,
//             ),
//             onPressed: (() {
//               Navigator.push(context,
//                   MaterialPageRoute(builder: (context) => const OrderPage()));
//             })),
//         title: const Text(
//           'Order Details',
//           style: TextStyle(color: Colors.black),
//         ),
//         backgroundColor: Colors.white,
//         elevation: 0,
//       ),
//       body: SizedBox(
//         height: 1000,
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               Container(
//                 height: 35,
//                 margin: const EdgeInsets.only(top: 0, bottom: 0),
//                 child: Row(
//                   children: [
//                     Container(
//                       padding: const EdgeInsets.only(left: 10, right: 10),
//                     ),
//                     Row(
//                       children: [
//                         Container(
//                           padding: const EdgeInsets.fromLTRB(0, 5, 5, 0),
//                           child: const Text('Order ID:',
//                               overflow: TextOverflow.ellipsis,
//                               maxLines: 2,
//                               style: TextStyle(
//                                   color: Colors.orange,
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.bold)),
//                         ),
//                       ],
//                     ),
//                     Row(
//                       children: [
//                         Container(
//                           padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
//                           child: Text(order.id.toString(),
//                               overflow: TextOverflow.ellipsis,
//                               maxLines: 1,
//                               style: const TextStyle(
//                                 color: Colors.black,
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 18,
//                               )),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               Container(
//                 height: 70,
//                 //color: const Color.fromARGB(255, 246, 232, 206),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(20),
//                   color: Colors.white,
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.grey.shade200,
//                       spreadRadius: 2,
//                       blurRadius: 2,
//                       offset: const Offset(0, 3),
//                     )
//                   ],
//                 ),
//                 margin: const EdgeInsets.all(10),
//                 child: Row(
//                   children: [
//                     const Padding(
//                       padding: EdgeInsets.only(left: 20, right: 0),
//                     ),
//                     const Icon(
//                       Icons.calendar_month_rounded,
//                       color: Colors.orange,
//                       size: 35.0,
//                     ),
//                     Expanded(
//                       child: Column(
//                         children: [
//                           const FittedBox(
//                             child: Padding(
//                               padding: EdgeInsets.only(top: 10, bottom: 5),
//                               child: Text(
//                                 'Date & Time:',
//                                 overflow: TextOverflow.ellipsis,
//                                 maxLines: 1,
//                                 style: TextStyle(
//                                     color: Colors.black,
//                                     fontSize: 20,
//                                     fontWeight: FontWeight.bold),
//                               ),
//                             ),
//                           ),
//                           Expanded(
//                             child: Padding(
//                               padding: const EdgeInsets.only(top: 0, bottom: 5),
//                               child: Text(
//                                 order.createdTime,
//                                 overflow: TextOverflow.ellipsis,
//                                 maxLines: 1,
//                                 style: const TextStyle(
//                                   color: Colors.black,
//                                   fontSize: 20,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//               Container(
//                 height: 70,
//                 //color: const Color.fromARGB(255, 246, 232, 206),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(20),
//                   color: Colors.white,
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.grey.shade200,
//                       spreadRadius: 2,
//                       blurRadius: 2,
//                       offset: const Offset(0, 3),
//                     )
//                   ],
//                 ),
//                 margin: const EdgeInsets.all(10),
//                 child: Row(
//                   children: [
//                     const Padding(padding: EdgeInsets.only(left: 20)),
//                     const Icon(
//                       Icons.store_mall_directory_rounded,
//                       color: Colors.orange,
//                       size: 35.0,
//                     ),
//                     Expanded(
//                       child: Column(
//                         children: [
//                           const FittedBox(
//                             child: Padding(
//                               padding: EdgeInsets.only(top: 10, bottom: 5),
//                               child: Text(
//                                 'Merchant:',
//                                 overflow: TextOverflow.ellipsis,
//                                 maxLines: 1,
//                                 style: TextStyle(
//                                     color: Colors.black,
//                                     fontSize: 20,
//                                     fontWeight: FontWeight.bold),
//                               ),
//                             ),
//                           ),
//                           Expanded(
//                             child: Padding(
//                               padding: const EdgeInsets.only(top: 0, bottom: 5),
//                               child: Text(
//                                 order.branchName,
//                                 overflow: TextOverflow.ellipsis,
//                                 maxLines: 1,
//                                 style: const TextStyle(
//                                   color: Colors.black,
//                                   fontSize: 20,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//               Container(
//                 height: 70,
//                 //color: const Color.fromARGB(255, 246, 232, 206),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(20),
//                   color: Colors.white,
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.grey.shade200,
//                       spreadRadius: 2,
//                       blurRadius: 2,
//                       offset: const Offset(0, 3),
//                     )
//                   ],
//                 ),
//                 margin: const EdgeInsets.all(10),
//                 child: Row(
//                   children: [
//                     const Padding(padding: EdgeInsets.only(left: 20)),
//                     const Icon(
//                       Icons.person_rounded,
//                       color: Colors.orange,
//                       size: 35.0,
//                     ),
//                     Expanded(
//                       child: Column(
//                         children: [
//                           const FittedBox(
//                             child: Padding(
//                               padding: EdgeInsets.only(top: 10, bottom: 5),
//                               child: Text("Customer's name:",
//                                   overflow: TextOverflow.ellipsis,
//                                   maxLines: 1,
//                                   style: TextStyle(
//                                       color: Colors.black,
//                                       fontSize: 20,
//                                       fontWeight: FontWeight.bold)),
//                             ),
//                           ),
//                           Expanded(
//                             child: Padding(
//                               padding: const EdgeInsets.only(top: 0, bottom: 5),
//                               child: Text(
//                                 order.customerName,
//                                 overflow: TextOverflow.ellipsis,
//                                 maxLines: 1,
//                                 style: const TextStyle(
//                                   color: Colors.black,
//                                   fontSize: 20,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Container(
//                 height: 70,
//                 //color: const Color.fromARGB(255, 246, 232, 206),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(20),
//                   color: Colors.white,
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.grey.shade200,
//                       spreadRadius: 2,
//                       blurRadius: 2,
//                       offset: const Offset(0, 3),
//                     )
//                   ],
//                 ),
//                 margin: const EdgeInsets.all(10),
//                 child: Row(
//                   children: [
//                     const Padding(padding: EdgeInsets.only(left: 20)),
//                     const Icon(
//                       Icons.phone_enabled_rounded,
//                       color: Colors.orange,
//                       size: 35.0,
//                     ),
//                     Expanded(
//                       child: Column(
//                         children: [
//                           const FittedBox(
//                             child: Padding(
//                               padding: EdgeInsets.only(top: 10, bottom: 5),
//                               child: Text(
//                                 "Phone number :",
//                                 overflow: TextOverflow.ellipsis,
//                                 maxLines: 1,
//                                 style: TextStyle(
//                                     color: Colors.black,
//                                     fontSize: 20,
//                                     fontWeight: FontWeight.bold),
//                               ),
//                             ),
//                           ),
//                           Expanded(
//                             child: Padding(
//                               padding: const EdgeInsets.only(top: 0, bottom: 5),
//                               child: GestureDetector(
//                                 onTap: () async {
//                                   await FlutterLaunch.launchWhatsapp(phone: order.phone, message: "");
//                                 },
//                                 child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       const FaIcon(
//                                         FontAwesomeIcons.whatsapp,
//                                         color: Colors.green,
//                                       ),
//                                       Padding(
//                                         padding: const EdgeInsets.only(left: 10),
//                                         child: Text(
//                                           order.phone,
//                                           overflow: TextOverflow.ellipsis,
//                                           maxLines: 1,
//                                           style: const TextStyle(
//                                             color: Colors.green,
//                                             fontSize: 20,
//                                           ),
//                                         ),
//                                       ),
//                                     ]
//                                 ),
//                               ),

//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Container(
//                 height: 70,
//                 //color: const Color.fromARGB(255, 246, 232, 206),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(20),
//                   color: Colors.white,
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.grey.shade200,
//                       spreadRadius: 2,
//                       blurRadius: 2,
//                       offset: const Offset(0, 3),
//                     )
//                   ],
//                 ),
//                 margin: const EdgeInsets.all(10),
//                 child: Row(
//                   children: [
//                     const Padding(
//                       padding: EdgeInsets.only(left: 20, right: 0),
//                     ),
//                     const Icon(
//                       Icons.my_location,
//                       color: Colors.orange,
//                       size: 35.0,
//                     ),
//                     Expanded(
//                       child: Column(
//                         children: [
//                           const FittedBox(
//                             child: Padding(
//                               padding: EdgeInsets.only(top: 10, bottom: 5),
//                               child: Text(
//                                 "Zone :",
//                                 overflow: TextOverflow.ellipsis,
//                                 maxLines: 1,
//                                 style: TextStyle(
//                                     color: Colors.black,
//                                     fontSize: 20,
//                                     fontWeight: FontWeight.bold),
//                               ),
//                             ),
//                           ),
//                           Expanded(
//                             child: Padding(
//                               padding: const EdgeInsets.only(top: 0, bottom: 5),
//                               child: Text(
//                                 order.zone,
//                                 overflow: TextOverflow.ellipsis,
//                                 maxLines: 2,
//                                 style: const TextStyle(
//                                   color: Colors.black,
//                                   fontSize: 20,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Container(
//                 //height: 70,
//                 //color: const Color.fromARGB(255, 246, 232, 206),
//                 decoration: BoxDecoration(
//                   borderRadius: const BorderRadius.only(
//                       topRight: Radius.circular(20),
//                       topLeft: Radius.circular(20)),
//                   color: Colors.white,
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.grey.shade200,
//                       spreadRadius: 2,
//                       blurRadius: 2,
//                       offset: const Offset(3, 0),
//                     )
//                   ],
//                 ),
//                 margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
//                 child: Row(
//                   children: [
//                     const Padding(padding: EdgeInsets.only(left: 20)),
//                     const Icon(
//                       Icons.location_on_rounded,
//                       color: Colors.orange,
//                       size: 35.0,
//                     ),
//                     Expanded(
//                       child: Column(
//                         children: [
//                           const FittedBox(
//                             child: Padding(
//                               padding: EdgeInsets.only(top: 10, bottom: 5),
//                               child: Center(
//                                 child: Text(
//                                   'Pick Up Location:',
//                                   overflow: TextOverflow.ellipsis,
//                                   maxLines: 1,
//                                   style: TextStyle(
//                                       color: Colors.black,
//                                       fontSize: 20,
//                                       fontWeight: FontWeight.bold),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           Row(
//                             children: [
//                               Expanded(
//                                 child: Text(
//                                   order.origin,
//                                   overflow: TextOverflow.ellipsis,
//                                   maxLines: 10,
//                                   softWrap: false,
//                                   style: const TextStyle(
//                                     color: Colors.black,
//                                     fontSize: 20,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Container(
//                 //height: 70,
//                 decoration: BoxDecoration(
//                   borderRadius: const BorderRadius.only(
//                       bottomLeft: Radius.circular(20),
//                       bottomRight: Radius.circular(20)),
//                   color: Colors.white,
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.grey.shade200,
//                       spreadRadius: 2,
//                       blurRadius: 2,
//                       offset: const Offset(3, 3),
//                     )
//                   ],
//                 ),
//                 margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
//                 child: Row(
//                   children: [
//                     const Padding(padding: EdgeInsets.only(left: 20)),
//                     const Icon(
//                       Icons.location_on_rounded,
//                       color: Colors.orange,
//                       size: 35.0,
//                     ),
//                     Expanded(
//                       child: Column(
//                         children: [
//                           const FittedBox(
//                             child: Padding(
//                               padding: EdgeInsets.only(top: 10, bottom: 5),
//                               child: Text(
//                                 'Drop off Location:',
//                                 overflow: TextOverflow.ellipsis,
//                                 maxLines: 1,
//                                 style: TextStyle(
//                                     color: Colors.black,
//                                     fontSize: 20,
//                                     fontWeight: FontWeight.bold),
//                               ),
//                             ),
//                           ),
//                           Row(
//                             children: [
//                               Expanded(
//                                 child: Text(
//                                   order.destination,
//                                   overflow: TextOverflow.ellipsis,
//                                   maxLines: 10,
//                                   softWrap: false,
//                                   style: const TextStyle(
//                                     color: Colors.black,
//                                     fontSize: 20,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Container(
//                 height: 70,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(20),
//                   color: Colors.white,
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.grey.shade200,
//                       spreadRadius: 2,
//                       blurRadius: 2,
//                       offset: const Offset(0, 3),
//                     )
//                   ],
//                 ),
//                 margin: const EdgeInsets.all(10),
//                 child: Row(
//                   children: [
//                     const Padding(padding: EdgeInsets.only(left: 20)),
//                     const Icon(
//                       Icons.route_rounded,
//                       color: Colors.orange,
//                       size: 35.0,
//                     ),
//                     Expanded(
//                       child: Column(
//                         children: [
//                           const FittedBox(
//                             child: Padding(
//                               padding: EdgeInsets.only(top: 10, bottom: 5),
//                               child: Text('Trips Distance: ',
//                                   overflow: TextOverflow.ellipsis,
//                                   maxLines: 1,
//                                   style: TextStyle(
//                                       color: Colors.black,
//                                       fontSize: 20,
//                                       fontWeight: FontWeight.bold)),
//                             ),
//                           ),
//                           Expanded(
//                             child: Padding(
//                               padding: const EdgeInsets.only(top: 0, bottom: 5),
//                               child: Text(
//                                 "${order.distance.toString()} KM",
//                                 overflow: TextOverflow.ellipsis,
//                                 maxLines: 1,
//                                 style: const TextStyle(
//                                   color: Colors.black,
//                                   fontSize: 20,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Container(
//                 height: 70,
//                 //color: const Color.fromARGB(255, 246, 232, 206),
//                 decoration: BoxDecoration(
//                   borderRadius: const BorderRadius.only(
//                       topRight: Radius.circular(20),
//                       topLeft: Radius.circular(20)),
//                   color: Colors.white,
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.grey.shade200,
//                       spreadRadius: 2,
//                       blurRadius: 2,
//                       offset: const Offset(3, 0),
//                     )
//                   ],
//                 ),
//                 margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
//                 child: Row(
//                   children: [
//                     const Padding(padding: EdgeInsets.only(left: 20)),
//                     const Icon(
//                       Icons.access_time_filled_rounded,
//                       color: Colors.orange,
//                       size: 35.0,
//                     ),
//                     Expanded(
//                       child: Column(
//                         children: [
//                           const FittedBox(
//                             child: Padding(
//                               padding: EdgeInsets.only(top: 10, bottom: 5),
//                               child: Text(
//                                 'Pick Up Time:',
//                                 overflow: TextOverflow.ellipsis,
//                                 maxLines: 1,
//                                 style: TextStyle(
//                                     color: Colors.black,
//                                     fontSize: 20,
//                                     fontWeight: FontWeight.bold),
//                               ),
//                             ),
//                           ),
//                           Expanded(
//                             child: Padding(
//                               padding: const EdgeInsets.only(top: 0, bottom: 5),
//                               child: Text(
//                                 order.collectTime,
//                                 overflow: TextOverflow.ellipsis,
//                                 maxLines: 1,
//                                 style: const TextStyle(
//                                   color: Colors.black,
//                                   fontSize: 20,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Container(
//                 height: 70,
//                 decoration: BoxDecoration(
//                   borderRadius: const BorderRadius.only(
//                       bottomLeft: Radius.circular(20),
//                       bottomRight: Radius.circular(20)),
//                   color: Colors.white,
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.grey.shade200,
//                       spreadRadius: 2,
//                       blurRadius: 2,
//                       offset: const Offset(3, 3),
//                     )
//                   ],
//                 ),
//                 margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
//                 child: Row(
//                   children: [
//                     const Padding(padding: EdgeInsets.only(left: 20)),
//                     const Icon(
//                       Icons.access_time_filled_rounded,
//                       color: Colors.orange,
//                       size: 35.0,
//                     ),
//                     Expanded(
//                       child: Column(
//                         children: [
//                           const FittedBox(
//                             child: Padding(
//                               padding: EdgeInsets.only(top: 10, bottom: 5),
//                               child: Text(
//                                 'Delivery Time:',
//                                 overflow: TextOverflow.ellipsis,
//                                 maxLines: 1,
//                                 style: TextStyle(
//                                     color: Colors.black,
//                                     fontSize: 20,
//                                     fontWeight: FontWeight.bold),
//                               ),
//                             ),
//                           ),
//                           Expanded(
//                             child: Padding(
//                               padding: const EdgeInsets.only(top: 0, bottom: 5),
//                               child: Text(
//                                 order.deliverTime,
//                                 overflow: TextOverflow.ellipsis,
//                                 maxLines: 1,
//                                 style: const TextStyle(
//                                   color: Colors.black,
//                                   fontSize: 20,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Container(
//                 height: 70,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(20),
//                   color: Colors.white,
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.grey.shade200,
//                       spreadRadius: 2,
//                       blurRadius: 2,
//                       offset: const Offset(0, 3),
//                     )
//                   ],
//                 ),
//                 margin: const EdgeInsets.all(10),
//                 child: Row(
//                   children: [
//                     const Padding(padding: EdgeInsets.only(left: 20)),
//                     const Icon(
//                       Icons.time_to_leave_rounded,
//                       color: Colors.orange,
//                       size: 35.0,
//                     ),
//                     Expanded(
//                       child: Column(
//                         children: [
//                           const FittedBox(
//                             child: Padding(
//                               padding: EdgeInsets.only(top: 10, bottom: 5),
//                               child: Text('Vehicle Type: ',
//                                   overflow: TextOverflow.ellipsis,
//                                   maxLines: 1,
//                                   style: TextStyle(
//                                       color: Colors.black,
//                                       fontSize: 20,
//                                       fontWeight: FontWeight.bold)),
//                             ),
//                           ),
//                           Expanded(
//                             child: Padding(
//                               padding: const EdgeInsets.only(top: 0, bottom: 5),
//                               child: Text(
//                                 "${order.vehicleType}",
//                                 overflow: TextOverflow.ellipsis,
//                                 maxLines: 1,
//                                 style: const TextStyle(
//                                   color: Colors.black,
//                                   fontSize: 20,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Container(
//                 height: 95,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(20),
//                   color: Colors.white,
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.grey.shade200,
//                       spreadRadius: 2,
//                       blurRadius: 2,
//                       offset: const Offset(0, 3),
//                     )
//                   ],
//                 ),
//                 margin: const EdgeInsets.all(10),
//                 child: Row(
//                   children: [
//                     const Padding(padding: EdgeInsets.only(left: 20)),
//                     const Icon(
//                       Icons.edit_note_rounded,
//                       color: Colors.orange,
//                       size: 35.0,
//                     ),
//                     Expanded(
//                       child: Column(
//                         children: [
//                           const FittedBox(
//                             child: Padding(
//                               padding: EdgeInsets.only(top: 10, bottom: 5),
//                               child: Text('Message: ',
//                                   overflow: TextOverflow.ellipsis,
//                                   maxLines: 1,
//                                   style: TextStyle(
//                                       color: Colors.black,
//                                       fontSize: 20,
//                                       fontWeight: FontWeight.bold)),
//                             ),
//                           ),
//                           Expanded(
//                             child: Padding(
//                               padding: const EdgeInsets.only(top: 0, bottom: 5),
//                               child: Text(
//                                 "${order.message}",
//                                 overflow: TextOverflow.ellipsis,
//                                 maxLines: 2,
//                                 style: const TextStyle(
//                                   color: Colors.black,
//                                   fontSize: 20,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Center(
//                 child: Container(
//                   margin: const EdgeInsets.only(top: 30, bottom: 30),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(20),
//                     color: Colors.orange,
//                   ),
//                   child: Builder(
//                     builder: (context) {
//                       return MaterialButton(
//                         onPressed: () => openMapsList(context),
//                         child: const Text('Open Maps',
//                             style: TextStyle(
//                               color: Colors.white,
//                             )
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:driver_integrated/order.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:driver_integrated/my_order.dart';
import 'package:driver_integrated/screen_size.dart';
import 'package:flutter_launch/flutter_launch.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Order_details extends StatelessWidget {
  const Order_details({super.key, required this.order});
  final MyOrder order;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Order Details Page',
      debugShowCheckedModeBanner: false,
      home: _RowOrder(order),
    );
  }
}

//open map
class _RowOrder extends StatelessWidget {
  final MyOrder order;

  const _RowOrder(this.order);

  openMapsList(context) async {
    try {
      final oCoords =
      Coords(double.parse(order.oLat), double.parse(order.oLon));
      final dCoords =
      Coords(double.parse(order.dLat), double.parse(order.dLon));
      final availableMaps = await MapLauncher.installedMaps;

      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Container(
                child: Wrap(
                  children: <Widget>[
                    for (var map in availableMaps)
                      ListTile(
                        onTap: () => map.showDirections(
                            origin: oCoords,
                            destination: dCoords,
                            originTitle: order.origin,
                            destinationTitle: order.destination),
                        title: Text(map.mapName),
                        leading: SvgPicture.asset(
                          map.icon,
                          height: 30.0,
                          width: 30.0,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    } catch (e) {print(e);}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: (() {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const OrderPage()));
            })),
        title: const Text(
          'Order Details',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Container(
            width: ScreenSize.screenWidth(context),
            height: ScreenSize.screenHeight(context),
            decoration: BoxDecoration(
                color: Colors.white
            ),
            child: SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.symmetric(
                    horizontal: ScreenSize.screenWidth(context) * 0.05,
                    vertical: ScreenSize.screenHeight(context) * 0.02
                ),
                child: Column(
                  children: [
                    Container(
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: ScreenSize.screenWidth(context) * 0.6,
                              child: RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                    fontSize: 18.0,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: 'Order ID: ',
                                      style: TextStyle(
                                          color: Colors.orange,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                    TextSpan(
                                      text: order.id.toString(),
                                      style: TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ]
                      ),
                    ),
                    SizedBox(height: ScreenSize.screenHeight(context) * 0.02),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade200,
                            spreadRadius: 2,
                            blurRadius: 2,
                            offset: const Offset(0, 3),
                          )
                        ],
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(20.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.calendar_month_rounded,
                                  color: Colors.orange,
                                  size: 35.0,
                                ),
                                SizedBox(width: ScreenSize.screenWidth(context) * 0.04),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: ScreenSize.screenWidth(context) * 0.6,
                                      child: Text(
                                        'Date & Time :',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: ScreenSize.screenWidth(context) * 0.6,
                                      child: Text(
                                        order.createdTime,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                        ),
                                      ),
                                    )
                                  ]
                                )
                              ],
                            )
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: ScreenSize.screenHeight(context) * 0.02),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade200,
                            spreadRadius: 2,
                            blurRadius: 2,
                            offset: const Offset(0, 3),
                          )
                        ],
                      ),
                      child: Column(
                        children: [
                          Container(
                              padding: EdgeInsets.all(20.0),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.store_mall_directory_rounded,
                                    color: Colors.orange,
                                    size: 35.0,
                                  ),
                                  SizedBox(width: ScreenSize.screenWidth(context) * 0.04),
                                  Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: ScreenSize.screenWidth(context) * 0.6,
                                          child: Text(
                                            'Merchant :',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: ScreenSize.screenWidth(context) * 0.6,
                                          child: Text(
                                            order.branchName,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18,
                                            ),
                                          ),
                                        )
                                      ]
                                  )
                                ],
                              )
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: ScreenSize.screenHeight(context) * 0.02),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade200,
                            spreadRadius: 2,
                            blurRadius: 2,
                            offset: const Offset(0, 3),
                          )
                        ],
                      ),
                      child: Column(
                        children: [
                          Container(
                              padding: EdgeInsets.all(20.0),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.person_rounded,
                                    color: Colors.orange,
                                    size: 35.0,
                                  ),
                                  SizedBox(width: ScreenSize.screenWidth(context) * 0.04),
                                  Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: ScreenSize.screenWidth(context) * 0.6,
                                          child: Text(
                                            "Customer's name :",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: ScreenSize.screenWidth(context) * 0.6,
                                          child: Text(
                                            order.customerName,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18,
                                            ),
                                          ),
                                        )
                                      ]
                                  )
                                ],
                              )
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: ScreenSize.screenHeight(context) * 0.02),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade200,
                            spreadRadius: 2,
                            blurRadius: 2,
                            offset: const Offset(0, 3),
                          )
                        ],
                      ),
                      child: Column(
                        children: [
                          Container(
                              padding: EdgeInsets.all(20.0),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.store_mall_directory_rounded,
                                    color: Colors.orange,
                                    size: 35.0,
                                  ),
                                  SizedBox(width: ScreenSize.screenWidth(context) * 0.04),
                                  Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: ScreenSize.screenWidth(context) * 0.6,
                                          child: Text(
                                            'Phone number :',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: ScreenSize.screenWidth(context) * 0.6,
                                          child: GestureDetector(
                                            onTap: () async {
                                              await FlutterLaunch.launchWhatsapp(phone: order.phone, message: "");
                                            },
                                            child: Row(
                                              children: [
                                                FaIcon(
                                                  FontAwesomeIcons.whatsapp,
                                                  color: Colors.green,
                                                ),
                                                SizedBox(width: ScreenSize.screenWidth(context) * 0.01),
                                                Text(
                                                  order.phone,
                                                  style: TextStyle(
                                                    color: Colors.green,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      ]
                                  )
                                ],
                              )
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: ScreenSize.screenHeight(context) * 0.02),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade200,
                            spreadRadius: 2,
                            blurRadius: 2,
                            offset: const Offset(0, 3),
                          )
                        ],
                      ),
                      child: Column(
                        children: [
                          Container(
                              padding: EdgeInsets.all(20.0),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.my_location,
                                    color: Colors.orange,
                                    size: 35.0,
                                  ),
                                  SizedBox(width: ScreenSize.screenWidth(context) * 0.04),
                                  Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: ScreenSize.screenWidth(context) * 0.6,
                                          child: Text(
                                            'Zone :',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: ScreenSize.screenWidth(context) * 0.6,
                                          child: Text(
                                            order.zone,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18,
                                            ),
                                          ),
                                        )
                                      ]
                                  )
                                ],
                              )
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: ScreenSize.screenHeight(context) * 0.02),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade200,
                            spreadRadius: 2,
                            blurRadius: 2,
                            offset: const Offset(0, 3),
                          )
                        ],
                      ),
                      child: Column(
                        children: [
                          Container(
                              padding: EdgeInsets.all(20.0),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.location_on_rounded,
                                    color: Colors.orange,
                                    size: 35.0,
                                  ),
                                  SizedBox(width: ScreenSize.screenWidth(context) * 0.04),
                                  Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          children: [
                                            Container(
                                              width: ScreenSize.screenWidth(context) * 0.6,
                                              child: Text(
                                                'Pick Up Location :',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: ScreenSize.screenWidth(context) * 0.6,
                                              child: Text(
                                                order.origin,
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(height: ScreenSize.screenHeight(context) * 0.01),
                                        Column(
                                          children: [
                                            Container(
                                              width: ScreenSize.screenWidth(context) * 0.6,
                                              child: Text(
                                                'Drop off Location :',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: ScreenSize.screenWidth(context) * 0.6,
                                              child: Text(
                                                order.destination,
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18,
                                                ),
                                              ),
                                            )
                                          ],
                                        )
                                      ]
                                  )
                                ],
                              )
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: ScreenSize.screenHeight(context) * 0.02),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade200,
                            spreadRadius: 2,
                            blurRadius: 2,
                            offset: const Offset(0, 3),
                          )
                        ],
                      ),
                      child: Column(
                        children: [
                          Container(
                              padding: EdgeInsets.all(20.0),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.route_rounded,
                                    color: Colors.orange,
                                    size: 35.0,
                                  ),
                                  SizedBox(width: ScreenSize.screenWidth(context) * 0.04),
                                  Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: ScreenSize.screenWidth(context) * 0.6,
                                          child: Text(
                                            'Trips Distance :',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: ScreenSize.screenWidth(context) * 0.6,
                                          child: Text(
                                            "${order.distance.toString()} KM",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18,
                                            ),
                                          ),
                                        )
                                      ]
                                  )
                                ],
                              )
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: ScreenSize.screenHeight(context) * 0.02),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade200,
                            spreadRadius: 2,
                            blurRadius: 2,
                            offset: const Offset(0, 3),
                          )
                        ],
                      ),
                      child: Column(
                        children: [
                          Container(
                              padding: EdgeInsets.all(20.0),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.access_time_filled_rounded,
                                    color: Colors.orange,
                                    size: 35.0,
                                  ),
                                  SizedBox(width: ScreenSize.screenWidth(context) * 0.04),
                                  Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          children: [
                                            Container(
                                              width: ScreenSize.screenWidth(context) * 0.6,
                                              child: Text(
                                                'Pick Up Time :',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: ScreenSize.screenWidth(context) * 0.6,
                                              child: Text(
                                                order.collectTime,
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(height: ScreenSize.screenHeight(context) * 0.01),
                                        Column(
                                          children: [
                                            Container(
                                              width: ScreenSize.screenWidth(context) * 0.6,
                                              child: Text(
                                                'Delivery Time :',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: ScreenSize.screenWidth(context) * 0.6,
                                              child: Text(
                                                order.deliverTime,
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18,
                                                ),
                                              ),
                                            )
                                          ],
                                        )
                                      ]
                                  )
                                ],
                              )
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: ScreenSize.screenHeight(context) * 0.02),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade200,
                            spreadRadius: 2,
                            blurRadius: 2,
                            offset: const Offset(0, 3),
                          )
                        ],
                      ),
                      child: Column(
                        children: [
                          Container(
                              padding: EdgeInsets.all(20.0),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.time_to_leave_rounded,
                                    color: Colors.orange,
                                    size: 35.0,
                                  ),
                                  SizedBox(width: ScreenSize.screenWidth(context) * 0.04),
                                  Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: ScreenSize.screenWidth(context) * 0.6,
                                          child: Text(
                                            'Vehicle Type :',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: ScreenSize.screenWidth(context) * 0.6,
                                          child: Text(
                                            "${order.vehicleType}",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18,
                                            ),
                                          ),
                                        )
                                      ]
                                  )
                                ],
                              )
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: ScreenSize.screenHeight(context) * 0.02),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade200,
                            spreadRadius: 2,
                            blurRadius: 2,
                            offset: const Offset(0, 3),
                          )
                        ],
                      ),
                      child: Column(
                        children: [
                          Container(
                              padding: EdgeInsets.all(20.0),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.edit_note_rounded,
                                    color: Colors.orange,
                                    size: 35.0,
                                  ),
                                  SizedBox(width: ScreenSize.screenWidth(context) * 0.04),
                                  Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: ScreenSize.screenWidth(context) * 0.6,
                                          child: Text(
                                            'Message :',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: ScreenSize.screenWidth(context) * 0.6,
                                          child: Text(
                                            "${order.message}",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        )
                                      ]
                                  )
                                ],
                              )
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: ScreenSize.screenHeight(context) * 0.02),
                    Center(
                      child: Container(
                        margin: const EdgeInsets.only(top: 30, bottom: 30),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.orange,
                        ),
                        child: Builder(
                          builder: (context) {
                            return MaterialButton(
                              onPressed: () => openMapsList(context),
                              child: const Text('Open Maps',
                                  style: TextStyle(
                                    color: Colors.white,
                                  )
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
