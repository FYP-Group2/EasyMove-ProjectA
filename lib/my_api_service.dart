import 'package:http/http.dart' as http;
import 'dart:convert';

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

    // print(response.statusCode);
    // print(response.body);
  }

  /// Function to get the id of orders. [uid] is id of driver.
  /// Use [status] of "new" to get id of new orders, "delivering" for orders in delivering process, "delivered" for delivered orders.
  static Future<List> getOrdersId(int uid, String status) async {
    String url = "awcgroup.com.my";
    String unencodedPath = "/easymovenpick.com/api/driver_orders.php";
    final Map<String, String> body = {"uid": "$uid"};
    final response = await http.post(Uri.http(url, unencodedPath), body: body);
    final data = json.decode(response.body);
    //print(data);

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
    for(var element in data["driver_orders"]["orders"][orderStatus]){
      ids.add(element["id"]);
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
    print(data["order"]);

    return data["order"];
  }

}