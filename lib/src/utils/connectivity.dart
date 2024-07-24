import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

/// A provider class for checking device connectivity.
class ConnectionService {
  const ConnectionService._();

  static ConnectionService? _instance;

  static Connectivity? _connectivity;

  /// Singleton instance of the [Connectivity] package.
  static Connectivity get connectivity => _connectivity ??= Connectivity();

  /// Singleton instance of [ConnectionService].
  static ConnectionService get I {
    return _instance ??= const ConnectionService._();
  }

  /// Checks if the device is connected to any network.
  Future<bool> get isConnected async {
    final statuses = await connectivity.checkConnectivity();
    final status = statuses.firstOrNull;
    final mobile = status == ConnectivityResult.mobile;
    final wifi = status == ConnectivityResult.wifi;
    final ethernet = status == ConnectivityResult.ethernet;
    return mobile || wifi || ethernet;
  }
}
