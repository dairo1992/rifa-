import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rifa_plus/config/custom_theme.dart';
import 'package:rifa_plus/config/routes.dart';
import 'package:rifa_plus/firebase_options.dart';
import 'package:rifa_plus/helpers/alerts.dart';
import 'package:rifa_plus/services/datebase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseService.initialize();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    AlertManager.instance.initialize(context);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: routes,
      theme: custom_theme,
    );
  }
}
