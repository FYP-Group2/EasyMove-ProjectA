import 'package:dio/dio.dart';
import 'dart:io';
import 'package:driver_integrated/notification_data.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:convert';

import 'package:image_picker/image_picker.dart';

class MyApiService{

  /// Function to update status of order. [uid] is id of driver, [oid] is id of order to be updated.
  /// Use [action] of "decline" for driver declining an assigned order, "report" for driver collecting order at no Internet area,
  /// "accept" for driver accepting a new order, "collect" for driver collecting order, "pod" for driver delivered an order.
  static void updateOrder(int uid, int oid, String action) async{
    const String url = "awcgroup.com.my";
    const String unencodedPath = "/easymovenpick.com/api/update_order.php";
    final Map<String, String> body = {"uid" : "$uid",
                                      "oid" : "$oid",
                                      "action" : action};

    final response = await http.post(
      Uri.http(url, unencodedPath),
      body: body
    );

    print(response.statusCode);
    print(response.body);
  }

  /// Function to get the id of orders. [uid] is id of driver.
  /// Use [status] of "new" to get id of new orders, "delivering" for orders in delivering process, "delivered" for delivered orders.
  static Future<List> getOrdersId(int uid, String status) async {
    String url = "awcgroup.com.my";
    String unencodedPath = "/easymovenpick.com/api/driver_orders.php";
    final Map<String, String> body = {"uid": "$uid"};
    final response = await http.post(Uri.http(url, unencodedPath), body: body);
    final data = json.decode(response.body);

    String orderStatus = "";
    switch (status){
      case "new":
        orderStatus = "news";
        break;
      case "delivering":
        orderStatus = "delivers";
        break;
      case "delivered":
        orderStatus = "delivereds";
        break;
      default:
        orderStatus = "news";
        break;
    }
    List ids = [];
    if(data["driver_orders"]["orders"][orderStatus] != null) {
      for (var element in data["driver_orders"]["orders"][orderStatus]) {
        ids.add(element["id"]);
      }
    }
    return ids;
  }

  /// Function to get details of order by specifying the id of order, [oid]
  static Future<Map<String, dynamic>> getOrder(int oid) async{
    const String url = "awcgroup.com.my";
    const String unencodedPath = "/easymovenpick.com/api/driver_order.php";
    final Map<String, String> body = {"oid" : "$oid"};
    final response = await http.post(Uri.http(url, unencodedPath), body: body);
    final data = json.decode(response.body);
    //print(data["order"]);

    return data["order"];
  }

  static void photoPOD(int oid, String filePath) async{
    const String url = "https://awcgroup.com.my/easymovenpick.com/api/post_photo.php";

    Map<String, dynamic> map = Map();
    map["pod"] = await MultipartFile.fromFile(filePath, filename: "pod_image.jpeg", contentType: MediaType("image", "jpeg"));
    map["oid"] = "$oid";
    FormData formData = FormData.fromMap(map);
    await Dio().post(url, data: formData).then((value){
      print("response: $value");
    });
  }

  static Future<List> getRegions() async{
    Map<String, int> regionMap = {};
    List<String> regionList = [];
    const String url = "awcgroup.com.my";
    const String unencodedPath = "/easymovenpick.com/api/regions.php";
    final response = await http.post(Uri.http(url, unencodedPath));
    final data = json.decode(response.body);
    print(data);

    List elements = data["options"];
    for(var e in elements){
      Map<String, int> region = {e["label"] : e["value"]};
      regionMap.addAll(region);
      regionList.add(e["label"]);
    }

    List regions = [regionMap, regionList];
    return regions;
  }

  static Future<List> getVehicles() async{
    Map<String, int> vehicleMap = {};
    List<String> vehicleList = [];
    const String url = "awcgroup.com.my";
    const String unencodedPath = "/easymovenpick.com/api/vehicle_types.php";
    final response = await http.post(Uri.http(url, unencodedPath));
    final data = json.decode(response.body);
    print(data);

    List elements = data["options"];
    for(var e in elements){
      Map<String, int> vehicle = {e["label"] : e["value"]};
      vehicleMap.addAll(vehicle);
      vehicleList.add(e["label"]);
    }

    List vehicles = [vehicleMap, vehicleList];
    return vehicles;
  }

  static Future<Map<String, dynamic>> getMeritStatement(String userId) async {
    const String url = "awcgroup.com.my";
    const String unencodedPath = "/easymovenpick.com/api/merit_statement.php";
    final Map<String, String> body = {'uid':userId};
    final response = await http.post(
        Uri.http(url,unencodedPath),
        // headers: header,
        body: body
    );
    final meritData = json.decode(response.body);
    return meritData;
  }

  static Future<Map<String, dynamic>> getCommissionStatement(String userId) async {
    const String url = "awcgroup.com.my";
    const String unencodedPath = "/easymovenpick.com/api/commission_statement.php";
    final Map<String, String> body = {'uid':userId};
    final response = await http.post(
        Uri.http(url, unencodedPath),
        body: body
    );
    final walletData = json.decode(response.body);
    return walletData;
  }

  static void updateDriverOnOff(int driverId, String onOff) async {
    const String url = "awcgroup.com.my";
    const String unencodedPath = "/easymovenpick.com/api/driver_on_off.php";
    final Map<String,String> body = {'uid': "$driverId", 'onoff': onOff};
    final response = await http.post(
        Uri.http(url,unencodedPath),
        body: body
    );
    print(response.statusCode);
    print(response.body);
  }

  static Future<List<NotificationData>> fetchNoti(int driverId) async {
    const String url = "awcgroup.com.my";
    const String unencodedPath = "/easymovenpick.com/api/notification_statement.php";
    final Map<String, String> body = ({'uid': "$driverId"});
    final response = await http.post(
        Uri.http(url, unencodedPath),
        body: body
    );

    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data.map((data) => NotificationData.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load notification');
    }
  }

}