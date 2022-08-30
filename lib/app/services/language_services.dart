import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../utils/constants_manager.dart';


class LanguageServices {
  static changeLang(BuildContext context) async {
    if (context.locale == AppConstants.english) {
      await context.setLocale(AppConstants.arabic);
    } else {
      await context.setLocale(AppConstants.english);
    }
  }
}
