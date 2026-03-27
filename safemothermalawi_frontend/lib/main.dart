import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/models/hive_adapters.dart';
import 'core/router/app_router.dart';
import 'core/storage/hive_boxes.dart';
import 'core/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  registerHiveAdapters();

  await Future.wait([
    Hive.openBox<dynamic>(HiveBoxes.authBox),
    Hive.openBox<dynamic>(HiveBoxes.profileBox),
    Hive.openBox<dynamic>(HiveBoxes.healthCheckBox),
    Hive.openBox<dynamic>(HiveBoxes.ancBox),
    Hive.openBox<dynamic>(HiveBoxes.learnBox),
    Hive.openBox<dynamic>(HiveBoxes.notificationsBox),
    Hive.openBox<dynamic>(HiveBoxes.syncQueueBox),
  ]);

  runApp(const ProviderScope(child: SafeMotherApp()));
}

class SafeMotherApp extends StatelessWidget {
  const SafeMotherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Safe Mother Malawi',
      theme: AppTheme.lightTheme,
      routerConfig: buildAppRouter(),
      debugShowCheckedModeBanner: false,
    );
  }
}
