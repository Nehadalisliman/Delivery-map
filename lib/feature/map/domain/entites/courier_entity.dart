import 'package:latlong2/latlong.dart';

class CourierEntity {
  final String courierId;
  final String courierName;
  final bool isAvailable;
  final LatLng position; // الإحداثيات الأساسية كـ LatLng

  CourierEntity({
    required this.courierId,
    required this.courierName,
    required this.isAvailable,
    required this.position,
  });

  // ✅ إضافة الـ Getters دي لتصفير إيرورز الـ map_page فوراً
  double get lat => position.latitude;
  double get lng => position.longitude;
}