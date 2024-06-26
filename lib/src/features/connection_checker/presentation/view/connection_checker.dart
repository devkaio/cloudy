import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/connection_checker_cubit.dart';

class ConnectionChecker extends StatelessWidget {
  const ConnectionChecker({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ConnectionCheckerCubit, ConnectionCheckerState>(
      listenWhen: (previous, current) => previous.hasConnection != current.hasConnection,
      listener: (context, state) {
        if (!state.hasConnection) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'No internet connection',
                textAlign: TextAlign.center,
              ),
              backgroundColor: Colors.red,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Internet connection restored',
                textAlign: TextAlign.center,
              ),
              backgroundColor: Colors.green,
            ),
          );
        }
      },
      builder: (context, state) => Scaffold(body: child),
    );
  }
}
