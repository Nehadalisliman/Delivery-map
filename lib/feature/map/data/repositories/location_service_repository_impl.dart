import 'package:latlong2/latlong.dart';

import '../../domain/repos/location_service_repository.dart';
import '../datasources/device_location_data_source.dart';

class LocationServiceRepositoryImpl implements LocationServiceRepository {
  final DeviceLocationDataSource _deviceLocationDataSource;

  LocationServiceRepositoryImpl({required DeviceLocationDataSource deviceLocationDataSource})
      : _deviceLocationDataSource = deviceLocationDataSource;

  @override
  Future<bool> isLocationServiceEnabled() async {
    return await _deviceLocationDataSource.isServiceEnabled();
  }

  @override
  Future<bool> requestLocationPermission() async {
    return await _deviceLocationDataSource.checkAndRequestPermission();
  }

  @override
  Future<LatLng?> getCurrentDeviceLocation() async {
    try {
      final locationData = await _deviceLocationDataSource.getLocation();
      if (locationData.latitude != null && locationData.longitude != null) {
        return LatLng(locationData.latitude!, locationData.longitude!);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Stream<LatLng> listenToDeviceLocationChanges() {
    return _deviceLocationDataSource.liveLocationStream
        .where((locationData) => locationData.latitude != null && locationData.longitude != null)
        .map((locationData) => LatLng(locationData.latitude!, locationData.longitude!));
  }
}