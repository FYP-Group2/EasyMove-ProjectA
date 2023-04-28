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
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(16.0),
          child: Container(
            height: 4.0,
          ),
        ),
        title: SizedBox(
            child: Padding(
              padding: EdgeInsets.only(top: 50, bottom: 30),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(' | ',
                      style: TextStyle(
                          color: Colors.orange, fontWeight: FontWeight.w900, fontSize: 32.0)),
                  Flexible(
                    child: Text("Home", style: TextStyle(fontSize: 30.0, color: Colors.black),),
                  ),
                ],
              ),
            )
        ),
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
        //_statusSwitch(),
      ]),
    );
  }

  Widget _driverProfile() {
    return Center(
      child: Card(
          margin: EdgeInsets.all(30),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          clipBehavior: Clip.hardEdge,
          child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: <Color>[
                      Colors.yellow.shade600,
                      Color(0xfff5af19),
                      Colors.orange.shade800,
                      Color(0xfff5af19),
                      Colors.yellow.shade600,
                    ]
                )
            ),
            child: InkWell(
              splashColor: Colors.orange.withAlpha(30),
              child: Container(
                padding: const EdgeInsets.all(16),
                width: MediaQuery.of(context).size.width*0.845,
                height: 200,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // profile pic
                    Column(
                      children: [
                        Container(
                          constraints: const BoxConstraints.expand(height: 100, width: 100),
                          margin: const EdgeInsets.only(top:10, bottom: 10, left: 10, right: 20,),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.white,
                          ),
                          // child: Placeholder(
                          //     color: Colors.black,
                          //     strokeWidth: 4,
                          //     fallbackWidth: 10,
                          //     fallbackHeight: 100,
                          // ),
                          child: Image.asset("assets/icon/profilepic.png"),
                        ),
                        Container(
                          // decoration: BoxDecoration(
                          //   border: Border.all(
                          //     width: 1,
                          //     color: Colors.white,
                          //   ),
                          //   borderRadius: BorderRadius.circular(50),
                          //   ),
                          width: 95,
                          child: Image.asset("assets/images/EMXword.png"),
                        )
                      ],
                    ),
                    Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 10.0,
                            ),
                            Container(
                              constraints: const BoxConstraints.expand(height: 32, width: 300),
                              //name
                              child: Text(
                                "Name : ${driver.name}",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline5
                                    ?.copyWith(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ),
                            //phone number
                            Container(
                              constraints: const BoxConstraints.expand(height: 50, width: 300),
                              //name
                              child: Text(
                                "Phone No. : ${driver.mobileNumber}",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline5
                                    ?.copyWith(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ),
                            //vehicle plate no.
                            Container(
                              constraints: const BoxConstraints.expand(height: 32, width: 300),
                              child: Text(
                                "Plate No. : ${driver.plateNumber}",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline5
                                    ?.copyWith(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ),
                            Container(
                              constraints: const BoxConstraints.expand(height: 32, width: 300),
                              child: Row(
                                children: [
                                  Text("Status : ",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline5
                                        ?.copyWith(fontWeight: FontWeight.bold, fontSize: 16),),
                                  Switch(
                                      value: isSwitched,
                                      activeColor: Colors.green,
                                      activeTrackColor: Colors.green.shade300,
                                      inactiveThumbColor: Colors.red,
                                      inactiveTrackColor: Colors.red.shade300,
                                      onChanged: toggleSwitch)
                                ],
                              ),
                            ),
                          ],
                        )
                    )
                  ],
                ),
              ),
            ),
          )

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

        MyApiService.updateDriverOnOff(driver.id, textValue, driver.jwtToken);
      });
    } else {
      setState(() {
        isSwitched = false;
        driver.status = "off";
        textValue = 'off';
        locationService.stop();

        MyApiService.updateDriverOnOff(driver.id, textValue, driver.jwtToken);
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
    newsMap = await MyApiService.getNews(driver.id, driver.jwtToken);
    List<dynamic> newsData = newsMap["message"];
    return newsData;
  }

  Widget _news(){
    return Expanded(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 16.0),
          height: MediaQuery.of(context).size.height * 0.35,
          child: FutureBuilder(
            future: initNews(),
            builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
              if(snapshot.hasData) {
                return ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context, int index)
                    {
                      return Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: InkWell(
                              child: Container(
                                padding: const EdgeInsets.only(
                                    left: 10, right: 10, top: 10),
                                height: 210,
                                width: double.infinity,
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16.0),

                                  ),
                                  elevation: 2,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Expanded(
                                        flex: 5,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(16.0)
                                              .copyWith(bottomRight: Radius.circular(0), topRight: Radius.circular(0)),
                                          child: newsMap["message"][index]["photo"] == ""
                                              ? const Text("       No Image available")
                                              : Image.memory(base64Decode("${newsMap["message"][index]["photo"]}",),fit: BoxFit.fill,),

                                        ),
                                      ),
                                      Expanded(
                                        flex: 7,
                                        child: Padding(
                                          padding: EdgeInsets.only(top: 20, left: 15, right: 15),
                                          child: Column(
                                            children: [
                                              Align(
                                                alignment: Alignment.topLeft,
                                                child: Text(
                                                  '${newsMap["message"][index]["title"]}',
                                                  style: const TextStyle(fontSize: 18,
                                                    fontWeight: FontWeight.bold,),
                                                ),
                                              ),
                                              Align(
                                                alignment: Alignment.topRight,
                                                child:Text(
                                                  '${newsMap["message"][index]["release_date"]}',
                                                  style: TextStyle(color: Colors.grey.shade500),
                                                ),
                                              ),
                                              Text(
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 5,
                                                  '${newsMap["message"][index]["news_content"]}'
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // onTap: () {
                              //   Navigator.of(context).push(
                              //       MaterialPageRoute(
                              //           builder: (context) => AnnouncementPage(announcementData: snapshot.data![index],)
                              //       )
                              //   );
                              // }
                          )
                      );
                    }
                );
              }else{
                return Container(
                  height: 70.0,
                  child: new Center(child: new CircularProgressIndicator()),
                );
              }
            },
          ),
        )
    );
  }
}