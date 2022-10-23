part of 'register_bloc.dart';

class RegisterState extends Equatable {
  const RegisterState({
    this.status = FormzStatus.pure,
    this.username = const Username.pure(),
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.error = ''
  });

  final FormzStatus status;
  final Username username;
  final Email email;
  final Password password;
  final String error;

  RegisterState copyWith({
    FormzStatus? status,
    Username? username,
    Email? email,
    Password? password,
    String? error
  }) {
    return RegisterState(
      status: status ?? this.status,
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      error: error ?? this.error
    );
  }

  @override
  List<Object> get props => [status, username, email, password, error];
}