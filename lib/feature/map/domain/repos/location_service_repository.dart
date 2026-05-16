
import 'package:latlong2/latlong.dart';

abstract class LocationServiceRepository {
  // 1. التحقق من أن الـ GPS مفتوح في الموبايل
  Future<bool> isLocationServiceEnabled();

  // 2. طلب إذن الوصول للموقع من المستخدم
  Future<bool> requestLocationPermission();

  // 3. جلب موقع الموبايل الحالي حالا
  Future<LatLng?> getCurrentDeviceLocation();

  // 4. تتبع موقع الموبايل الحالي كـ Stream أثناء الحركة (عشان الـ Live Tracking)
  Stream<LatLng> listenToDeviceLocationChanges();
}