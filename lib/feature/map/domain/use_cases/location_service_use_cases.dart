

// 1. حالة التحقق من تفعيل الـ GPS وطلب الإذن
import 'package:latlong2/latlong.dart';

import '../repos/location_service_repository.dart';

class HandleLocationPermissionUseCase {
  final LocationServiceRepository repository;
  HandleLocationPermissionUseCase(this.repository);

  Future<bool> call() async {
    final isServiceEnabled = await repository.isLocationServiceEnabled();
    if (!isServiceEnabled) return false;

    final isPermissionGranted = await repository.requestLocationPermission();
    return isPermissionGranted;
  }
}

// 2. حالة جلب موقع الجهاز الحالي لمرة واحدة
class GetCurrentDeviceLocationUseCase {
  final LocationServiceRepository repository;
  GetCurrentDeviceLocationUseCase(this.repository);

  Future<LatLng?> call() async {
    return await repository.getCurrentDeviceLocation();
  }
}

// 3. حالة تتبع حركة الجهاز في الشارع لايف
class StreamDeviceLocationChangesUseCase {
  final LocationServiceRepository repository;
  StreamDeviceLocationChangesUseCase(this.repository);

  Stream<LatLng> call() {
    return repository.listenToDeviceLocationChanges();
  }
}