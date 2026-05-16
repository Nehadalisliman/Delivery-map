
import 'package:latlong2/latlong.dart';

class UserEntity {
  final String uid;
  final String name;
  final int activeOrdersCount;
  final LatLng lastLocation; // استخدمنا LatLng من package:latlong2 لأنها النقاء البرمجي للخريطة

  UserEntity({
    required this.uid,
    required this.name,
    required this.activeOrdersCount,
    required this.lastLocation,
  });
}