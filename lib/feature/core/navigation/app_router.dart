import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../map/presentation/manager/map_cubit.dart';
import '../../map/presentation/screens/map_page.dart';
import '../di/service_locator.dart'; // استيراد الـ Service Locator النظيف

class AppRouter {
  // أسماء المسارات (Routes Names) كـ Constants لمنع الأخطاء الإملائية
  static const String initial = '/';
  static const String map = '/map';

  static final GoRouter router = GoRouter(
    initialLocation: initial,
    routes: [
      // 1. شاشة البداية مؤقتاً (الرئيسية)
      GoRoute(
        path: initial,
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('الشاشة الرئيسية للتطبيق')),
        ),
      ),

      // 2. مسار شاشة الخريطة المتقفل بالـ Cubit المحقون تلقائياً
      GoRoute(
        path: map,
        builder: (context, state) {
          // استقبال الـ userId الممرر أثناء التنقل
          final userId = state.extra as String? ?? "MOHAMMED_UID_123";

          return BlocProvider(
            create: (context) => sl<MapCubit>(), // حقن الـ Cubit تلقائياً بجميع الـ Use Cases
            child: MapPage(userId: userId),
          );
        },
      ),
    ],
  );
}