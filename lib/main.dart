import 'dart:io';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:easy_logger/easy_logger.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'app/app.dart';
import 'app/services/bloc_observer.dart';
import 'app/services/services_locator.dart';
import 'app/utils/color_manager.dart';
import 'app/utils/constants_manager.dart';
import 'modules/auth/presentation/controller/auth_bloc.dart';
import 'modules/home/presentation/controller/home_bloc.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  Bloc.observer = MyBlocObserver();
  EasyLocalization.logger.enableLevels = [LevelMessages.warning];
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();
  await ServicesLocator.init();
  Directory directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  await Hive.openBox(AppConstants.notificaionKey);
  await Hive.openBox(AppConstants.scheduledNotKey);
  await sl<AwesomeNotifications>().initialize(
    'resource://drawable/app_icon',
    [
      NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Basic Notifications',
        channelDescription: 'Notification channel for Basic',
        defaultColor: ColorManager.primary,
        importance: NotificationImportance.High,
        soundSource: 'resource://raw/alarm_clock',
        channelShowBadge: true,
        locked: true,
      ),
    ],
  );
  runApp(
    EasyLocalization(
      supportedLocales: const [
        AppConstants.arabic,
        AppConstants.english,
      ],
      path: AppConstants.langPath,
      fallbackLocale: AppConstants.english,
      useOnlyLangCode: true,
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(create: (context) => sl()),
          BlocProvider<HomeBloc>(create: (context) => sl()),
        ],
        child: MyApp(),
      ),
    ),
  );
}
