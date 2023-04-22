import 'dart:async';
import 'package:flutter/material.dart';
import 'package:driver_integrated/notification_data.dart';
import 'package:driver_integrated/driver.dart';
import 'package:driver_integrated/my_api_service.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:driver_integrated/notification_detail.dart';

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
  void initState() {
    super.initState();
    futureNoti = MyApiService.fetchNoti(driver.id, now.year.toString(), now.month.toString(), driver.jwtToken);
    iniBadger();
  }

  void iniBadger() async{
    await FlutterAppBadger.isAppBadgeSupported().then((value) => value?FlutterAppBadger.removeBadge():null);
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
                  child: Text("Notification", style: TextStyle(fontSize: 30.0, color: Colors.black),),
                ),
              ],
            ),
          )
      ),
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
                      onTap: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => NotificationDetailPage(notificationData: snapshot.data[index],)
                            )
                        );
                      }
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
            return const Text('No notification', style: TextStyle(fontSize: 24),);
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}