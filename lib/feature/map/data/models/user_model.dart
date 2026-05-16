import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart';

import '../../domain/entites/user_entity.dart';


class UserModel extends UserEntity {
  UserModel({
    required super.uid,
    required super.name,
    required super.activeOrdersCount,
    required super.lastLocation,
  });

  // الميثود اللي بتقرأ من الـ Document اللي عملته في فايربيز
  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};

    // سحب الـ GeoPoint بأمان عشان لو الحقل مش موجود ما يضربش كراش
    final GeoPoint geoPoint = data['last_location'] ?? const GeoPoint(0, 0);

    return UserModel(
      uid: doc.id,
      name: data['name'] ?? '',
      activeOrdersCount: (data['active_orders_count'] ?? 0) as int,
      lastLocation: LatLng(geoPoint.latitude, geoPoint.longitude),
    );
  }

  // ميثود اختيارية لو حبيت تحول الـ Object لـ Map عشان ترفعه لفايربيز بعدين
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'active_orders_count': activeOrdersCount,
      'last_location': GeoPoint(lastLocation.latitude, lastLocation.longitude),
    };
  }
}