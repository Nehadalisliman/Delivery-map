
import 'package:dio/dio.dart';

class NavigationApiDataSource {
  final Dio _dio = Dio();
  final String _orsApiKey = 'YOUR_OPEN_ROUTE_SERVICE_API_KEY';

  // 1. طلب خطوط السير من OpenRouteService
  Future<Response> getRouteDirections(double startLat, double startLng, double endLat, double endLng) async {
    const String url = 'https://api.openrouteservice.org/v2/directions/driving-car';
    return await _dio.get(
      url,
      queryParameters: {
        'api_key': _orsApiKey,
        'start': '$startLng,$startLat', // الـ ORS يتطلب Longitude أولاً
        'end': '$endLng,$endLat',
      },
    );
  }

  // 2. طلب البحث عن مكان من لدن خدمة Nominatim OSM
  Future<Response> searchLocation(String query) async {
    const String url = 'https://nominatim.openstreetmap.org/search';
    return await _dio.get(
      url,
      queryParameters: {
        'q': query,
        'format': 'json',
        'limit': 1,
      },
      options: Options(headers: {'User-Agent': 'Wassalni_Shokran_App'}),
    );
  }
}