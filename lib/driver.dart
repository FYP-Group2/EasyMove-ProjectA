class Driver{
  static final Driver _instance = Driver._internal();
  late int id;
  late int region;
  late int vehicleType;
  late String name;
  String status = "off";

  Driver._internal();

  factory Driver(){
    return _instance;
  }

  void initializeDriver(int id, int region, int vehicleType, String name){
    this.id = id;
    this.region = region;
    this.vehicleType = vehicleType;
    this.name = name;
  }

}