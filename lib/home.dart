import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:driver_integrated/my_api_service.dart';
import 'package:driver_integrated/my_location_service.dart';
import 'package:driver_integrated/driver.dart';
import 'dart:async';

import 'package:flutter/services.dart';

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
  Map<String, dynamic> newsMap = {};

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
            _news(),
          ],
        ),
      ),
    );
  }

  Widget _upperPart() {
    return Container(
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        _driverProfile(),
        _statusSwitch(),
      ]),
    );
  }

  Widget _driverProfile() {
    return Container(
      margin: const EdgeInsets.only(left: 20, top: 20, right: 0, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // profile pic
          Container(
            constraints: const BoxConstraints.expand(height: 100, width: 100),
            // child: Placeholder(
            //     color: Colors.black,
            //     strokeWidth: 4,
            //     fallbackWidth: 10,
            //     fallbackHeight: 100,
            // ),
            child: Image.asset("assets/icon/profilepic.png"),
          ),
          Container(
            constraints: const BoxConstraints.expand(height: 25, width: 300),
            //name
            child: Text(
              "Name : ${driver.name}",
              style: Theme.of(context)
                  .textTheme
                  .headline5
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          //phone number
          Container(
            constraints: const BoxConstraints.expand(height: 25, width: 300),
            //name
            child: Text(
              "Phone No. : ${driver.mobileNumber}",
              style: Theme.of(context)
                  .textTheme
                  .headline5
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          //vehicle plate no.
          Container(
            constraints: const BoxConstraints.expand(height: 25, width: 300),
            child: Text(
              "Plate No. : ${driver.plateNumber}",
              style: Theme.of(context)
                  .textTheme
                  .headline5
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
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
    } else {
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
    return Transform.scale(
        scale: 1,
        child: Switch(
          activeColor: Colors.green,
          activeTrackColor: Colors.green.shade300,
          inactiveThumbColor: Colors.red,
          inactiveTrackColor: Colors.red.shade300,
          value: isSwitched,
          onChanged: toggleSwitch,
        )
    );
  }

  Future<List<dynamic>> initNews() async {
    newsMap = await MyApiService.getNews();
    List<dynamic> newsData = newsMap["message"];
    return newsData;
  }

  Widget _news(){
    return Expanded(
      child: FutureBuilder(
        future: initNews(),
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
          if(snapshot.hasData) {
            return ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    padding: const EdgeInsets.only(
                        left: 30, right: 30, top: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          flex: 5,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: newsMap["message"][index]["photo"] == ""
                              ? const Text("No Image available")
                              : Image.memory(base64Decode("${newsMap["message"][index]["photo"]}")),
                          ),
                        ),
                        Expanded(
                            flex: 5,
                            child: Column(
                              children: [
                                Text(
                                  '${newsMap["message"][index]["title"]}',
                                  style: const TextStyle(fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                    '${newsMap["message"][index]["release_date"]}'
                                ),
                                Text(
                                    '${newsMap["message"][index]["news_content"]}'
                                ),
                              ],
                            )
                        ),
                      ],
                    ),
                  );
                });
          }else{
            return const CircularProgressIndicator();
          }
        },
      )
    );
  }
}