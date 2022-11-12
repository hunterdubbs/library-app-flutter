import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:library_app/data/authentication_api.dart';
import 'package:library_app/reset_password/models/models.dart';

part 'reset_password_event.dart';
part 'reset_password_state.dart';

class ResetPasswordBloc extends Bloc<ResetPasswordEvent, ResetPasswordState> {
  ResetPasswordBloc({
    required AuthenticationApi authenticationApi,
    String email = ''
  }) : _authenticationApi = authenticationApi,
      super(ResetPasswordState(email: Email.dirty(email))) {
    on<EmailChanged>(_emailChanged);
    on<PasswordChanged>(_passwordChanged);
    on<CodeChanged>(_codeChanged);
    on<Submitted>(_submitted);
  }

  final AuthenticationApi _authenticationApi;

  void _emailChanged(
      EmailChanged event,
      Emitter<ResetPasswordState> emit
      ) {
    final email = Email.dirty(event.email);
    emit(state.copyWith(
      email: email,
      status: Formz.validate([email, state.password, state.code])
    ));
  }

  void _passwordChanged(
      PasswordChanged event,
      Emitter<ResetPasswordState> emit
      ) {
    final password = Password.dirty(event.password);
    emit(state.copyWith(
      password: password,
      status: Formz.validate([password, state.email, state.code])
    ));
  }

  void _codeChanged(
      CodeChanged event,
      Emitter<ResetPasswordState> emit
      ) {
    final code = Code.dirty(event.code);
    emit(state.copyWith(
      code: code,
      status: Formz.validate([code, state.email, state.password])
    ));
  }

  void _submitted(
      Submitted event,
      Emitter<ResetPasswordState> emit
      ) async {
    if(state.status.isValidated){
      emit(state.copyWith(status: FormzStatus.submissionInProgress));

      try{
        await _authenticationApi.resetPassword(email: state.email.value, code: state.code.value, newPassword: state.password.value);
        emit(state.copyWith(status: FormzStatus.submissionSuccess));
      }catch(_){
        emit(state.copyWith(status: FormzStatus.submissionFailure));
      }
    }
  }
}
