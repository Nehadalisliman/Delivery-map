
// 1. حالة جلب بيانات المستخدم
import '../entites/courier_entity.dart';
import '../entites/order_entity.dart';
import '../entites/user_entity.dart';
import '../repos/map_repository.dart';

class GetUserDataUseCase {
  final MapRepository repository;
  GetUserDataUseCase(this.repository);

  Future<UserEntity> call(String uid) async {
    return await repository.getUserData(uid);
  }
}

// 2. حالة تتبع الطلبات النشطة لايف
class StreamActiveOrdersUseCase {
  final MapRepository repository;
  StreamActiveOrdersUseCase(this.repository);

  Stream<List<OrderEntity>> call() {
    return repository.getActiveOrdersLive();
  }
}

// 3. حالة تتبع الكباتن المتاحين لايف
class StreamAvailableCouriersUseCase {
  final MapRepository repository;
  StreamAvailableCouriersUseCase(this.repository);

  Stream<List<CourierEntity>> call() {
    return repository.getAvailableCouriersLive();
  }
}

// 4. حالة تحديث موقع المستخدم في الفايربيز
class UpdateUserLocationUseCase {
  final MapRepository repository;
  UpdateUserLocationUseCase(this.repository);

  Future<void> call(String uid, double lat, double lng) async {
    await repository.updateUserLocation(uid, lat, lng);
  }
}