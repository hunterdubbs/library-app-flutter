import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:library_app/data/authentication_api.dart';

import '../models/models.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({
    required AuthenticationApi authenticationApi
  }) : _authenticationApi = authenticationApi,
  super(const LoginState()){
    on<LoginUsernameChanged>(_onUsernameChanged);
    on<LoginPasswordChanged>(_onPasswordChanged);
    on<LoginSubmitted>(_onSubmitted);
  }

  final AuthenticationApi _authenticationApi;

  void _onUsernameChanged(
      LoginUsernameChanged event,
      Emitter<LoginState> emit
      ) {
    final username = Username.dirty(event.username);
    emit(state.copyWith(
      username: username,
      status: Formz.validate([state.password, username])
    ));
  }

  void _onPasswordChanged(
      LoginPasswordChanged event,
      Emitter<LoginState> emit
      ) {
    final password = Password.dirty(event.password);
    emit(state.copyWith(
      password: password,
      status: Formz.validate([password, state.username])
    ));
  }

  void _onSubmitted(
      LoginSubmitted event,
      Emitter<LoginState> emit,
      ) async {
    if(state.status.isValidated){
      emit(state.copyWith(status: FormzStatus.submissionInProgress));
      try{
        await _authenticationApi.logIn(
          username: state.username.value,
          password: state.password.value
        );
        emit(state.copyWith(status: FormzStatus.submissionSuccess));
      } catch (_) {
        emit(state.copyWith(status: FormzStatus.submissionFailure));
      }
    }
  }
}
