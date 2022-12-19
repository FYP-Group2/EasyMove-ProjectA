class MyOrder{
  int id;
  late String status;
  late String origin;
  late String destination;
  late double distance;
  late String createdTime;
  late String collectTime;
  late String deliverTime;
  late String branchName;
  late String customerName;
  late String phone;
  late String zone;
  late bool isAssigned;
  late String oLat;
  late String oLon;
  late String dLat;
  late String dLon;

  MyOrder(
      this.id,
      this.status,
      this.origin,
      this.destination,
      this.distance,
      this.createdTime,
      this.collectTime,
      this.deliverTime,
      this.branchName,
      this.customerName,
      this.phone,
      this.zone,
      this.isAssigned,
      this.oLat,
      this.oLon,
      this.dLat,
      this.dLon
    );

}