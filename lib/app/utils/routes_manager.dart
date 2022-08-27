import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import '../helper/shared_helper.dart';
import '../services/services_locator.dart';
import '/modules/home/presentation/screens/home_screen.dart';
import '/modules/auth/presentation/screens/login_screen.dart';
import 'constants_manager.dart';

class Routes {
  static const String loginRoute = "/login";
  static const String registerRoute = "/register";
  static const String forgotPasswordRoute = "/forgotPassword";
  static const String homeRoute = "/main";
}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.loginRoute:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case Routes.homeRoute:
        return MaterialPageRoute(builder: (_) => const HomeScreen());   
      default:
        return controlRoute();
    }
  }

  static Route<dynamic> controlRoute() {
    return MaterialPageRoute(
      builder: (_) {
        FlutterNativeSplash.remove();
        AppShared appShared = sl<AppShared>();
        bool passLogin = appShared.getVal(AppConstants.passLoginKey) ?? false;
        return passLogin ? const HomeScreen() : const LoginScreen();
      },
    );
  }
}
