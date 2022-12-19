import 'dart:async';
import 'package:flutter/material.dart';
import 'package:driver_integrated/notification_data.dart';
import 'package:driver_integrated/driver.dart';
import 'package:driver_integrated/my_api_service.dart';


Driver driver = Driver();
DateTime now = DateTime.now();
String year = DateTime(now.year).toString();
String month = DateTime(now.month).toString();

class NotificationView extends StatefulWidget {
  const NotificationView({Key? key}) : super(key: key);

  @override
  NotificationViewState createState() => NotificationViewState();
}

class NotificationViewState extends State<NotificationView> {
  late Future<List<NotificationData>>? futureNoti;

  @override
  void initState(){
    super.initState();
    futureNoti = MyApiService.fetchNoti(driver.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: notificationViewList(),
    );
  }

  PreferredSizeWidget appBar(){
    return AppBar(
      title: const Text('Notification'),
      backgroundColor: const Color.fromARGB(255, 255, 168, 0),
    );
  }

  Widget notificationViewList(){
    return Center(
      child: FutureBuilder<List<NotificationData>>(
        future: futureNoti,
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