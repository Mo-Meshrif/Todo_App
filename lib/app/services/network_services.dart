import 'package:internet_connection_checker/internet_connection_checker.dart';

abstract class NetworkServices {
  Future<bool> isConnected();
}

class InternetChecker implements NetworkServices {
  final InternetConnectionChecker internetConnectionChecker;

  InternetChecker(this.internetConnectionChecker);
  @override
  Future<bool> isConnected() => internetConnectionChecker.hasConnection;
}
