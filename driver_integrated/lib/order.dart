import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'dart:io';
import 'package:driver_integrated/order_details.dart';
import 'package:driver_integrated/my_api_service.dart';
import 'package:driver_integrated/driver.dart';
import 'package:driver_integrated/my_order.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const OrderPage());
}

class OrderPage extends StatelessWidget {
  const OrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: const OrderList(title: 'Order List'),
    );
  }
}

class OrderList extends StatefulWidget {
  const OrderList({super.key, required this.title});
  final String title;

  @override
  State<OrderList> createState() => _MyListPageState();
}

class _MyListPageState extends State<OrderList> with TickerProviderStateMixin {
  Driver driver = Driver();
  final ImagePicker imagePicker = ImagePicker();

  Future<List<MyOrder>> populateOrders(String orderStatus, bool assign) async {
    List<MyOrder> myOrders = [];
    List orderIds = await MyApiService.getOrdersId(driver.id, orderStatus, driver.jwtToken);
    //myOrders.sort((a, b) =>(double.parse(a.collectTime)).compareTo((double.parse(b.collectTime))));
    for (var oid in orderIds) {
      final data = await MyApiService.getOrder(oid, driver.jwtToken);
      String status = data["status"].toString();
      String origin = data["origin"].toString();
      String destination = data["destination"];
      double distance = double.parse(data["distance"]);
      String createdTime = data["created"];
      String collectTime = data["time"];
      String deliverTime = data["time_to_delivery"];
      String branchName = data["branch_name"];
      String customerName = data["customer_name"];
      String phone = data["phone"];
      String zone = data["zone"];
      String vehicleType = data["requirement"];
      String message = data["message"];
      String originLatitude = data["o_lat"];
      String originLongitude = data["o_lon"];
      String destinationLatitude = data["d_lat"];
      String destinationLongitude = data["d_lon"];

      MyOrder myOrder = MyOrder(
          oid,
          status,
          origin,
          destination,
          distance,
          createdTime,
          collectTime,
          deliverTime,
          branchName,
          customerName,
          phone,
          zone,
          vehicleType,
          message,
          data["assign"] != null && data["assign"] != 0,
          originLatitude,
          originLongitude,
          destinationLatitude,
          destinationLongitude);

      //print("id:${myOrder.id}, assign:${data["assign"]}, time:${myOrder.collectTime}, status:${myOrder.status}");

      if (assign && orderStatus == "new") {
        if (myOrder.isAssigned) {
          if (data["assign"] == driver.id) {
            myOrders.add(myOrder);
          }
        }
      } else {
        if (!myOrder.isAssigned ||
            (myOrder.isAssigned &&
                data["assign"] == driver.id &&
                orderStatus != "new")) {
          myOrders.add(myOrder);
        }
      }
    }

    return myOrders;
  }

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    //List<MyOrder> orders = [];
    //orders.sort((a, b) => (double.parse(a.collectTime)).compareTo((double.parse(b.collectTime))));

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          //child: DefaultTabController(
          //length: 3,
          child: Container(
            margin: const EdgeInsets.only(top: 10, bottom: 10),
            child: TabBar(
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey.shade400,
              isScrollable: true,
              controller: _tabController,
              tabs: const [
                Tab(
                  text: 'Nearby',
                ),
                Tab(
                  text: 'Assigned',
                ),
                Tab(
                  text: 'Accepted',
                ),
                Tab(
                  text: 'Collected',
                ),
                Tab(
                  text: 'History',
                ),
              ],
            ),
          ),
        ),
        title: SizedBox(
            child: Padding(
              padding: EdgeInsets.only(top: 50, bottom: 30),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:  [
                  Text(' | ',
                      style: TextStyle(
                          color: Colors.orange.shade700, fontWeight: FontWeight.w900, fontSize: 32.0)),
                  Flexible(
                    child: Text("Order List", style: TextStyle(fontSize: 30.0),),
                  ),
                ],
              ),
            )
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          FutureBuilder(
            future: populateOrders("new", false),
            builder:
                (BuildContext context, AsyncSnapshot<List<MyOrder>> snapshot) {
              if (!snapshot.hasData) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text("No order found",
                        style: TextStyle(
                          fontSize: 32,
                        ))
                  ],
                );
              }
              final data = snapshot.data;
              data!.sort((a, b) => a.collectTime.compareTo(b.collectTime));
              return ListView.builder(
                itemCount: data!.length + 1,
                itemBuilder: (context, index) {
                  if (index < data.length) {
                    return myList(
                        "Origin:\n${data[index].origin}\n\n"
                            "Destination:\n${data[index].destination}\n\n"
                            "Distance: ${data[index].distance} KM\n\n"
                            "Delivery Time: ${data[index].deliverTime}",
                        data[index],
                        false);
                  } else {
                    return SizedBox(
                      width: 180,
                      height: 40,
                      child: GFButton(
                        color: Colors.orangeAccent,
                        borderSide: const BorderSide(
                          color: Colors.orange,
                          style: BorderStyle.solid,

                        ),
                        onPressed: () => setState(() {}),
                        shape: GFButtonShape.pills,
                        child: const Text(
                          "Refresh",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    );
                  }
                },
              );
            },
          ),
          FutureBuilder(
            future: populateOrders("new", true),
            builder:
                (BuildContext context, AsyncSnapshot<List<MyOrder>> snapshot) {
              if (!snapshot.hasData) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text("No order found",
                        style: TextStyle(
                          fontSize: 32,
                        ))
                  ],
                );
              }
              final data = snapshot.data;
              data!.sort((a, b) => a.collectTime.compareTo(b.collectTime));
              return ListView.builder(
                itemCount: data!.length + 1,
                itemBuilder: (context, index) {
                  if (index < data.length) {
                    return myList(
                        "Origin:\n${data[index].origin}\n\n"
                            "Destination:\n${data[index].destination}\n\n"
                            "Distance: ${data[index].distance} KM\n\n"
                            "Delivery Time: ${data[index].deliverTime}",
                        data[index],
                        false);
                  } else {
                    return SizedBox(
                      width:180,
                      height:40,
                      child: GFButton(
                        color: Colors.orangeAccent,
                        borderSide: const BorderSide(
                          color: Colors.orange,
                          style: BorderStyle.solid,
                          width: 1,
                        ),
                        onPressed: () => setState(() {}),
                        shape: GFButtonShape.pills,
                        child: const Text(
                          "Refresh",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    );
                  }
                },
              );
            },
          ),
          FutureBuilder(
            future: populateOrders("delivering", false),
            builder:
                (BuildContext context, AsyncSnapshot<List<MyOrder>> snapshot) {
              if (!snapshot.hasData) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text("No order found",
                        style: TextStyle(
                          fontSize: 32,
                        ))
                  ],
                );
              }
              final data = snapshot.data;
              data!.sort((a, b) => a.collectTime.compareTo(b.collectTime));
              return ListView.builder(
                itemCount: data!.length + 1,
                itemBuilder: (context, index) {
                  if (index < data.length) {
                    return myList(
                        "Origin:\n${data[index].origin}\n\n"
                            "Destination:\n${data[index].destination}\n\n"
                            "Distance: ${data[index].distance} KM\n\n"

                            "Delivery Time: ${data[index].deliverTime}",
                        data[index],
                        false);
                  } else {
                    return SizedBox(
                      width:180,
                      height:40,
                      child: GFButton(
                        color: Colors.orangeAccent,
                        borderSide: const BorderSide(
                          color: Colors.orange,
                          style: BorderStyle.solid,
                          width: 1,
                        ),
                        onPressed: () => setState(() {}),
                        shape: GFButtonShape.pills,
                        child: const Text(
                          "Refresh",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    );
                  }
                },
              );
            },
          ),
          FutureBuilder(
            future: populateOrders("collecting", false),
            builder:
                (BuildContext context, AsyncSnapshot<List<MyOrder>> snapshot) {
              if (!snapshot.hasData) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text("No order found",
                        style: TextStyle(
                          fontSize: 32,
                        ))
                  ],
                );
              }
              final data = snapshot.data;
              data!.sort((a, b) => a.collectTime.compareTo(b.collectTime));
              return ListView.builder(
                itemCount: data!.length + 1,
                itemBuilder: (context, index) {
                  if (index < data.length) {
                    return myList(
                        "Origin:\n${data[index].origin}\n\n"
                            "Destination:\n${data[index].destination}\n\n"
                            "Distance: ${data[index].distance} KM\n\n"
                            "Delivery Time: ${data[index].deliverTime}",
                        data[index],
                        false);
                  } else {
                    return SizedBox(
                      width:180,
                      height:40,
                      child: GFButton(
                        color: Colors.orangeAccent,
                        borderSide: const BorderSide(
                          color: Colors.orange,
                          style: BorderStyle.solid,
                          width: 1,
                        ),
                        onPressed: () => setState(() {}),
                        shape: GFButtonShape.pills,
                        child: const Text(
                          "Refresh",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    );
                  }
                },
              );
            },
          ),
          FutureBuilder(
            future: populateOrders("delivered", false),
            builder:
                (BuildContext context, AsyncSnapshot<List<MyOrder>> snapshot) {
              if (!snapshot.hasData) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text("No order found",
                        style: TextStyle(
                          fontSize: 32,
                        ))
                  ],
                );
              }
              final data = snapshot.data;
              data!.sort((a, b) => a.collectTime.compareTo(b.collectTime));
              return ListView.builder(
                itemCount: data!.length + 1,
                itemBuilder: (context, index) {
                  if (index < data.length) {
                    return myList(
                        "Origin:\n${data[index].origin}\n\n"
                            "Destination:\n${data[index].destination}\n\n"
                            "Distance: ${data[index].distance} KM\n\n"
                            "Delivery Time: ${data[index].deliverTime}",
                        data[index],
                        true);
                  } else {
                    return SizedBox(
                      width:180,
                      height:40,
                      child: GFButton(
                        color: Colors.orangeAccent,
                        borderSide: const BorderSide(
                          color: Colors.orange,
                          style: BorderStyle.solid,
                          width: 1,
                        ),
                        onPressed: () => setState(() {}),
                        shape: GFButtonShape.pills,
                        child: const Text(
                          "Refresh",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    );
                  }
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget myList(String child, MyOrder order, bool limitDirection) {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      // decoration: BoxDecoration(
      //   border: Border.all(color: Colors.white),
      //   boxShadow: [
      //     BoxShadow(
      //       color: Colors.grey.withOpacity(0.2),
      //       spreadRadius: 2,
      //       blurRadius: 2,
      //       offset: const Offset(0, 3),
      //     )
      //   ],
      // ),
      child: Dismissible(
        direction: limitDirection
            ? DismissDirection.startToEnd
            : DismissDirection.horizontal,
        onDismissed: (direction) {
          if (direction == DismissDirection.startToEnd) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Order_details(
                          order: order,
                        )));
          } else if (direction == DismissDirection.endToStart) {
            if (order.isAssigned && order.status == "Ordered") {
              assignedAlertBox(order.id);
            } else {
              orderActionAlertBox(order.id, myAlertBoxAction(order.status));
            }
          }
        },
        key: UniqueKey(),
        background: Container(
          color: const Color.fromARGB(255, 208, 208, 208),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 208, 208, 208),
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                blurRadius: 7,
                offset: const Offset(0, 3),
              )
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.more),
              Text(
                "More",
                style: TextStyle(color: Colors.white),
              )
            ],
          ),
        ),
        secondaryBackground: Container(
          margin: EdgeInsets.only(top: 20),
          decoration: BoxDecoration(
            color: const Color(0xFF7BC043),
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                blurRadius: 7,
                offset: const Offset(0, 3),
              )
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.arrow_left),
              dismissibleText(order.status, order.isAssigned),
            ],
          ),
        ),
        child: Container(
          margin: EdgeInsets.only(top: 20),
          width: 500,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                blurRadius: 7,
                offset: const Offset(0, 3),
              )
            ],
          ),

          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: Text(
            child,
            textAlign: TextAlign.start,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget dismissibleText(String orderStatus, bool isAssigned) {
    switch (orderStatus) {
      case ("Ordered"):
        if (isAssigned) {
          return const Text("Accept or Decline");
        }
        return const Text("Accept");
      case ("Accepted"):
        return const Text("Collect");
      case ("Collected"):
        return const Text("Take PoD");
      case ("Delivered"):
        return const Text("Order Summary");
      default:
        return const Text("");
    }
  }

  String myAlertBoxAction(String action) {
    switch (action) {
      case ("Ordered"):
        return "accept";
      case ("Accepted"):
        return "collect";
      case ("Collected"):
        return "pod";
      default:
        return "";
    }
  }

  Widget orderActionAlertBoxTitle(String action) {
    switch (action) {
      case ("accept"):
        return const Text("Are you sure to accept this order?");
      case ("collect"):
        return const Text("Are you sure to collect this order?");
      case ("pod"):
        return const Text("Are you sure to take PoD for this order?");
      default:
        return const Text("");
    }
  }

  void orderActionAlertBox(int orderId, String action) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              title:
                  const Text("Order Confirmation"), //myAlertBoxTitle(action),
              content: Container(
                height: MediaQuery.of(context).size.height / 6,
                child: orderActionAlertBoxTitle(action),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                    setState(() {});
                  },
                  child: const Text(
                    "No",
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 20,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                    if (action == "accept") {
                      MyApiService.updateOrder(driver.id, orderId, action, driver.jwtToken);
                      setState(() {});
                    } else {
                      uploadImageAlertBox(orderId, action);
                    }
                  },
                  child: const Text(
                    "Yes",
                    style: TextStyle(
                      color: Color(0xFF7BC043),
                      fontSize: 20,
                    ),
                  ),
                ),
              ]);
        });
  }

  void uploadImageAlertBox(int orderId, String action) {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text("Please choose an option to upload an image"),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  getImage(ImageSource.gallery, orderId, action);
                  Navigator.of(context).pop();
                  setState(() {});
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Icon(
                      Icons.image,
                      size: 28,
                    ),
                    Text(
                      "From Gallery",
                      style: TextStyle(fontSize: 20),
                    )
                  ],
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  getImage(ImageSource.camera, orderId, action);
                  Navigator.of(context).pop();
                  setState(() {});
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Icon(
                      Icons.camera,
                      size: 28,
                    ),
                    Text(
                      "Camera",
                      style: TextStyle(fontSize: 20),
                    )
                  ],
                ),
              ),
            ],
          );
        });
  }

  void assignedAlertBox(int oid) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: const Text("Order Confirmation"), //myAlertBoxTitle(action),
            content: Container(
              height: MediaQuery.of(context).size.height / 6,
              child: const Text(
                  "Do you want to accept or decline this assigned order?"),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    MyApiService.updateOrder(driver.id, oid, "decline", driver.jwtToken);
                    Navigator.of(context).pop();
                    setState(() {});
                  },
                  child: const Text("Decline",
                      style: TextStyle(fontSize: 20, color: Colors.redAccent))),
              TextButton(
                  onPressed: () {
                    MyApiService.updateOrder(driver.id, oid, "accept", driver.jwtToken);
                    Navigator.of(context).pop();
                    setState(() {});
                  },
                  child: const Text("Accept",
                      style: TextStyle(
                        fontSize: 20,
                        color: Color(0xFF7BC043),
                      ))),
            ],
          );
        });
  }

  Future<void> getImage(ImageSource media, int orderId, String action) async {
    XFile? image = await imagePicker.pickImage(source: media);
    File imageFile = File(image!.path);
    String filePath = imageFile.path;
    uploadImage(orderId, filePath, action);
  }

  void uploadImage(int orderId, String filePath, String action) {
    if (action == "collect") {
      MyApiService.updateOrder(driver.id, orderId, "collect", driver.jwtToken);
      MyApiService.photoPOC(orderId, filePath);
    } else if (action == "pod") {
      MyApiService.updateOrder(driver.id, orderId, "pod", driver.jwtToken);
      MyApiService.photoPOD(orderId, filePath);
    }
    setState(() {});
  }
}
