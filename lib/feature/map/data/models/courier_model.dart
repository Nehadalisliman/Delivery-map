import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart';

import '../../domain/entites/courier_entity.dart'; // تأكد من صحة الحروف الإملائية لـ entities في مشروعك

class CourierModel extends CourierEntity {
  CourierModel({
    required super.courierId,
    required super.courierName,
    required super.isAvailable,
    required super.position,
  });

  factory CourierModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};

    // لقطة ذكية: قراءة الـ GeoPoint بأمان والتعامل معها لو كانت Null في السيرفر
    final GeoPoint geoPoint = data['position'] is GeoPoint
        ? data['position'] as GeoPoint
        : const GeoPoint(0, 0);

    return CourierModel(
      courierId: doc.id,
      courierName: data['courier_name'] ?? '',
      isAvailable: data['is_available'] ?? false,
      // تحويل الـ GeoPoint القادمة من الفايربيز إلى كائن LatLng ليفهمه الـ Entity والـ UI
      position: LatLng(geoPoint.latitude, geoPoint.longitude),
    );
  }

  // ميثود إضافية اختيارية لو حابب ترفع داتا من التطبيق للفايربيز مستقبلاً
  Map<String, dynamic> toFirestore() {
    return {
      'courier_name': courierName,
      'is_available': isAvailable,
      'position': GeoPoint(position.latitude, position.longitude),
    };
  }
}