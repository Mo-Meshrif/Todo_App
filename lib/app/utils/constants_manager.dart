import 'package:flutter/material.dart';

class AppConstants {
  static const Locale arabic = Locale('ar');
  static const Locale english = Locale('en');
  static const String langPath = 'assets/translations';
  static const String twitterApiKey = 'hvKiIs7bNGehX7oWTB71HWn1e';
  static const String twitterApiSecretKey =
      'sPLTtdmXy3G3rh03DHm8m1g8HTBH2ItwGP3afqTK3y7wfGtfWo';
  static const String twitterRedirectURI = 'flutter-twitter-login://';
  static const String googleScope = 'email';
  static const String usersCollection = 'Users';
  static const String userIdFeild = 'id';
  static const String differentCredential =
      "account-exists-with-different-credential";
  static const String tryAgain =
      "we can't sign into your account,try again later";
  static const String invaildEmail = 'invalid-email';
  static const String userDisabled = 'user-disabled';
  static const String userNotFound = 'user-not-found';
  static const String wrongPassword = 'wrong-password';
  static const String emailUsed = 'email-already-in-use';
  static const String opNotAllowed = 'operation-not-allowed';
  static const String noConnection = 'NO_INTERNET_CONNECTION';
  static const String emptyVal = '';
  static const String nullError = 'null';
  static const String userKey = 'userKey';
  static const String authPassKey = 'authPassKey';
  static const int durationInSec = 3;
}
