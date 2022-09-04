import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:library_app/data/authentication_api.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({
    required AuthenticationApi authenticationApi
}) : _authenticationApi = authenticationApi,
        super(const AuthenticationState.unknown()) {
    on<AuthenticationStatusChanged>(_onAuthenticationStatusChanged);
    on<AuthenticationLogoutRequested>(_onAuthenticationLogoutRequested);
    _authenticationStatusSubscription = _authenticationApi.status.listen(
        (status) => add(AuthenticationStatusChanged(status))
    );
  }

  final AuthenticationApi _authenticationApi;
  late StreamSubscription<AuthenticationStatus> _authenticationStatusSubscription;

  @override
  Future<void> close() {
    _authenticationStatusSubscription.cancel();
    _authenticationApi.dispose();
    return super.close();
  }

  void _onAuthenticationStatusChanged (
      AuthenticationStatusChanged event,
      Emitter<AuthenticationState> emit,
      ) async {
    switch (event.status) {
      case AuthenticationStatus.unauthenticated:
        return emit(const AuthenticationState.unauthenticated());
      case AuthenticationStatus.authenticated:
        return emit(const AuthenticationState.authenticated());
      default:
        return emit(const AuthenticationState.unknown());
    }
  }

  void _onAuthenticationLogoutRequested(
    AuthenticationLogoutRequested event,
  Emitter<AuthenticationState> emit
      ){
    _authenticationApi.logOut();
  }

}
