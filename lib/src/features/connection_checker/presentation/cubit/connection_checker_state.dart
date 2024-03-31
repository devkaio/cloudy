part of 'connection_checker_cubit.dart';

class ConnectionCheckerState {
  const ConnectionCheckerState({
    this.hasConnection = true,
  });

  final bool hasConnection;

  ConnectionCheckerState copyWith({
    bool? hasConnection,
  }) {
    return ConnectionCheckerState(
      hasConnection: hasConnection ?? this.hasConnection,
    );
  }
}
