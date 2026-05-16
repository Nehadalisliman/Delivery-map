import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart'; // سطر مهم جداً
import 'firebase_options.dart'; // خيارات الفايربيز الخاصة بمشروعك (توليد الـ CLI)
import 'feature/core/di/service_locator.dart';
import 'feature/map/presentation/manager/map_cubit.dart';
import 'feature/map/presentation/screens/map_page.dart';

void main() async {
  // 1. التأكد من تهيئة الـ Widgets
  WidgetsFlutterBinding.ensureInitialized();

  // 2. ✅ تهيئة الفايربيز أولاً وقبل أي شيء لحل إيرور الـ Runtime
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 3. تشغيل الـ Service Locator بعد ما الفايربيز يجهز
  await initServiceLocator();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // رجعنا للـ MaterialApp العادية لتنادي على الـ home مباشرة
    return MaterialApp(
      title: 'وصلني شكراً',
      debugShowCheckedModeBanner: false, // إخفاء شريط الديباج ليعطي مظهر الـ Production
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0F62AC)), // لون التطبيق الأساسي
        useMaterial3: true,
      ),
      // ✅ تغليف شاشة الخريطة بالـ BlocProvider وحقن الـ Cubit بـ سطر واحد سحري
      home: BlocProvider(
        create: (context) => sl<MapCubit>(), // حقن الـ 9 Use Cases والداتا سورسز تلقائياً
        child: const MapPage(userId: "MOHAMMED_UID_123"), // باصي الـ UID الخاص باليوزر هنا
      ),
    );
  }
}