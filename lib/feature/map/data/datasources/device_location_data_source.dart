
import 'package:location/location.dart';

class DeviceLocationDataSource {
  final Location _locationService = Location();

  // 1. تشغيل والتحقق من الـ GPS Service في الهاتف
  Future<bool> isServiceEnabled() async {
    bool serviceEnabled = await _locationService.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _locationService.requestService();
    }
    return serviceEnabled;
  }

  // 2. طلب Permission الموقع من نظام الموبايل (Android / iOS)
  Future<bool> checkAndRequestPermission() async {
    PermissionStatus permissionGranted = await _locationService.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _locationService.requestPermission();
    }
    return permissionGranted == PermissionStatus.granted;
  }

  // 3. جلب اللوكيشن الحالي حالا
  Future<LocationData> getLocation() async {
    return await _locationService.getLocation();
  }

  // 4. عمل Stream يراقب حركة الموبايل لايف في الشارع
  Stream<LocationData> get liveLocationStream => _locationService.onLocationChanged;
}