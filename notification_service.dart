import 'package:driver_integrated/notification_data.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:driver_integrated/db_helper.dart';
import 'package:driver_integrated/my_api_service.dart';
import 'package:driver_integrated/driver.dart';
import 'package:driver_integrated/notification_id.dart';
import 'dart:async';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  AndroidNotificationDetails androidPlatformChannelSpecifics = const AndroidNotificationDetails("12345", "asd",
    channelDescription: "asd",
    importance: Importance.high,
    priority: Priority.high,
  );
  Driver driver = Driver();
  DBHelper dbHelper = DBHelper();
  late Timer _timer;

  factory NotificationService() {
    return _instance;
  }

  NotificationService._internal();

  void start() async {
    _timer = Timer.periodic(const Duration(milliseconds: 10000), (timer) async {
      List<NotificationData> notifications = await MyApiService.fetchNoti(driver.id);
      List<NotificationID> notificationIds = await dbHelper.getNotifications();
      List<String> ids = [];
      for(var nId in notificationIds){
        ids.add(nId.id.toString());
      }

      for(var n in notifications){
        if(!ids.contains(n.id)){
          dbHelper.insertNotification(NotificationID(id: int.parse(n.id)));
          print("Inserted ID:${n.id}, Title:${n.title}, Message:${n.message}");
          show(n.title, n.message);
        }
      }

      print("periodic......");
    });
  }

  void stop() {
    if(_timer.isActive){
      _timer.cancel();
    }
  }

  Future<void> init() async {
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

  Future<void> show(String title, String body) async{
    NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        12345,
        title,
        body,
        platformChannelSpecifics,
        payload: 'data');
  }


  // Future selectNotification(String payload) async {
  //   //Handle notification tapped logic here
  // }

}