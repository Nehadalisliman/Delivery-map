import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:location/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../map/data/datasources/device_location_data_source.dart';
import '../../map/data/datasources/map_firebase_data_source.dart';
import '../../map/data/datasources/navigation_api_data_source.dart';
import '../../map/data/repositories/location_service_repository_impl.dart';
import '../../map/data/repositories/map_repository_impl.dart';
import '../../map/data/repositories/navigation_repository_impl.dart';
import '../../map/domain/repos/location_service_repository.dart';
import '../../map/domain/repos/map_repository.dart';
import '../../map/domain/repos/navigation_repository.dart';
import '../../map/domain/use_cases/location_service_use_cases.dart';
import '../../map/domain/use_cases/map_use_cases.dart';
import '../../map/domain/use_cases/navigation_use_cases.dart';
import '../../map/presentation/manager/map_cubit.dart';

// كائن الـ GetIt العالمي
final sl = GetIt.instance;

Future<void> initServiceLocator() async {

  // ==========================================
  // 1. Presentation Layer (Cubit / Blocs)
  // ==========================================
  sl.registerFactory(() => MapCubit(
    getUserDataUseCase: sl(),
    streamActiveOrdersUseCase: sl(),
    streamAvailableCouriersUseCase: sl(),
    updateUserLocationUseCase: sl(),
    getRoutePointsUseCase: sl(),
    searchLocationByNameUseCase: sl(),
    handleLocationPermissionUseCase: sl(),
    getCurrentDeviceLocationUseCase: sl(),
    streamDeviceLocationChangesUseCase: sl(),
  ));

  // ==========================================
  // 2. Domain Layer (Use Cases)
  // ==========================================
  sl.registerLazySingleton(() => GetUserDataUseCase(sl()));
  sl.registerLazySingleton(() => StreamActiveOrdersUseCase(sl()));
  sl.registerLazySingleton(() => StreamAvailableCouriersUseCase(sl()));
  sl.registerLazySingleton(() => UpdateUserLocationUseCase(sl()));

  sl.registerLazySingleton(() => GetRoutePointsUseCase(sl()));
  sl.registerLazySingleton(() => SearchLocationByNameUseCase(sl()));

  sl.registerLazySingleton(() => HandleLocationPermissionUseCase(sl()));
  sl.registerLazySingleton(() => GetCurrentDeviceLocationUseCase(sl()));
  sl.registerLazySingleton(() => StreamDeviceLocationChangesUseCase(sl()));

  // ==========================================
  // 3. Data Layer (Repositories)
  // ==========================================
  // ✅ تم التعديل: شيلنا الـ sl() من هنا لأن الـ Data Sources كونستركتورها بقى فاضي ومستقر
  sl.registerLazySingleton<MapRepository>(
        () => MapRepositoryImpl(firebaseDataSource: MapFirebaseDataSource()),
  );
  sl.registerLazySingleton<NavigationRepository>(
        () => NavigationRepositoryImpl(apiDataSource: NavigationApiDataSource()),
  );
  sl.registerLazySingleton<LocationServiceRepository>(
        () => LocationServiceRepositoryImpl(deviceLocationDataSource: DeviceLocationDataSource()),
  );

  // ==========================================
  // 4. Data Layer (Data Sources)
  // ==========================================
  // الكونستركتورز المستقرة بدون بارامترات ممررة داخلياً
  sl.registerLazySingleton(() => MapFirebaseDataSource());
  sl.registerLazySingleton(() => NavigationApiDataSource());
  sl.registerLazySingleton(() => DeviceLocationDataSource());

  // ==========================================
  // 5. External Libraries (المكتبات الخارجية)
  // ==========================================
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => Location());
}