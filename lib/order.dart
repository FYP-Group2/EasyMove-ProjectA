import 'package:flutter/material.dart';
import 'package:driver_integrated/list.dart';
import 'package:driver_integrated/my_api_service.dart';
import 'package:driver_integrated/driver.dart';
import 'package:driver_integrated/my_order.dart';

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

  Future<List<MyOrder>> populateOrders(String orderStatus) async{
    List<MyOrder> myOrders = [];
    List orderIds = await MyApiService.getOrdersId(driver.id, orderStatus);
    for (var oid in orderIds) {
      final data = await MyApiService.getOrder(oid);
      String status = data["status"].toString();
      String origin = data["origin"].toString();
      String destination = data["destination"];
      double distance = double.parse(data["distance"]);
      String collectTime = data["time"];
      String deliverTime = data["time_to_delivery"];
      MyOrder myOrder = MyOrder(oid, status, origin, destination, distance, collectTime, deliverTime);
      myOrders.add(myOrder);
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
            future: populateOrders("new"),
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
                    return MyList(
                      child: "Origin:\n ${data[index].origin}\n\n"
                            "Destination:\n ${data[index].destination}\n\n"
                            "Distance:${data[index].distance} KM\n"
                            "Collect Time: ${data[index].collectTime}\n"
                            "Delivery Time: ${data[index].deliverTime}",
                      orderId: data[index].id,
                    );
                  } else {
                    return ElevatedButton(
                        onPressed: () => setState(() {}),
                        child: const Text("Refresh"));
                  }
                },
              );
            },
          ),
          FutureBuilder(
            future: populateOrders("new"),
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
                    return MyList(
                      child: "Origin:\n${data[index].origin}\n\n"
                          "Destination:\n${data[index].destination}\n\n"
                          "Distance: ${data[index].distance} KM\n"
                          "Collect Time: ${data[index].collectTime}\n"
                          "Delivery Time: ${data[index].deliverTime}",
                      orderId: data[index].id,
                    );
                  }else{
                    return ElevatedButton(
                        onPressed:() => setState(() {}),
                        child: const Text("Refresh"));
                  }
                },
              );
            },
          ),
          FutureBuilder(
            future: populateOrders("delivering"),
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
                    return MyList(
                      child: "Origin:\n${data[index].origin}\n\n"
                            "Destination:\n${data[index].destination}\n\n"
                            "Distance: ${data[index].distance} KM\n"
                            "Status: ${data[index].status}\n"
                            "Collect Time: ${data[index].collectTime}\n"
                            "Delivery Time: ${data[index].deliverTime}",
                      orderId: data[index].id,
                    );
                  }else{
                    return ElevatedButton(
                        onPressed:() => setState(() {}),
                        child: const Text("Refresh"));
                  }
                },
              );
            },
          ),
          FutureBuilder(
            future: populateOrders("delivered"),
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
                    return MyList(
                      child: "Origin:\n${data[index].origin}\n\n"
                          "Destination:\n${data[index].destination}\n\n"
                          "Distance: ${data[index].distance} KM\n"
                          "Status: ${data[index].status}\n"
                          "Collect Time: ${data[index].collectTime}\n"
                          "Delivery Time: ${data[index].deliverTime}",
                      orderId: data[index].id,
                    );
                  }else{
                    return ElevatedButton(
                      onPressed:() => setState(() {}),
                      child: const Text("Refresh"));
                  }
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

