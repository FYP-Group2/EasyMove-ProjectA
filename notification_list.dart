import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:driver_integrated/driver.dart';
import 'package:driver_integrated/my_api_service.dart';
import 'package:notification/notification_service.dart';
import 'package:notification/notification_detail.dart';
import 'package:driver_integrated/notification_data.dart';


Driver driver = Driver();
DateTime now = DateTime.now();
String year = DateTime(now.year).toString();
String month = DateTime(now.month).toString();

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  NotificationPageState createState() => NotificationPageState();
}

class NotificationPageState extends State<NotificationPage> {
  late Future<List<NotificationData>>? futureNotification;

  @override
  void initState(){
    super.initState();
    
    setUpTimedFetch();
  }

  setUpTimedFetch() {
    Timer.periodic(const Duration(milliseconds: 5000), (timer) {
      setState(() {
        futureNotification = MyApiService.fetchNoti(driver.id, year, month);
      })
    })
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: NotificationList(),
    );
  }

  PreferredSizeWidget appBar(){
    return AppBar(
      title: const Text('Notification'),
      backgroundColor: const Color.fromARGB(255, 255, 168, 0),
    );
  }

  Widget NotificationList(){
    return Center(
      child: FutureBuilder<List<NotificationData>>(
        future: futureNotification,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return ListView.separated(
              itemBuilder: (BuildContext context, int index){
                return SizedBox(
                    height: 70,
                    child: ListTile(
                      title: Container(
                        margin: const EdgeInsets.only(left:0, top:15, right:0, bottom:0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              snapshot.data[index].title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              snapshot.data[index].date,
                              style: const TextStyle(
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            snapshot.data[index].message,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                      leading: CircleAvatar(
                        backgroundColor
                            : (snapshot.data[index].title == "Account Approved") ? Colors.green.shade200
                            : (snapshot.data[index].title == "Account Rejected!"  || snapshot.data[index].title == "Warning!") ? Colors.red.shade200
                            : (snapshot.data[index].title == "Season Reward") ? Colors.yellow.shade200
                            : (snapshot.data[index].title == "New Order") ? Colors.blue.shade200
                            : Colors.black12, //default
                        child: Icon(Icons.notifications,
                          size: 25,
                          color
                              : (snapshot.data[index].title == "Account Approved") ? Colors.green.shade800
                              : (snapshot.data[index].title == "Account Rejected!" || snapshot.data[index].title == "Warning!") ? Colors.red.shade800
                              : (snapshot.data[index].title == "Season Reward") ? Colors.yellow.shade800
                              : (snapshot.data[index].title == "New Order") ? Colors.blue.shade800
                              : Colors.grey.shade700, //default
                        ),
                      ),
                      onTap; () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => NotificationDetailPage(notificationData: snapshot.data[index],)
                          )
                        );
                      },
                    )
                );
              },
              separatorBuilder: (BuildContext context, int index){
                return const Divider(
                  height: 1,
                );
              },
              itemCount: snapshot.data.length,
            );
          } else if (snapshot.hasError){
            return Text('${snapshot.error}');
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}