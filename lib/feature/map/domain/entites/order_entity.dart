import 'package:latlong2/latlong.dart';

// الـ Enum بيحمينا من كتابة الكلمات غلط جوه الكود
enum OrderStatus { active, delivered, pending }

class OrderEntity {
  final String orderId;
  final OrderStatus status;
  final String orderType;
  final LatLng pickupLocation;
  final LatLng deliveryLocation;
  final LatLng? currentCourierLocation; // Nullable عشان لو لسه مفيش مندوب استلم الطلب

  OrderEntity({
    required this.orderId,
    required this.status,
    required this.orderType,
    required this.pickupLocation,
    required this.deliveryLocation,
    this.currentCourierLocation,
  });

  // ✅ إضافة الـ Getters دي لتوجيه الـ UI لقراءة مكان التسليم مباشرة وتصفي الإيرورز
  double get lat => deliveryLocation.latitude;
  double get lng => deliveryLocation.longitude;
}