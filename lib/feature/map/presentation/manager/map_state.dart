

import 'package:latlong2/latlong.dart';

import '../../domain/entites/courier_entity.dart';
import '../../domain/entites/order_entity.dart';
import '../../domain/entites/user_entity.dart';

abstract class MapState {}

// 1. الحالة الابتدائية
class MapInitial extends MapState {}

// 2. حالة التحميل (أول ما نفتح الصفحة)
class MapLoading extends MapState {}

// 3. حالة الفشل في الحصول على إذن اللوكيشن أو الـ GPS مقفول
class MapPermissionDenied extends MapState {}

// 4. الحالة الناجحة الأساسية (تحمل كل البيانات اللايف)
class MapSuccess extends MapState {
  final UserEntity user;
  final List<OrderEntity> orders;
  final List<CourierEntity> couriers;
  final LatLng currentDeviceLocation;
  final List<LatLng> routePoints;
  final LatLng? searchedLocation;

  MapSuccess({
    required this.user,
    required this.orders,
    required this.couriers,
    required this.currentDeviceLocation,
    this.routePoints = const [],
    this.searchedLocation,
  });

  // ميثود لتحديث أجزاء من الـ State مع الحفاظ على الباقي أثناء تدفق الـ Streams
  MapSuccess copyWith({
    UserEntity? user,
    List<OrderEntity>? orders,
    List<CourierEntity>? couriers,
    LatLng? currentDeviceLocation,
    List<LatLng>? routePoints,
    LatLng? searchedLocation,
  }) {
    return MapSuccess(
      user: user ?? this.user,
      orders: orders ?? this.orders,
      couriers: couriers ?? this.couriers,
      currentDeviceLocation: currentDeviceLocation ?? this.currentDeviceLocation,
      routePoints: routePoints ?? this.routePoints,
      searchedLocation: searchedLocation ?? this.searchedLocation,
    );
  }
}

// 5. حالة حدوث خطأ غير متوقع
class MapError extends MapState {
  final String message;
  MapError(this.message);
}
