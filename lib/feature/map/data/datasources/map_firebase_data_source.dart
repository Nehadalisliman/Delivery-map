import 'package:cloud_firestore/cloud_firestore.dart';

class MapFirebaseDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 1. جلب مستند مستخدم معين
  Future<DocumentSnapshot> getUserDocument(String uid) async {
    return await _firestore.collection('users').doc(uid).get();
  }

  // 2. تتبع الطلبات النشطة لايف
  Stream<QuerySnapshot> streamActiveOrders() {
    return _firestore
        .collection('orders')
        .where('status', isEqualTo: 'active')
        .snapshots();
  }

  // 3. تتبع المناديب المتاحين لايف
  Stream<QuerySnapshot> streamAvailableCouriers() {
    return _firestore
        .collection('couriers')
        .where('is_available', isEqualTo: true)
        .snapshots();
  }

  // 4. تحديث موقع مستخدم
  Future<void> updateUserGeoPoint(String uid, double lat, double lng) async {
    await _firestore.collection('users').doc(uid).update({
      'last_location': GeoPoint(lat, lng),
    });
  }
}