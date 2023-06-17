part of 'providers.dart';

class ConnectivityProvider {
  const ConnectivityProvider._();

  static ConnectivityProvider? _instance;

  static ConnectivityProvider get I =>
      _instance ??= const ConnectivityProvider._();

  Future<bool> get isMobile =>
      ConnectivityService.I.isAvailable(ConnectivityResult.mobile);

  Future<bool> get isWifi =>
      ConnectivityService.I.isAvailable(ConnectivityResult.wifi);

  Future<bool> get isEthernet =>
      ConnectivityService.I.isAvailable(ConnectivityResult.ethernet);

  Future<bool> get isBluetooth =>
      ConnectivityService.I.isAvailable(ConnectivityResult.bluetooth);

  Future<bool> get isVPN =>
      ConnectivityService.I.isAvailable(ConnectivityResult.vpn);

  Future<bool> get isNone =>
      ConnectivityService.I.isAvailable(ConnectivityResult.none);

  Future<bool> get isConnected async {
    final ConnectivityResult status = await ConnectivityService.I.checkStatus;
    final mobile = status == ConnectivityResult.mobile;
    final wifi = status == ConnectivityResult.wifi;
    final ethernet = status == ConnectivityResult.ethernet;
    return mobile || wifi || ethernet;
  }
}

class ConnectivityService {
  const ConnectivityService._();

  static ConnectivityService? _instance;
  static Connectivity? _connectivity;

  static ConnectivityService get I =>
      _instance ??= const ConnectivityService._();

  static Connectivity get connectivity => _connectivity ??= Connectivity();

  Future<ConnectivityResult> get checkStatus async =>
      await connectivity.checkConnectivity();

  Stream<ConnectivityResult> get onConnectivityChanged =>
      connectivity.onConnectivityChanged;

  Future<bool> isAvailable(ConnectivityResult result) async {
    final status = await checkStatus;
    return status == result;
  }

  Future<bool> onChangedStatus([
    ConnectivityType type = ConnectivityType.single,
  ]) async {
    final result = await getDynamicResult(type);
    return isAvailable(result);
  }

  Future<ConnectivityResult> getDynamicResult(ConnectivityType type) async {
    switch (type) {
      case ConnectivityType.first:
        return await onConnectivityChanged.first;
      case ConnectivityType.last:
        return await onConnectivityChanged.last;
      default:
        return await onConnectivityChanged.single;
    }
  }
}

enum ConnectivityType {
  single,
  first,
  last,
}
