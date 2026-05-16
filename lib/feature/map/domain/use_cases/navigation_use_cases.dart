

// 1. حالة جلب نقاط المسار لرسم الخطوط على الخريطة
import 'package:latlong2/latlong.dart';

import '../repos/navigation_repository.dart';

class GetRoutePointsUseCase {
  final NavigationRepository repository;
  GetRoutePointsUseCase(this.repository);

  Future<List<LatLng>> call(LatLng start, LatLng end) async {
    return await repository.getRoutePoints(start, end);
  }
}

// 2. حالة البحث عن مكان بالاسم
class SearchLocationByNameUseCase {
  final NavigationRepository repository;
  SearchLocationByNameUseCase(this.repository);

  Future<LatLng?> call(String query) async {
    return await repository.searchLocationByName(query);
  }
}