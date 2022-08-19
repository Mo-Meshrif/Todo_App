import 'package:flutter/material.dart';
import 'utils/routes_manager.dart';
import 'utils/strings_manager.dart';
import '/app/utils/theme_manager.dart';

class MyApp extends StatefulWidget {
  const MyApp._internal();
  static const MyApp _instance = MyApp._internal();
  factory MyApp() => _instance;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appName,
      theme: ThemeManager.lightTheme(),
      onGenerateRoute: RouteGenerator.getRoute,
    );
  }
}
