import 'package:flutter/material.dart';
import 'package:notification/notification_data.dart';

class NotificationDetailPage extends StatelessWidget {
  const NotificationDetailPage({super.key, required this.notificationData});
  final NotificationData notificationData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          notificationData.title,
        ),
        backgroundColor: Colors.orange,
      ),
      body: Container(
        margin: const EdgeInsets.only(left:40, top:20, right:0, bottom:0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget> [
            Text(
              notificationData.date,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            Text(
              notificationData.message,
              style: const TextStyle(
                fontSize: 25,
              ),
            ),
          ],
        ),
      )
    );
  }
}