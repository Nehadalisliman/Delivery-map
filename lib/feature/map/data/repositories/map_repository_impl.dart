import '../../domain/entites/courier_entity.dart';
import '../../domain/entites/order_entity.dart';
import '../../domain/entites/user_entity.dart';
import '../../domain/repos/map_repository.dart';
import '../datasources/map_firebase_data_source.dart';
import '../models/courier_model.dart';
import '../models/order_model.dart';
import '../models/user_model.dart';

class MapRepositoryImpl implements MapRepository {
  final MapFirebaseDataSource _firebaseDataSource;

  MapRepositoryImpl({required MapFirebaseDataSource firebaseDataSource})
      : _firebaseDataSource = firebaseDataSource;

  @override
  Future<UserEntity> getUserData(String uid) async {
    final docSnapshot = await _firebaseDataSource.getUserDocument(uid);
    return UserModel.fromFirestore(docSnapshot);
  }

  @override
  Stream<List<OrderEntity>> getActiveOrdersLive() {
    return _firebaseDataSource.streamActiveOrders().map((querySnapshot) {
      return querySnapshot.docs
          .map((doc) => OrderModel.fromFirestore(doc))
          .toList();
    });
  }

  @override
  Stream<List<CourierEntity>> getAvailableCouriersLive() {
    return _firebaseDataSource.streamAvailableCouriers().map((querySnapshot) {
      return querySnapshot.docs
          .map((doc) => CourierModel.fromFirestore(doc))
          .toList();
    });
  }

  @override
  Future<void> updateUserLocation(String uid, double lat, double lng) async {
    await _firebaseDataSource.updateUserGeoPoint(uid, lat, lng);
  }
}