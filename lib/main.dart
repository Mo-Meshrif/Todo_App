import 'package:easy_localization/easy_localization.dart';
import 'package:easy_logger/easy_logger.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get_storage/get_storage.dart';
import 'app/app.dart';
import 'app/services/bloc_observer.dart';
import 'app/services/services_locator.dart';
import 'app/utils/constants_manager.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  Bloc.observer = MyBlocObserver();
  EasyLocalization.logger.enableLevels = [LevelMessages.warning];
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();
  ServicesLocator.init();
  runApp(
    EasyLocalization(
      supportedLocales: const [
        AppConstants.arabic,
        AppConstants.english,
      ],
      path: AppConstants.langPath,
      fallbackLocale: AppConstants.english,
      useOnlyLangCode: true,
      child: MyApp(),
    ),
  );
}
