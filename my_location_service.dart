import 'package:geolocator/geolocator.dart';
import 'package:cron/cron.dart';
import 'package:http/http.dart' as http;

class MyLocationService{
  static final MyLocationService _instance = MyLocationService._internal();
  final List<Position> _positions = <Position>[];
  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
  final Cron _cron = Cron();
  late ScheduledTask _scheduledTask;
  late int driverId;

  MyLocationService._internal();

  factory MyLocationService(int driverId){
    _instance.driverId = driverId;
    return _instance;
  }

  /// Start the automatic update of location every 1 minute.
  Future<void> start() async {
    final hasPermission = await _handlePermission();
    if (!hasPermission) {
      return;
    }
    _scheduledTask = _cron.schedule(Schedule.parse('* * * * *'), () => _updatePosition());
  }

  /// Stop automatic update of location.
  void stop(){
    _scheduledTask.cancel();
  }

  /// Get the latest recorded position.
  Position? getLastKnownPosition(){
    if(_positions.isNotEmpty) {
      return _positions.last;
    }
    return null;
  }

  /// Get the current position.
  Future<Position> getCurrentPosition() async {
    final position = await _geolocatorPlatform.getCurrentPosition();
    return position;
  }

  /// Get the list of recorded positions.
  List<Position> getPositions(){
    return _positions;
  }

  /// Calculate and return the distance between the specified start point and end point in meters.
  /// [startLat] and [startLong] are latitude and longitude of start point.
  /// [endLat] and [endLong] are latitude and longitude of end point.
  double distanceInMeter(double startLat, double startLong, double endLat, double endLong){
    return _geolocatorPlatform.distanceBetween(startLat, startLong, endLat, endLong);
  }

  /// Get the current position, record it to the list of known positions,
  /// and update the location to database through website API
  Future<void> _updatePosition() async {
    final position = await _geolocatorPlatform.getCurrentPosition();
    _positions.add(position);
    _locationAPI(position);
  }

  /// Update the location to database through website API
  void _locationAPI(Position position) async {
    final String strPosition = "$position,placeholder";
    const String url = "awcgroup.com.my";
    const String unencodedPath = "/easymovenpick.com/api/location.php";
    final Map<String, String> body = {"uid" : "$driverId",
      "location": strPosition};

    await http.post(
        Uri.http(url, unencodedPath),
        body: body
    );
  }

  /// Handle permission for location service
  Future<bool> _handlePermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await _geolocatorPlatform.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    permission = await _geolocatorPlatform.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await _geolocatorPlatform.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

}