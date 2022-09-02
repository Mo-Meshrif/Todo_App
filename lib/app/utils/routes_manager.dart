import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import '../../modules/home/presentation/screens/subScreens/add_task_screen.dart';
import '../../modules/home/presentation/screens/subScreens/category_screen.dart';
import '../../modules/home/presentation/screens/subScreens/done_task_screen.dart';
import '../../modules/home/presentation/screens/subScreens/important_task_screen.dart';
import '../../modules/home/presentation/screens/subScreens/later_task_screen.dart';
import '../../modules/home/presentation/screens/subScreens/notification_screen.dart';
import '../../modules/home/presentation/screens/subScreens/search_screen.dart';
import '../../modules/home/presentation/screens/subScreens/settings_screen.dart';
import '../helper/shared_helper.dart';
import '../services/services_locator.dart';
import '/modules/home/presentation/screens/home_screen.dart';
import '../../modules/auth/presentation/screens/auth_screen.dart';
import 'constants_manager.dart';

class Routes {
  static const String authRoute = "/auth";
  static const String homeRoute = "/main";
  static const String addTaskRoute = "/addTask";
  static const String notificationRoute = "/notification";
  static const String searchRoute = "/searchRoute";
  static const String importantRoute = "/important";
  static const String doneRoute = "/done";
  static const String laterRoute = "/later";
  static const String categoryRoute = "/category";
  static const String settingsRoute = "/settings";
}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.authRoute:
        return MaterialPageRoute(builder: (_) => const AuthScreen());
      case Routes.homeRoute:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case Routes.addTaskRoute:
        return MaterialPageRoute(builder: (_) => const AddTaskScreen());
      case Routes.notificationRoute:
        return MaterialPageRoute(builder: (_) => const NotificationScreen());
      case Routes.searchRoute:
        return MaterialPageRoute(builder: (_) => const SearchScreen());
      case Routes.importantRoute:
        return MaterialPageRoute(builder: (_) => const ImportantTaskScreen());
      case Routes.doneRoute:
        return MaterialPageRoute(builder: (_) => const DoneTaskScreen());
      case Routes.laterRoute:
        return MaterialPageRoute(builder: (_) => const LaterTaskScreen());
      case Routes.categoryRoute:
        return MaterialPageRoute(builder: (_) => const CategoryScreen());
      case Routes.settingsRoute:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      default:
        return controlRoute();
    }
  }

  static Route<dynamic> controlRoute() {
    return MaterialPageRoute(
      builder: (_) {
        FlutterNativeSplash.remove();
        AppShared appShared = sl<AppShared>();
        bool authPass = appShared.getVal(AppConstants.authPassKey) ?? false;
        return authPass ? const HomeScreen() : const AuthScreen();
      },
    );
  }
}
