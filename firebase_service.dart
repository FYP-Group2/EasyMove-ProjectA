import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FirebaseService{
  static final FirebaseService _instance = FirebaseService._internal();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  AndroidNotificationDetails androidPlatformChannelSpecifics = const AndroidNotificationDetails("12345", "asd",
    channelDescription: "asd",
    importance: Importance.high,
    priority: Priority.high,
  );
  late String? fcmToken;

  FirebaseService._internal();

  factory FirebaseService() {
    return _instance;
  }

  String getFcmToken(){
    return fcmToken ?? "No token";
  }

  Future<void> initialize() async {
    fcmToken = await FirebaseMessaging.instance.getToken();
    FirebaseMessaging.instance.onTokenRefresh.listen((event) {

    }).onError((error){

    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // print('Got a message whilst in the foreground!');
      // print('Message data: ${message.data}');
      show(message.data["title"], message.data["body"]);
    });

    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings("@mipmap/ic_launcher");

    const InitializationSettings initializationSettings =
    InitializationSettings(
        android: initializationSettingsAndroid,
        macOS: null);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      //onSelectNotification: selectNotification
    );

  }

  void show(String title, String body) async{
    NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        Random().nextInt(10000),
        title,
        body,
        platformChannelSpecifics,
        payload: 'data');
  }

}