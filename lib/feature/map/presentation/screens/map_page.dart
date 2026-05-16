import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../manager/map_cubit.dart';
import '../manager/map_state.dart';
import '../widget/map_control_buttons.dart';
import '../widget/map_header.dart';
import '../widget/map_search_bar.dart';

class MapPage extends StatefulWidget {
  final String userId;
  const MapPage({super.key, required this.userId});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final MapController _mapController = MapController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<MapCubit>().initMap(widget.userId);
  }

  @override
  void dispose() {
    _mapController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<MapCubit, MapState>(
        listener: (context, state) {
          // ✅ تحريك الكاميرا فوراً عند العثور على موقع البحث بنجاح
          if (state is MapSuccess && state.searchedLocation != null) {
            _mapController.move(state.searchedLocation!, 14.5);
          }
        },
        builder: (context, state) {
          if (state is MapLoading) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFF0F62AC)));
          } else if (state is MapPermissionDenied) {
            return const Center(child: Text('يرجى تفعيل الـ GPS والموافقة على صلاحية الموقع.'));
          } else if (state is MapError) {
            return Center(child: Text(state.message));
          } else if (state is MapSuccess) {
            return Stack(
              children: [
                // 1. الخريطة في الخلفية
                _buildFlutterMap(state),

                // 2. الـ Header العلوي
                Positioned(
                  top: 0, left: 0, right: 0,
                  child: MapHeader(
                    userName: state.user.name,
                    activeOrdersCount: state.user.activeOrdersCount,
                  ),
                ),

                // 3. صندوق البحث العائم
                Positioned(
                  top: 150, left: 20, right: 20,
                  child: MapSearchBar(
                    controller: _searchController,
                    onSearchPressed: () {
                      if (_searchController.text.isNotEmpty) {
                        context.read<MapCubit>().searchAndRoute(_searchController.text);
                      }
                    },
                  ),
                ),

                // 4. أزرار التحكم الجانبية
                Positioned(
                  bottom: 20, right: 20,
                  child: MapControlButtons(
                    onZoomIn: () => _mapController.move(_mapController.camera.center, _mapController.camera.zoom + 1),
                    onZoomOut: () => _mapController.move(_mapController.camera.center, _mapController.camera.zoom - 1),
                    onMyLocationPressed: () => _mapController.move(state.currentDeviceLocation, 15.0),
                  ),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildFlutterMap(MapSuccess state) {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: state.currentDeviceLocation,
        initialZoom: 13.5,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.map_page',
        ),
        // رسم خط السير
        if (state.routePoints.isNotEmpty)
          PolylineLayer(
            polylines: [
              Polyline(
                points: state.routePoints,
                color: const Color(0xFF0F62AC),
                strokeWidth: 5.0,
              ),
            ],
          ),
        // رسم الدبابيس والمواقع لايف
        MarkerLayer(
          markers: [
            // موقع المستخدم الحالي
            Marker(
              point: state.currentDeviceLocation,
              width: 40, height: 40,
              child: const Icon(Icons.my_location, color: Colors.blue, size: 30),
            ),
            // الوجهة عند البحث
            if (state.searchedLocation != null)
              Marker(
                point: state.searchedLocation!,
                width: 45, height: 45,
                child: const Icon(Icons.location_on, color: Colors.red, size: 40),
              ),

            // رسم أماكن الطلبات الحقيقية من الفايربيز
            ...state.orders.map((order) {
              return Marker(
                point: LatLng(order.lat, order.lng),
                width: 35, height: 35,
                child: const Icon(Icons.inventory, color: Colors.cyan, size: 28),
              );
            }),

            // رسم أماكن الكباتن الحقيقية من الفايربيز
            ...state.couriers.map((courier) {
              return Marker(
                point: LatLng(courier.lat, courier.lng),
                width: 40, height: 40,
                child: const Icon(Icons.motorcycle, color: Colors.orange, size: 32),
              );
            }),
          ],
        ),
      ],
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      // ✅ تم التعديل: خليناه 1 لأن الصفحة الحالية هي "الرئيسية" (العنصر الثاني في اللستة المتبقية)
      currentIndex: 1,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xFF0F62AC),
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'الحساب'),
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'الرئيسية'),
      ],
      // اختيارية: لإضافة الانتقال بين الشاشات مستقبلاً بالـ Index
      onTap: (index) {
        debugPrint("Selected Index: $index");
      },
    );
  }
}