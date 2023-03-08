import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FirebaseService{
  static final FirebaseService _instance = FirebaseService._internal();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  AndroidNotificationDetails androidPlatformChannelSpecifics = const AndroidNotificationDetails("12345", "asd",
    channelDescription: "asd",
    importance: Importance.high,
    priority: Priority.high,
  );
  DarwinNotificationDetails iosNotificationDetail = const DarwinNotificationDetails();
  late String? fcmToken;

  FirebaseService._internal();

  factory FirebaseService() {
    return _instance;
  }

  String getFcmToken(){
    return fcmToken ?? "No token";
  }

  Future<void> initialize() async {
    await FirebaseMessaging.instance.getToken().then((value) {
      fcmToken = value;
    });

    FirebaseMessaging.instance.onTokenRefresh.listen((event) {

    }).onError((error){

    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async{
      await FlutterAppBadger.isAppBadgeSupported().then((value) => value?FlutterAppBadger.updateBadgeCount(1):null);
      show(message.data["title"], message.data["body"]);
    });

    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings("@mipmap/ic_launcher");
    const initializationSettingsIOS = DarwinInitializationSettings();
    const InitializationSettings initializationSettings =
    InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
        macOS: null);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );

  }

  void show(String title, String body) async{
    NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics, iOS: iosNotificationDetail);
    await flutterLocalNotificationsPlugin.show(
        Random().nextInt(10000),
        title,
        body,
        platformChannelSpecifics,
        payload: 'data');
  }

}