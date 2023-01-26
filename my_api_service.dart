import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:driver_integrated/notification_data.dart';

DateTime now = DateTime.now();
String year = DateTime(now.year).toString();
String month = DateTime(now.month).toString();
const String url = "easysuperapps.com";
const String photoUrl = "https://easysuperapps.com//easysuperapps.com/api/post_photo.php/post_photo.php";

class MyApiService{

  /// Function to update status of order. [uid] is id of driver, [oid] is id of order to be updated.
  /// Use [action] of "decline" for driver declining an assigned order, "report" for driver collecting order at no Internet area,
  /// "accept" for driver accepting a new order, "collect" for driver collecting order, "pod" for driver delivered an order.
  static void updateOrder(int uid, int oid, String action) async{
    const String unencodedPath = "/easysuperapps.com/api/update_order.php/update_order.php";
    final Map<String, String> body = {"uid" : "$uid",
                                      "oid" : "$oid",
                                      "action" : action};

    await http.post(
      Uri.http(url, unencodedPath),
      body: body
    );

  }

  /// Function to get the id of orders. [uid] is id of driver.
  /// Use [status] of "new" to get id of new orders, "delivering" for orders in delivering process, "delivered" for delivered orders.
  static Future<List> getOrdersId(int uid, String status) async {
    String unencodedPath = "/easysuperapps.com/api/driver_orders.php/driver_orders.php";
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
      case "collecting":
        orderStatus = "collects";
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
    const String unencodedPath = "/easysuperapps.com/api/driver_order.php/driver_order.php";
    final Map<String, String> body = {"oid" : "$oid"};
    final response = await http.post(Uri.http(url, unencodedPath), body: body);
    final data = json.decode(response.body);

    return data["order"];
  }

  static void photoRegister(String username, String icPath, String licensePath, String frontVehiclePath, String backVehiclePath) async{
    Map<String, dynamic> map = {};
    map["username"] = username;
    map["ic"] = await MultipartFile.fromFile(icPath, filename: "ic.jpeg", contentType: MediaType("image", "jpeg"));
    map["license"] = await MultipartFile.fromFile(licensePath, filename: "license.jpeg", contentType: MediaType("image", "jpeg"));
    map["front"] = await MultipartFile.fromFile(frontVehiclePath, filename: "front.jpeg", contentType: MediaType("image", "jpeg"));
    map["back"] = await MultipartFile.fromFile(backVehiclePath, filename: "back.jpeg", contentType: MediaType("image", "jpeg"));
    FormData formData = FormData.fromMap(map);
    await Dio().post(photoUrl, data: formData);
  }

  static void photoPOD(int oid, String filePath) async{
    Map<String, dynamic> map = {};
    map["pod"] = await MultipartFile.fromFile(filePath, filename: "pod_image.jpeg", contentType: MediaType("image", "jpeg"));
    map["oid"] = "$oid";
    FormData formData = FormData.fromMap(map);
    final response = await Dio().post(photoUrl, data: formData);
  }

  static void photoPOC(int oid, String filePath) async{
    Map<String, dynamic> map = {};
    map["poc"] = await MultipartFile.fromFile(filePath, filename: "pod_image.jpeg", contentType: MediaType("image", "jpeg"));
    map["oid"] = "$oid";
    FormData formData = FormData.fromMap(map);
    final response = await Dio().post(photoUrl, data: formData);
  }

  static Future<List> getRegions() async{
    Map<String, int> regionMap = {};
    List<String> regionList = [];
    const String unencodedPath = "/easysuperapps.com/api/regions.php/regions.php";
    final response = await http.post(Uri.http(url, unencodedPath));
    final data = json.decode(response.body);

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
    const String url = "https://easysuperapps.com//easysuperapps.com/api/vehicle_types.php/vehicle_types.php";
    final response = await Dio().post(url);
    final data = json.decode(response.toString());

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
    const String unencodedPath = "/easysuperapps.com/api/merit_statement.php/merit_statement.php";
    final Map<String, String> body = {'uid':userId};
    final response = await http.post(
        Uri.http(url,unencodedPath),
        body: body
    );
    final meritData = json.decode(response.body);
    return meritData;
  }

  static Future<Map<String, dynamic>> getCommissionStatement(String userId) async {
    const String unencodedPath = "/easysuperapps.com/api/commission_statement.php/commission_statement.php";
    final Map<String, String> body = {'uid':userId};
    final response = await http.post(
        Uri.http(url, unencodedPath),
        body: body
    );
    final walletData = json.decode(response.body);
    return walletData;
  }

  static Future<void> updateDriverOnOff(int driverId, String onOff) async {
    const String unencodedPath = "/easysuperapps.com/api/driver_on_off.php/driver_on_off.php";
    final Map<String,String> body = {'uid': "$driverId", 'onoff': onOff};
    await http.post(
        Uri.http(url,unencodedPath),
        body: body
    );
  }

  static Future<List<NotificationData>> fetchNoti(int driverId, String year, String month) async {
    const String unencodedPath = "/easysuperapps.com/api/notification_statement.php/notification_statement.php";
    final Map<String, String> body = ({'uid': "$driverId", 'year': year, 'month': month});
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

  static Future<bool> driverApply(Map<String, String> body) async{
    const String unencodedPath = "/easysuperapps.com/api/driver_apply.php/driver_apply.php";
    final response = await http.post(
        Uri.http(url, unencodedPath),
        body: body
    );

    final data = json.decode(response.body);
    bool result = data["application"]["result"];
    return result;
  }

  static Future<Map<String, dynamic>> driverLogIn(Map<String, String> body) async {
    const String unencodedPath = "/easysuperapps.com/api/driver_login.php/driver_login.php";
    final response = await http.post(
        Uri.http(url, unencodedPath),
        body: body
    );

    final data = json.decode(response.body);
    return data;

  }

  static Future<Map<String, dynamic>> getDriverId(String username) async {
    final Map<String, String> body = {"username": username};
    const String unencodedPath = "/easysuperapps.com/api/driver_id.php/driver_id.php";
    final response = await http.post(
        Uri.http(url, unencodedPath),
        body: body
    );

    final data = json.decode(response.body);
    return data;

  }

  static Future<void> updateToken(int driverId, String token) async {
    const String unencodedPath = "/easysuperapps.com/api/insert_token.php/insert_token.php";
    final Map<String, String> body = ({'uid': "$driverId", 'token': token});
    await http.post(
        Uri.http(url, unencodedPath),
        body: body
    );

  }

  static void updateLocation(String position, int driverId) async {
    const String unencodedPath = "/easysuperapps.com/api/location.php/location.php";
    final Map<String, String> body = {
      "uid" : "$driverId",
      "location": position
    };

    await http.post(
        Uri.http(url, unencodedPath),
        body: body
    );
  }

  static Future<bool> convertMerit(int driverId) async {
    const String unencodedPath = "/easysuperapps.com/api/convert_merit.php/convert_merit.php";
    final Map<String, String> body = {
      'uid': "$driverId",
    };

    final response = await http.post(Uri.http(url, unencodedPath), body: body);
    final data = json.decode(response.body);
    bool success = (data["result"]);
    return success;
  }

  static Future<String> requestWithdraw(Map<String, String> body) async{
    const String unencodedPath = "/easysuperapps.com/api/request_withdraw.php/request_withdraw.php";
    final response = await http.post(Uri.http(url, unencodedPath), body: body);
    final data = json.decode(response.body);
    print(data["message"]);
    return (data["message"]);

  }

  static Future<Map<String, dynamic>> getNews() async {
    const String unencodedPath = "/easysuperapps.com/api/get_news.php/get_news.php";
    final response = await http.post(
        Uri.http(url, unencodedPath)
    );
    final data = json.decode(response.body);
    print(data);
    return (data);
  }

}