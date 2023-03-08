class MyOrderDetails {
  int id;
  late String status;
  late String origin;
  late String destination;
  late double o_coor;
  late double d_coor;
  late double distance;
  late String collectTime;
  late String deliverTime;

  MyOrderDetails(
      this.id,
      this.status,
      this.origin,
      this.destination,
      this.o_coor,
      this.d_coor,
      this.distance,
      this.collectTime,
      this.deliverTime);
}