import 'package:latlong2/latlong.dart';

import '../../domain/repos/navigation_repository.dart';
import '../datasources/navigation_api_data_source.dart';

class NavigationRepositoryImpl implements NavigationRepository {
  final NavigationApiDataSource _apiDataSource;

  NavigationRepositoryImpl({required NavigationApiDataSource apiDataSource})
      : _apiDataSource = apiDataSource;

  @override
  Future<List<LatLng>> getRoutePoints(LatLng start, LatLng end) async {
    try {
      final response = await _apiDataSource.getRouteDirections(
        start.latitude, start.longitude, end.latitude, end.longitude,
      );
      if (response.statusCode == 200) {
        final List<dynamic> coordinates = response.data['features'][0]['geometry']['coordinates'];
        // تحويل أرقام الـ API لـ LatLng Objects جاهزة للرسم
        return coordinates.map((coord) => LatLng(coord[1] as double, coord[0] as double)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  @override
  Future<LatLng?> searchLocationByName(String query) async {
    try {
      final response = await _apiDataSource.searchLocation(query);
      if (response.statusCode == 200 && (response.data as List).isNotEmpty) {
        final Map<String, dynamic> locationData = response.data[0];
        return LatLng(double.parse(locationData['lat']), double.parse(locationData['lon']));
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}