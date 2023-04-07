import 'package:flutter/material.dart';
import 'notification_data.dart';

class NotificationDetailPage extends StatelessWidget {
  const NotificationDetailPage({super.key, required this.notificationData});
  final NotificationData notificationData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.black, //change your color here
            size: 35,
          ),
          elevation: 0,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(16.0),
            child: Container(
              color: Colors.orangeAccent,
              height: 4.0,
            ),
          ),
          centerTitle: true,
          title: Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: Text(
              notificationData.title,
              style: TextStyle(color: Colors.black, fontSize: 25.0),

            ),
          ),
          backgroundColor: Colors.white,
        ),
        body: Container(
          margin: const EdgeInsets.only(left:40, top:40, right:40, bottom:0),

          child: Column(
            children: <Widget> [
              Align(
                alignment: Alignment.topRight,
                child: Text(
                  notificationData.date,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Positioned(
                child: Text(
                  notificationData.message,
                  style: const TextStyle(
                    fontSize: 25,
                  ),
                ),
              ),
            ],
          ),
        )
    );
  }
}