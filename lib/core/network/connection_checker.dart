import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

abstract interface class ConnectionChecker {
  Future<bool> get isConnected;

  Stream<bool> get onStatusChange;
}

class ConnectionCheckerImpl implements ConnectionChecker {
  final InternetConnection _internetConnection;

  ConnectionCheckerImpl(this._internetConnection);

  @override
  Future<bool> get isConnected => _internetConnection.hasInternetAccess;

  @override
  Stream<bool> get onStatusChange => _internetConnection.onStatusChange.map((status) => status == InternetStatus.connected);
}
