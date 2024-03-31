import 'dart:async';

import '../../api/connection_api.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService implements ConnectionApi {
  ConnectivityService() {
    _connectivity.onConnectivityChanged.listen(_checkConnectivity);
  }

  final _connectivity = Connectivity();

  final StreamController<bool> _connectionController = StreamController<bool>();

  @override
  Stream<bool> get hasConnection => _connectionController.stream;

  void _checkConnectivity(List<ConnectivityResult> result) {
    final hasConnection = !result.contains(ConnectivityResult.none);
    _connectionController.add(hasConnection);
  }

  void close() {
    _connectionController.close();
  }
}
