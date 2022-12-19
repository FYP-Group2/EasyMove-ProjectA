import 'package:driver_integrated/order.dart';
import 'package:flutter/material.dart';
import 'package:driver_integrated/my_order.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:driver_integrated/driver.dart';
import 'package:driver_integrated/my_api_service.dart';

class Order_details extends StatelessWidget {
  const Order_details({super.key, required this.order});
  final MyOrder order;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Order Details Page',
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
                        // onTap: () => map.showMarker(
                        //   coords: coords,
                        //   title: title,
                        // ),
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
    } catch (e) {
      print(e);
    }
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
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const OrderPage()));
            })),
        title: const Text(
          'Order Details',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SizedBox(
        height: 1000,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 35,
                margin: const EdgeInsets.only(top: 0, bottom: 0),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                    ),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.fromLTRB(0, 5, 5, 0),
                          child: const Text('Order ID:',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(
                                  color: Colors.orange,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.fromLTRB(185, 5, 5, 0),
                          child: Text(order.id.toString(),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: const TextStyle(
                                color: Colors.orange,
                                fontSize: 18,
                              )),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                height: 70,
                //color: const Color.fromARGB(255, 246, 232, 206),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color.fromARGB(255, 246, 232, 206),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 2,
                      offset: const Offset(0, 3),
                    )
                  ],
                ),
                margin: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 5, right: 0),
                    ),
                    const Icon(
                      Icons.calendar_today,
                      color: Colors.orange,
                      size: 50.0,
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          const FittedBox(
                            child: Padding(
                              padding: EdgeInsets.only(top: 10, bottom: 5),
                              child: Text(
                                'Date & Time:',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 0, bottom: 5),
                              child: Text(
                                order.createdTime,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                height: 70,
                //color: const Color.fromARGB(255, 246, 232, 206),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color.fromARGB(255, 246, 232, 206),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 2,
                      offset: const Offset(0, 3),
                    )
                  ],
                ),
                margin: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    const Padding(padding: EdgeInsets.only(left: 5)),
                    const Icon(
                      Icons.apartment,
                      color: Colors.orange,
                      size: 50.0,
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          const FittedBox(
                            child: Padding(
                              padding: EdgeInsets.only(top: 10, bottom: 5),
                              child: Text(
                                'Merchant:',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 0, bottom: 5),
                              child: Text(
                                order.branchName,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                height: 70,
                //color: const Color.fromARGB(255, 246, 232, 206),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color.fromARGB(255, 246, 232, 206),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 2,
                      offset: const Offset(0, 3),
                    )
                  ],
                ),
                margin: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    const Padding(padding: EdgeInsets.only(left: 5)),
                    const Icon(
                      Icons.person,
                      color: Colors.orange,
                      size: 50.0,
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          const FittedBox(
                            child: Padding(
                              padding: EdgeInsets.only(top: 10, bottom: 5),
                              child: Text("Customer's name:",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 0, bottom: 5),
                              child: Text(
                                order.customerName,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 70,
                //color: const Color.fromARGB(255, 246, 232, 206),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color.fromARGB(255, 246, 232, 206),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 2,
                      offset: const Offset(0, 3),
                    )
                  ],
                ),
                margin: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    const Padding(padding: EdgeInsets.only(left: 5)),
                    const Icon(
                      Icons.phone,
                      color: Colors.orange,
                      size: 50.0,
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          const FittedBox(
                            child: Padding(
                              padding: EdgeInsets.only(top: 10, bottom: 5),
                              child: Text(
                                "Phone number :",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 0, bottom: 5),
                              child: Text(
                                order.phone,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 70,
                //color: const Color.fromARGB(255, 246, 232, 206),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color.fromARGB(255, 246, 232, 206),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 2,
                      offset: const Offset(0, 3),
                    )
                  ],
                ),
                margin: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 5, right: 0),
                    ),
                    const Icon(
                      Icons.location_city,
                      color: Colors.orange,
                      size: 50.0,
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          const FittedBox(
                            child: Padding(
                              padding: EdgeInsets.only(top: 10, bottom: 5),
                              child: Text(
                                "Zone :",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 0, bottom: 5),
                              child: Text(
                                order.zone,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                //height: 70,
                //color: const Color.fromARGB(255, 246, 232, 206),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20)),
                  color: const Color.fromARGB(255, 246, 232, 206),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 2,
                      offset: const Offset(3, 0),
                    )
                  ],
                ),
                margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: Row(
                  children: [
                    const Padding(padding: EdgeInsets.only(left: 5)),
                    const Icon(
                      Icons.assistant_direction_rounded,
                      color: Colors.orange,
                      size: 50.0,
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          const FittedBox(
                            child: Padding(
                              padding: EdgeInsets.only(top: 10, bottom: 5),
                              child: Text(
                                'Pick Up Location:',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  order.origin,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 10,
                                  softWrap: false,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                //height: 70,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20)),
                  color: const Color.fromARGB(255, 246, 232, 206),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 2,
                      offset: const Offset(3, 3),
                    )
                  ],
                ),
                margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                child: Row(
                  children: [
                    const Padding(padding: EdgeInsets.only(left: 5)),
                    const Icon(
                      Icons.house,
                      color: Colors.orange,
                      size: 50.0,
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          const FittedBox(
                            child: Padding(
                              padding: EdgeInsets.only(top: 10, bottom: 5),
                              child: Text(
                                'Drop off Location:',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  order.destination,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 10,
                                  softWrap: false,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color.fromARGB(255, 246, 232, 206),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 2,
                      offset: const Offset(0, 3),
                    )
                  ],
                ),
                margin: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    const Padding(padding: EdgeInsets.only(left: 5)),
                    const Icon(
                      Icons.delivery_dining,
                      color: Colors.orange,
                      size: 50.0,
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          const FittedBox(
                            child: Padding(
                              padding: EdgeInsets.only(top: 10, bottom: 5),
                              child: Text('Trips Distance: ',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 0, bottom: 5),
                              child: Text(
                                "${order.distance.toString()} KM",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 70,
                //color: const Color.fromARGB(255, 246, 232, 206),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20)),
                  color: const Color.fromARGB(255, 246, 232, 206),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 2,
                      offset: const Offset(3, 0),
                    )
                  ],
                ),
                margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: Row(
                  children: [
                    const Padding(padding: EdgeInsets.only(left: 5)),
                    const Icon(
                      Icons.timelapse,
                      color: Colors.orange,
                      size: 50.0,
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          const FittedBox(
                            child: Padding(
                              padding: EdgeInsets.only(top: 10, bottom: 5),
                              child: Text(
                                'Pick Up Time:',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 0, bottom: 5),
                              child: Text(
                                order.collectTime,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 70,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20)),
                  color: const Color.fromARGB(255, 246, 232, 206),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 2,
                      offset: const Offset(3, 3),
                    )
                  ],
                ),
                margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                child: Row(
                  children: [
                    const Padding(padding: EdgeInsets.only(left: 5)),
                    const Icon(
                      Icons.time_to_leave,
                      color: Colors.orange,
                      size: 50.0,
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          const FittedBox(
                            child: Padding(
                              padding: EdgeInsets.only(top: 10, bottom: 5),
                              child: Text(
                                'Delivery Time:',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 0, bottom: 5),
                              child: Text(
                                order.deliverTime,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
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
                                color: Color.fromARGB(255, 246, 232, 206))),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}