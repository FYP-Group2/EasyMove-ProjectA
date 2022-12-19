import 'package:flutter/material.dart';
import 'dart:io';
import 'package:driver_integrated/order_details.dart';
import 'package:driver_integrated/my_api_service.dart';
import 'package:driver_integrated/driver.dart';
import 'package:driver_integrated/my_order.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const OrderPage());
}

class OrderPage extends StatelessWidget {
  const OrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
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

  Future<List<MyOrder>> populateOrders(String orderStatus, bool assign) async{
    print("-------------------------------");
    List<MyOrder> myOrders = [];
    List orderIds = await MyApiService.getOrdersId(driver.id, orderStatus);
    for (var oid in orderIds) {
      final data = await MyApiService.getOrder(oid);
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
          data["assign"] != null && data["assign"] != 0,
          originLatitude,
          originLongitude,
          destinationLatitude,
          destinationLongitude);

      //print("id:${myOrder.id}, assign:${data["assign"]}, time:${myOrder.collectTime}, status:${myOrder.status}");

      if(assign && orderStatus == "new"){
        if(myOrder.isAssigned) {
          if (data["assign"] == driver.id) {
            myOrders.add(myOrder);
          }
        }
      }else{
        if(!myOrder.isAssigned) {
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
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          //child: DefaultTabController(
          //length: 3,
          child: Container(
            margin: EdgeInsets.only(top: 10, bottom: 10),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 246, 232, 206),
              borderRadius: BorderRadius.circular(50),
            ),
            child: TabBar(
              labelColor: Colors.black,
              indicator: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(50),
              ),
              isScrollable: true,
              controller: _tabController,
              tabs: const[
                Tab(
                  text: 'Nearby Orders',
                ),
                Tab(
                  text: 'Assigned Orders',
                ),
                Tab(
                  text: 'Accepted Orders',
                ),
                Tab(
                  text: 'Orders History',
                ),
              ],
            ),
          ),
        ),
        title: Text(
          widget.title,
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          FutureBuilder(
            future: populateOrders("new", false),
            builder: (BuildContext context, AsyncSnapshot<List<MyOrder>> snapshot) {
              if(!snapshot.hasData){
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const[
                    Text(
                      "No order found",
                      style: TextStyle(
                        fontSize: 32,
                      )
                    )
                  ],
                );
              }
              final data = snapshot.data;
              return ListView.builder(
                itemCount: data!.length + 1,
                itemBuilder: (context, index) {
                  if (index < data.length) {
                    return myList(
                            "Origin:\n${data[index].origin}\n\n"
                            "Destination:\n${data[index].destination}\n\n"
                            "Distance:${data[index].distance} KM\n"
                            "Collect Time: ${data[index].collectTime}\n"
                            "Delivery Time: ${data[index].deliverTime}",
                      data[index],
                      false
                    );
                  } else {
                    return ElevatedButton(
                        onPressed: () => setState(() {}),
                        child: const Text("Refresh", style: TextStyle(fontSize: 20),));
                  }
                },
              );
            },
          ),
          FutureBuilder(
            future: populateOrders("new", true),
            builder: (BuildContext context, AsyncSnapshot<List<MyOrder>> snapshot) {
              if(!snapshot.hasData){
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const[
                    Text(
                        "No order found",
                        style: TextStyle(
                          fontSize: 32,
                        )
                    )
                  ],
                );
              }
              final data = snapshot.data;
              return ListView.builder(
                itemCount: data!.length + 1,
                itemBuilder: (context, index) {
                  if(index < data.length) {
                    return myList(
                          "Origin:\n${data[index].origin}\n\n"
                          "Destination:\n${data[index].destination}\n\n"
                          "Distance: ${data[index].distance} KM\n"
                          "Collect Time: ${data[index].collectTime}\n"
                          "Delivery Time: ${data[index].deliverTime}",
                      data[index],
                      false
                    );
                  }else{
                    return ElevatedButton(
                        onPressed:() => setState(() {}),
                        child: const Text("Refresh", style: TextStyle(fontSize: 20),));
                  }
                },
              );
            },
          ),
          FutureBuilder(
            future: populateOrders("delivering", false),
            builder: (BuildContext context, AsyncSnapshot<List<MyOrder>> snapshot) {
              if(!snapshot.hasData){
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const[
                    Text(
                        "No order found",
                        style: TextStyle(
                          fontSize: 32,
                        )
                    )
                  ],
                );
              }
              final data = snapshot.data;
              return ListView.builder(
                itemCount: data!.length + 1,
                itemBuilder: (context, index) {
                  if(index < data.length) {
                    return myList(
                            "Origin:\n${data[index].origin}\n\n"
                            "Destination:\n${data[index].destination}\n\n"
                            "Distance: ${data[index].distance} KM\n"
                            "Status: ${data[index].status}\n"
                            "Collect Time: ${data[index].collectTime}\n"
                            "Delivery Time: ${data[index].deliverTime}",
                      data[index],
                      false
                    );
                  }else{
                    return ElevatedButton(
                        onPressed:() => setState(() {}),
                        child: const Text("Refresh", style: TextStyle(fontSize: 20),));
                  }
                },
              );
            },
          ),
          FutureBuilder(
            future: populateOrders("delivered", false),
            builder: (BuildContext context, AsyncSnapshot<List<MyOrder>> snapshot) {
              if(!snapshot.hasData){
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const[
                    Text(
                        "No order found",
                        style: TextStyle(
                          fontSize: 32,
                        )
                    )
                  ],
                );
              }
              final data = snapshot.data;
              return ListView.builder(
                itemCount: data!.length + 1,
                itemBuilder: (context, index) {
                  if(index < data.length) {
                    return myList(
                          "Origin:\n${data[index].origin}\n\n"
                          "Destination:\n${data[index].destination}\n\n"
                          "Distance: ${data[index].distance} KM\n"
                          "Status: ${data[index].status}\n"
                          "Collect Time: ${data[index].collectTime}\n"
                          "Delivery Time: ${data[index].deliverTime}",
                      data[index],
                      true
                    );
                  }else{
                    return ElevatedButton(
                      onPressed:() => setState(() {}),
                      child: const Text("Refresh", style: TextStyle(fontSize: 20),));
                  }
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget myList(String child, MyOrder order, bool limitDirection){
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 2,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Dismissible(
        direction: limitDirection? DismissDirection.startToEnd : DismissDirection.horizontal,
        onDismissed: (direction) {
          if (direction == DismissDirection.startToEnd) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Order_details(order: order,)));
          }else if (direction == DismissDirection.endToStart) {
            if(order.isAssigned && order.status == "Ordered") {
              assignedAlertBox(order.id);
            }else{
              orderActionAlertBox(order.id, myAlertBoxAction(order.status));
            }
          }
        },
        key: UniqueKey(),
        background: Container(
          color: const Color.fromARGB(255, 208, 208, 208),
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
          color: const Color(0xFF7BC043),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.arrow_left),
              dismissibleText(order.status, order.isAssigned),
            ],
          ),
        ),
        child: Container(
          width: 500,
          color: const Color.fromARGB(255, 246, 232, 206),
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: Text(child, textAlign: TextAlign.start, style: const TextStyle(fontSize: 16),),
        ),
      ),
    );
  }

  Widget dismissibleText(String orderStatus, bool isAssigned){
    switch(orderStatus){
      case("Ordered"):
        if(isAssigned) {
          return const Text("Accept or Decline");
        }
        return const Text("Accept");
      case("Accepted"):
        return const Text("Collect");
      case("Collected"):
        return const Text("Take PoD");
      case("Delivered"):
        return const Text("Order Summary");
      default:
        return const Text("");
    }
  }

  String myAlertBoxAction(String action){
    switch(action){
      case("Ordered"):
        return "accept";
      case("Accepted"):
        return "collect";
      case("Collected"):
        return "pod";
      default:
        return "";
    }
  }

  Widget myAlertBoxTitle(String action){
    switch(action){
      case("accept"):
        return const Text("Are you sure to accept this order?");
      case("collect"):
        return const Text("Are you sure to collect this order?");
      case("pod"):
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          title: const Text("Order Confirmation"),//myAlertBoxTitle(action),
          content: Container(
            height: MediaQuery.of(context).size.height / 6,
            child: myAlertBoxTitle(action),
          ),
          actions:[
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
                if(action != "pod") {
                  MyApiService.updateOrder(driver.id, orderId, action);
                }
                Navigator.of(context).pop(true);
                setState(() {});
                if(action == "pod"){
                  podImageAlertBox(orderId);
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
          ]
        );
      }
    );
  }

  void podImageAlertBox(int orderId) {
    showDialog(
      context: context,
      builder: (context){
        return SimpleDialog(
          title: const Text("Please choose an option to upload an image as Proof of Delivery"),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: (){
                getImage(ImageSource.gallery, orderId);
                Navigator.of(context).pop();
                setState(() {});
              },
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const[
                    Icon(Icons.image, size: 28,),
                    Text("From Gallery", style: TextStyle(fontSize: 20),)
                  ],
                ),
              ),
            SimpleDialogOption(
              onPressed: (){
                getImage(ImageSource.camera, orderId);
                Navigator.of(context).pop();
                setState(() {});
              },
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const[
                    Icon(Icons.camera, size: 28,),
                    Text("Camera", style: TextStyle(fontSize: 20),)
                  ],
                ),
              ),
          ],
        );
      }
    );
  }

  void assignedAlertBox(int oid){
    showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          title: const Text("Order Confirmation"),//myAlertBoxTitle(action),
          content: Container(
            height: MediaQuery.of(context).size.height / 6,
            child: const Text("Do you want to accept or decline this assigned order?"),
          ),
          actions: [
            TextButton(
              onPressed: (){
                MyApiService.updateOrder(driver.id, oid, "decline");
                Navigator.of(context).pop();
                setState(() {});
              },
              child: const Text("Decline", style: TextStyle(fontSize: 20, color: Colors.redAccent))
            ),
            TextButton(
                onPressed: (){
                  MyApiService.updateOrder(driver.id, oid, "accept");
                  Navigator.of(context).pop();
                  setState(() {});
                },
                child: const Text("Accept", style: TextStyle(fontSize: 20, color: Color(0xFF7BC043),))
            ),
          ],
        );
      }
    );
  }

  Future<void> getImage(ImageSource media, int orderId) async{
    XFile? image = await imagePicker.pickImage(source: media);
    File imageFile = File(image!.path);
    String filePath = imageFile.path;
    uploadPOD(orderId, filePath);
  }

  void uploadPOD(int orderId, String filePath){
    MyApiService.updateOrder(driver.id, orderId, "pod");
    MyApiService.photoPOD(orderId, filePath);
  }

}

