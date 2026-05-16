import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import '../../domain/entites/courier_entity.dart';
import '../../domain/entites/order_entity.dart';
import '../../domain/entites/user_entity.dart';
import '../../domain/use_cases/map_use_cases.dart';
import '../../domain/use_cases/navigation_use_cases.dart';
import '../../domain/use_cases/location_service_use_cases.dart';
import 'map_state.dart';

class MapCubit extends Cubit<MapState> {
  // حقن الـ Use Cases المطلوبة
  final GetUserDataUseCase _getUserDataUseCase;
  final StreamActiveOrdersUseCase _streamActiveOrdersUseCase;
  final StreamAvailableCouriersUseCase _streamAvailableCouriersUseCase;
  final UpdateUserLocationUseCase _updateUserLocationUseCase;
  final GetRoutePointsUseCase _getRoutePointsUseCase;
  final SearchLocationByNameUseCase _searchLocationByNameUseCase;
  final HandleLocationPermissionUseCase _handleLocationPermissionUseCase;
  final GetCurrentDeviceLocationUseCase _getCurrentDeviceLocationUseCase;
  final StreamDeviceLocationChangesUseCase _streamDeviceLocationChangesUseCase;

  // اشتراكات الـ Streams لقفلها عند تدمير الـ Cubit منعا للـ Memory Leaks
  StreamSubscription? _ordersSubscription;
  StreamSubscription? _couriersSubscription;
  StreamSubscription? _deviceLocationSubscription;

  MapCubit({
    required GetUserDataUseCase getUserDataUseCase,
    required StreamActiveOrdersUseCase streamActiveOrdersUseCase,
    required StreamAvailableCouriersUseCase streamAvailableCouriersUseCase,
    required UpdateUserLocationUseCase updateUserLocationUseCase,
    required GetRoutePointsUseCase getRoutePointsUseCase,
    required SearchLocationByNameUseCase searchLocationByNameUseCase,
    required HandleLocationPermissionUseCase handleLocationPermissionUseCase,
    required GetCurrentDeviceLocationUseCase getCurrentDeviceLocationUseCase,
    required StreamDeviceLocationChangesUseCase streamDeviceLocationChangesUseCase,
  })  : _getUserDataUseCase = getUserDataUseCase,
        _streamActiveOrdersUseCase = streamActiveOrdersUseCase,
        _streamAvailableCouriersUseCase = streamAvailableCouriersUseCase,
        _updateUserLocationUseCase = updateUserLocationUseCase,
        _getRoutePointsUseCase = getRoutePointsUseCase,
        _searchLocationByNameUseCase = searchLocationByNameUseCase,
        _handleLocationPermissionUseCase = handleLocationPermissionUseCase,
        _getCurrentDeviceLocationUseCase = getCurrentDeviceLocationUseCase,
        _streamDeviceLocationChangesUseCase = streamDeviceLocationChangesUseCase,
        super(MapInitial());

  // الدالة الرئيسية لتشغيل الشاشة وتجميع الـ Streams
  void initMap(String uid) async {
    emit(MapLoading());

    try {
      // 1. التعامل مع إذن الموقع والـ GPS
      final hasPermission = await _handleLocationPermissionUseCase();
      if (!hasPermission) {
        emit(MapPermissionDenied());
        return;
      }

      // 2. جلب لوكيشن الموبايل الأولي وبيانات اليوزر من السيرفر
      final initialLocation = await _getCurrentDeviceLocationUseCase();
      final user = await _getUserDataUseCase(uid);

      if (initialLocation == null) {
        emit(MapError("تعذر جلب موقع الجهاز الحالي"));
        return;
      }

      // 3. إطلاق الحالة الناجحة المبدئية
      emit(MapSuccess(
        user: user,
        orders: const [],
        couriers: const [],
        currentDeviceLocation: initialLocation,
      ));

      // 4. تشغيل الـ Streams الثلاثة لايف وتحديث الـ State تلقائياً

      // أ) مراقبة حركة الموبايل وتحديث الفايربيز تلقائياً عند التغيير
      _deviceLocationSubscription = _streamDeviceLocationChangesUseCase().listen((newLocation) {
        _updateState(newDeviceLocation: newLocation);
        _updateUserLocationUseCase(uid, newLocation.latitude, newLocation.longitude);
      });

      // ب) مراقبة الطلبات النشطة لايف من الفايربيز
      _ordersSubscription = _streamActiveOrdersUseCase().listen((ordersList) {
        _updateState(newOrders: ordersList);
      });

      // ج) مراقبة المناديب المتاحين لايف من الفايربيز
      _couriersSubscription = _streamAvailableCouriersUseCase().listen((couriersList) {
        _updateState(newCouriers: couriersList);
      });

    } catch (e) {
      emit(MapError("حدث خطأ أثناء تشغيل الخريطة: ${e.toString()}"));
    }
  }

  // دالة البحث عن مكان ورسم الطريق إليه
  void searchAndRoute(String query) async {
    if (state is MapSuccess) {
      final currentState = state as MapSuccess;

      // البحث بالاسم
      final destination = await _searchLocationByNameUseCase(query);
      if (destination != null) {
        // جلب نقاط الطريق بين موقع المستخدم الحالي والوجهة
        final route = await _getRoutePointsUseCase(currentState.currentDeviceLocation, destination);

        emit(currentState.copyWith(
          searchedLocation: destination,
          routePoints: route,
        ));
      }
    }
  }

  // دالة مساعدة لدمج تحديثات الـ Streams داخل الـ MapSuccess الحالية
  void _updateState({
    UserEntity? newUser,
    List<OrderEntity>? newOrders,
    List<CourierEntity>? newCouriers,
    LatLng? newDeviceLocation,
  }) {
    if (state is MapSuccess) {
      final currentState = state as MapSuccess;
      emit(currentState.copyWith(
        user: newUser,
        orders: newOrders,
        couriers: newCouriers,
        currentDeviceLocation: newDeviceLocation,
      ));
    }
  }

  @override
  Future<void> close() {
    _ordersSubscription?.cancel();
    _couriersSubscription?.cancel();
    _deviceLocationSubscription?.cancel();
    return super.close();
  }
}