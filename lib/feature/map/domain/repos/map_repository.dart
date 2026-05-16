

import '../entites/courier_entity.dart';
import '../entites/order_entity.dart';
import '../entites/user_entity.dart';

abstract class MapRepository {
  // 1. جلب بيانات اليوزر الحالي (الاسم وعدد طلباته النشطة ليعرض في الـ Header فوق)
  Future<UserEntity> getUserData(String uid);

  // 2. تتبع الطلبات النشطة لايف (Stream) عشان الكراتين والماركرز تظهر وتتحرك لحظياً
  Stream<List<OrderEntity>> getActiveOrdersLive();

  // 3. تتبع المناديب المتاحين والقريبين في المنطقة لايف (Stream)
  Stream<List<CourierEntity>> getAvailableCouriersLive();

  // 4. تحديث موقع المستخدم الحالي في الفايربيز عندما يتحرك في الواقع
  Future<void> updateUserLocation(String uid, double lat, double lng);
}