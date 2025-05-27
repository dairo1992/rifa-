import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConexionStatus {
  final bool isOnline;
  final ConnectivityResult conexionType;

  ConexionStatus({required this.isOnline, required this.conexionType});

  ConexionStatus copyWith({bool? isOnline, ConnectivityResult? conexionType}) {
    return ConexionStatus(
      isOnline: isOnline ?? this.isOnline,
      conexionType: conexionType ?? this.conexionType,
    );
  }
}

class ConnectivityStateNotifier extends StateNotifier<ConexionStatus> {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> connectivitySubscription;

  ConnectivityStateNotifier()
    : super(
        ConexionStatus(isOnline: false, conexionType: ConnectivityResult.none),
      ) {
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      connectivitySubscription = _connectivity.onConnectivityChanged.listen(
        _updateConnectionStatus,
      );
      final connectivityResults = await _connectivity.checkConnectivity();
      await _updateConnectionStatus(connectivityResults);
    } catch (e) {
      state = ConexionStatus(
        isOnline: false,
        conexionType: ConnectivityResult.none,
      );
    }
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> results) async {
    final isOnline =
        results.isNotEmpty && !results.contains(ConnectivityResult.none);

    if (isOnline && !state.isOnline) {
      state = state.copyWith(isOnline: true);
    } else {
      state = state.copyWith(isOnline: isOnline);
    }
  }
}

final connectivityProvider =
    StateNotifierProvider<ConnectivityStateNotifier, ConexionStatus>(
      (ref) => ConnectivityStateNotifier(),
    );
