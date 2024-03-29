import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:library_app/data/authentication_api.dart';
import 'package:library_app/register/models/models.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc({
    required AuthenticationApi authenticationApi
  }) : _authenticationApi = authenticationApi,
    super(const RegisterState()) {
      on<UsernameChanged>(_onUsernameChanged);
      on<EmailChanged>(_onEmailChanged);
      on<PasswordChanged>(_onPasswordChanged);
      on<Submitted>(_onSubmitted);
  }

  final AuthenticationApi _authenticationApi;

  void _onUsernameChanged(
    UsernameChanged event,
    Emitter<RegisterState> emit
  ) {
    final username = Username.dirty(event.username);
    emit(state.copyWith(
      username: username,
      status: Formz.validate([username, state.email, state.password])
    ));
  }

  void _onEmailChanged(
      EmailChanged event,
      Emitter<RegisterState> emit
      ) {
    final email = Email.dirty(event.email);
    emit(state.copyWith(
      email: email,
      status: Formz.validate([email, state.username, state.password])
    ));
  }

  void _onPasswordChanged(
      PasswordChanged event,
      Emitter<RegisterState> emit
      ) {
    final password = Password.dirty(event.password);
    emit(state.copyWith(
      password: password,
      status: Formz.validate([password, state.username, state.email])
    ));
  }

  Future<void> _onSubmitted(
      Submitted event,
      Emitter<RegisterState> emit
      ) async {
    if(state.status.isValidated){
      emit(state.copyWith(status: FormzStatus.submissionInProgress));

      try{
        await _authenticationApi.register(
          username: state.username.value,
          email: state.email.value,
          password: state.password.value
        );
        emit(state.copyWith(
            status: FormzStatus.submissionSuccess,
            error: ''
        ));
      } on RegisterException catch(e){
        emit(state.copyWith(
          status: FormzStatus.submissionFailure,
          error: e.error
        ));
      }catch(_){
        emit(state.copyWith(
          status: FormzStatus.submissionFailure,
          error: 'Error Registering Account'
        ));
      }
    }
  }
}
