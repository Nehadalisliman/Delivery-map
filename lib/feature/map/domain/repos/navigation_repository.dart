
import 'package:latlong2/latlong.dart';

abstract class NavigationRepository {
  // 1. رسم المسار: نرسل له نقطة البداية والنهاية ويعود لنا بقائمة إحداثيات لرسم الـ Polyline
  Future<List<LatLng>> getRoutePoints(LatLng start, LatLng end);

  // 2. البحث عن الأماكن (Geocoding): نرسل له نصاً (اسم المكان) ويعود لنا بإحداثياته الجغرافية
  Future<LatLng?> searchLocationByName(String query);
}