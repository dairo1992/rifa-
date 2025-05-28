import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rifa_plus/services/auth_service.dart';

enum AuthMethod { online, offiline }

class AuthState {
  final bool isLoading;
  final bool isAuthenticated;
  final AuthMethod method;
  final User? user;

  AuthState({
    this.isLoading = false,
    this.isAuthenticated = false,
    this.user,
    this.method = AuthMethod.offiline,
  });

  AuthState copyWith({
    bool? isLoading,
    bool? isAuthenticated,
    User? user,
    AuthMethod? method,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      user: user ?? this.user,
      method: method ?? this.method,
    );
  }
}

class AuthStateNotifier extends StateNotifier<AuthState> {
  late AuthService service;
  AuthStateNotifier()
    : super(AuthState(isAuthenticated: false, isLoading: false, user: null)) {
    service = AuthService();
    _init();
  }

  _init() {
    state = state.copyWith(isLoading: true);
    service.authChanges().listen((User? user) {
      if (user == null) {
        state = state.copyWith(
          isAuthenticated: false,
          isLoading: false,
          user: null,
        );
      } else {
        state = state.copyWith(
          isAuthenticated: true,
          isLoading: false,
          user: user,
        );
      }
    });
  }

  Future<void> register(String email, String password, bool status) async {
    state = state.copyWith(isLoading: true);
    Map<String, dynamic> resp;
    if (status) {
      resp = await service.register(email, password);
    } else {
      resp = await service.registerOffiline(email, password);
    }
    state = state.copyWith(
      isLoading: false,
      isAuthenticated: resp['STATUS'],
      method: status ? AuthMethod.online : AuthMethod.offiline,
      user: resp['STATUS'] ? resp['STATUS'] : resp['MSG'],
    );
    print(resp['MSG']);
  }

  Future<void> login(String email, String password, bool status) async {
    state = state.copyWith(isLoading: true);
    Map<String, dynamic> resp;
    if (status) {
      resp = await service.login(email, password);
    } else {
      resp = await service.loginOffiline(email, password);
    }
    state = state.copyWith(
      isLoading: false,
      isAuthenticated: resp['STATUS'],
      method: status ? AuthMethod.online : AuthMethod.offiline,
      user: resp['STATUS'] ? resp['MSG'] : null,
    );
  }
}

final authProvider = StateNotifierProvider<AuthStateNotifier, AuthState>(
  (ref) => AuthStateNotifier(),
);
