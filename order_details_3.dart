import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show debugPaintSizeEnabled;
import 'package:driver_integrated/order.dart';

void main() {
  debugPaintSizeEnabled = false; // Set to true for visual layout
  runApp(const order_details_before());
}

class order_details_before extends StatelessWidget {
  const order_details_before({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter layout demo',
        theme: ThemeData(
          primarySwatch: Colors.orange,
          scaffoldBackgroundColor: Colors.white,
        ),
        home: const Order_specific_details(title: 'Order Details'));
  }
}

class Order_specific_details extends StatefulWidget {
  const Order_specific_details({super.key, required this.title});
  final String title;

  @override
  State<Order_specific_details> createState() => _Order_details_State();
}

class _Order_details_State extends State<Order_specific_details> {
  @override
  Widget build(BuildContext context) {
    const titleText = Padding(
      padding: EdgeInsets.all(20),
      child: Text(
        'Sushi King',
        style: TextStyle(
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
          fontSize: 30,
        ),
      ),
    );

    const order_ID = Text(
      'Order ID: ' + '10001',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontFamily: 'Georgia',
        fontSize: 25,
      ),
    );

    // #docregion iconList
    const descTextStyle = TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.w800,
      fontFamily: 'Roboto',
      letterSpacing: 0.5,
      fontSize: 18,
      height: 2,
    );

    const pick_up_time = Text(
      'Pick Up at: ' + '3.00PM',
      textAlign: TextAlign.start,
      style: descTextStyle,
    );

    const delivery_time = Text(
      'Delivery by: ' + '3.20PM',
      textAlign: TextAlign.start,
      style: descTextStyle,
    );

    const pick_Location = Text(
      'Pick-up location: ' + 'The Spring Sushi King',
      textAlign: TextAlign.start,
      style: descTextStyle,
    );

    const drop_Location = Text(
      'Drop-off location: ' + 'Taman BDC',
      textAlign: TextAlign.start,
      style: descTextStyle,
    );

    const trip_distance = Text(
      'Trip distance:  ' + '4.5km',
      textAlign: TextAlign.start,
      style: descTextStyle,
    );

    final merchantImage = Image.asset(
      "assets/images/sushi_king.jpeg",
      width: 500,
      height: 200,
      fit: BoxFit.fitWidth,
    );

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: (() {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          OrderPage()));
            })),
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Column(
        children: [
          merchantImage,
          titleText,
          order_ID,
          pick_up_time,
          delivery_time,
          pick_Location,
          drop_Location,
          trip_distance,
        ],
      ),
    );
  }
}
