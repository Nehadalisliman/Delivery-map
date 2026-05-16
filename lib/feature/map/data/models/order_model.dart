import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart';

import '../../domain/entites/order_entity.dart'; // تأكد من مطابقة اسم الفولدر entities عندك

class OrderModel extends OrderEntity {
  OrderModel({
    required super.orderId,
    required super.status,
    required super.orderType,
    required super.pickupLocation,
    required super.deliveryLocation,
    super.currentCourierLocation,
  });

  factory OrderModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};

    // 1. تحويل النص لـ Enum بأمان
    OrderStatus orderStatus;
    switch (data['status']) {
      case 'delivered':
        orderStatus = OrderStatus.delivered;
        break;
      case 'pending':
        orderStatus = OrderStatus.pending;
        break;
      default:
        orderStatus = OrderStatus.active;
    }

    // 2. ترجمة الـ GeoPoints لـ LatLng بأمان مع التحقق من الـ Types
    final GeoPoint pickupGeo = data['pickup_location'] is GeoPoint
        ? data['pickup_location'] as GeoPoint
        : const GeoPoint(0, 0);

    final GeoPoint deliveryGeo = data['delivery_location'] is GeoPoint
        ? data['delivery_location'] as GeoPoint
        : const GeoPoint(0, 0);

    // المندوب ممكن يكون لسه ما استلمش الشحنة فالقيمة Nullable
    final GeoPoint? courierGeo = data['current_courier_location'] is GeoPoint
        ? data['current_courier_location'] as GeoPoint
        : null;

    return OrderModel(
      orderId: doc.id,
      status: orderStatus,
      orderType: data['order_type'] ?? 'package',
      pickupLocation: LatLng(pickupGeo.latitude, pickupGeo.longitude),
      deliveryLocation: LatLng(deliveryGeo.latitude, deliveryGeo.longitude),
      currentCourierLocation: courierGeo != null
          ? LatLng(courierGeo.latitude, courierGeo.longitude)
          : null,
    );
  }

  // ميثود لتحويل الكائن لـ Map لو حابب ترفع طلب جديد للفايربيز مستقبلاً
  Map<String, dynamic> toFirestore() {
    return {
      'status': status.name, // بيحول الـ Enum لـ String تلقائياً (active, delivered, pending)
      'order_type': orderType,
      'pickup_location': GeoPoint(pickupLocation.latitude, pickupLocation.longitude),
      'delivery_location': GeoPoint(deliveryLocation.latitude, deliveryLocation.longitude),
      'current_courier_location': currentCourierLocation != null
          ? GeoPoint(currentCourierLocation!.latitude, currentCourierLocation!.longitude)
          : null,
    };
  }
}