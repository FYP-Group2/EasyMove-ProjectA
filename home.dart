import 'package:flutter/material.dart';
import 'package:driver_integrated/my_api_service.dart';
import 'package:driver_integrated/driver.dart';
import 'package:driver_integrated/my_location_service.dart';

Driver driver = Driver();

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title, this.onPush});
  final String title;
  final ValueChanged<int>? onPush;

  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<HomePage> {
  var textValue = 'off';
  bool isSwitched = driver.status == "on";
  MyLocationService locationService = MyLocationService(driver.id);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 168, 0),
      ),
      body: Center(
        child: Column(
          children: [
            _upperPart(),
            //_orderCard(),
          ],
        ),
      ),
    );
  }

  Widget _upperPart() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _driverProfile(),
          _statusSwitch(),
        ]
      ),
    );
  }

  Widget _driverProfile() {
    return Container(
      margin: EdgeInsets.only(left:20, top:10, right:0, bottom:10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget> [
          Text(
            "Hi ${driver.name}",
            style: Theme.of(context).textTheme.headline5?.copyWith(fontWeight: FontWeight.bold),
          ),
          Container(
            child: Image.asset(
              'assets/icon/profilepic.png',
              height: 100,
              width: 100,
            ),
          )
        ],
      ),
    );
  }

  void toggleSwitch(bool value) {
    if (isSwitched == false) {
      setState(() {
        isSwitched = true;
        driver.status = "on";
        textValue = 'on';
        locationService.start();

        MyApiService.updateDriverOnOff(driver.id, textValue);
      });
    }
    else {
      setState(() {
        isSwitched = false;
        driver.status = "off";
        textValue = 'off';
        locationService.stop();

        MyApiService.updateDriverOnOff(driver.id, textValue);
      });
    }
  }

  Widget _statusSwitch() {
    return Container(
        child: Transform.scale(
            scale: 1,
            child: Switch(
              activeColor: Colors.green,
              activeTrackColor: Colors.green.shade300,
              inactiveThumbColor: Colors.red,
              inactiveTrackColor: Colors.red.shade300,
              value: isSwitched,
              onChanged: toggleSwitch,
            )
        )
    );
  }

  // Widget _orderCard() {
  //   return Expanded(
  //       child: ListView.builder(
  //           itemCount:allorder.length,
  //           itemBuilder: (BuildContext context, int index) {
  //             OrderData data = allorder[index];
  //
  //             return Container(
  //               height: 100,
  //               margin: const EdgeInsets.only(left:20, top:10, right:20, bottom:10),
  //               child: Card(
  //                 child: ListTile (
  //                   title: Text(data.id),
  //                   subtitle: Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: <Widget> [
  //                         Text(data.company),
  //                         Text(data.address)
  //                       ]
  //                   ),
  //                   leading: const CircleAvatar(
  //                     backgroundImage: AssetImage("assets/icon/truck.png"),
  //                   ),
  //                   trailing: const Icon(Icons.arrow_forward_ios_outlined),
  //                   tileColor: Colors.white60,
  //                   shape: RoundedRectangleBorder(
  //                     borderRadius: BorderRadius.circular(20.0),
  //                   ),
  //                 ),
  //               ),
  //             );
  //           })
  //   );
  // }

}

