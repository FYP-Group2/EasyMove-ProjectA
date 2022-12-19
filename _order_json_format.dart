class order_List_api {
  order_List_api({
    required this.result,
    required this.message,
    required this.order,
  });
  late final bool result;
  late final List<dynamic> message;
  late final Order order;

  order_List_api.fromJsonOrder(Map<String, dynamic> json) {
    result = json['result'];
    message = List.castFrom<dynamic, dynamic>(json['message']);
    order = Order.fromJsonOrder(json['order']);
  }

  Map<String, dynamic> _order_list() {
    final _data = <String, dynamic>{};
    _data['result'] = result;
    _data['message'] = message;
    _data['order'] = order._order_list_data();
    return _data;
  }
}

class Order {
  Order({
    required this.deadline,
    required this.scheduled,
    required this.zone,
    required this.requirement,
    required this.sid,
    required this.created,
    required this.accepted,
    required this.collected,
    required this.delivery,
    required this.time,
    required this.timeToDelivery,
    required this.branchName,
    required this.customerName,
    required this.phone,
    required this.address,
    required this.message,
    required this.pod,
    required this.oLat,
    this.oLon,
    required this.dLat,
    this.dLon,
    required this.diff,
    required this.cLat,
    required this.cLon,
  });
  late final String deadline;
  late final bool scheduled;
  late final String zone;
  late final String requirement;
  late final String sid;
  late final String created;
  late final String accepted;
  late final String collected;
  late final String delivery;
  late final String time;
  late final String timeToDelivery;
  late final String branchName;
  late final String customerName;
  late final String phone;
  late final String address;
  late final String message;
  late final String pod;
  late final String oLat;
  late final Null oLon;
  late final String dLat;
  late final Null dLon;
  late final double diff;
  late final int cLat;
  late final int cLon;

  Order.fromJsonOrder(Map<String, dynamic> json) {
    deadline = json['deadline'];
    scheduled = json['scheduled'];
    zone = json['zone'];
    requirement = json['requirement'];
    sid = json['sid'];
    created = json['created'];
    accepted = json['accepted'];
    collected = json['collected'];
    delivery = json['delivery'];
    time = json['time'];
    timeToDelivery = json['time_to_delivery'];
    branchName = json['branch_name'];
    customerName = json['customer_name'];
    phone = json['phone'];
    address = json['address'];
    message = json['message'];
    pod = json['pod'];
    oLat = json['o_lat'];
    oLon = null;
    dLat = json['d_lat'];
    dLon = null;
    diff = json['diff'];
    cLat = json['c_lat'];
    cLon = json['c_lon'];
  }

  Map<String, dynamic> _order_list_data() {
    final _data = <String, dynamic>{};
    _data['deadline'] = deadline;
    _data['scheduled'] = scheduled;
    _data['zone'] = zone;
    _data['requirement'] = requirement;
    _data['sid'] = sid;
    _data['created'] = created;
    _data['accepted'] = accepted;
    _data['collected'] = collected;
    _data['delivery'] = delivery;
    _data['time'] = time;
    _data['time_to_delivery'] = timeToDelivery;
    _data['branch_name'] = branchName;
    _data['customer_name'] = customerName;
    _data['phone'] = phone;
    _data['address'] = address;
    _data['message'] = message;
    _data['pod'] = pod;
    _data['o_lat'] = oLat;
    _data['o_lon'] = oLon;
    _data['d_lat'] = dLat;
    _data['d_lon'] = dLon;
    _data['diff'] = diff;
    _data['c_lat'] = cLat;
    _data['c_lon'] = cLon;
    return _data;
  }
}
