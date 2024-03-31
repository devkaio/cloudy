import 'dart:async';

import '../../../../core/dependencies/connectivity/connectivity_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'connection_checker_state.dart';

class ConnectionCheckerCubit extends Cubit<ConnectionCheckerState> {
  ConnectionCheckerCubit({
    required ConnectivityService connectivityService,
  })  : _connectivityService = connectivityService,
        super(const ConnectionCheckerState()) {
    _connectionSubscription = _connectivityService.hasConnection.listen(_onConnectionChanged);
  }
  final ConnectivityService _connectivityService;
  late final StreamSubscription<bool> _connectionSubscription;

  void _onConnectionChanged(bool hasConnection) {
    emit(state.copyWith(hasConnection: hasConnection));
  }

  @override
  Future<void> close() {
    _connectionSubscription.cancel();
    return super.close();
  }
}
