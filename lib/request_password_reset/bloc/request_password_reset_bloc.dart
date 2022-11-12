import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:library_app/data/authentication_api.dart';
import 'package:library_app/request_password_reset/models/models.dart';

part 'request_password_reset_event.dart';
part 'request_password_reset_state.dart';

class RequestPasswordResetBloc extends Bloc<RequestPasswordResetEvent, RequestPasswordResetState> {
  RequestPasswordResetBloc({
    required AuthenticationApi authenticationApi
  }) : _authenticationApi = authenticationApi,
        super(const RequestPasswordResetState()) {
    on<EmailChanged>(_emailChanged);
    on<Submitted>(_submitted);
  }

  final AuthenticationApi _authenticationApi;

  void _emailChanged(
      EmailChanged event,
      Emitter<RequestPasswordResetState> emit
      ) {
    final email = Email.dirty(event.email);
    emit(state.copyWith(
      email: email,
      status: Formz.validate([email])
    ));
  }

  void _submitted(
      Submitted event,
      Emitter<RequestPasswordResetState> emit
      ) async {
    if(state.status.isValidated){
      emit(state.copyWith(status: FormzStatus.submissionInProgress));

      try{
        await _authenticationApi.requestPasswordReset(email: state.email.value);
        emit(state.copyWith(status: FormzStatus.submissionSuccess));
      }catch(_){
        emit(state.copyWith(status: FormzStatus.submissionFailure));
      }
    }
  }
}
