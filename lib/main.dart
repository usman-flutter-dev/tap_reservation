import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:tap_reservation/features/shared/root_router.dart';
import 'core/theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    // ProviderScope is required at the root to enable Riverpod
    // Every provider defined in the app lives inside this scope
    const ProviderScope(child: GuestHouseApp()),
  );
}

class GuestHouseApp extends StatelessWidget {
  const GuestHouseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // GetMaterialApp replaces MaterialApp so GetX navigation works
      // (Get.to, Get.back, Get.offAll, snackbars, etc.)
      title: 'Tap Reservation | Guest House',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const RootRouter(),
    );
  }
}
