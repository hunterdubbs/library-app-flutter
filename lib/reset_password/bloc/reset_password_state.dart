part of 'reset_password_bloc.dart';

class ResetPasswordState extends Equatable {
  const ResetPasswordState({
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.code = const Code.pure(),
    this.status = FormzStatus.pure
  });

  final Email email;
  final Password password;
  final Code code;
  final FormzStatus status;

  ResetPasswordState copyWith({
    Email? email,
    Password? password,
    Code? code,
    FormzStatus? status
  }) {
    return ResetPasswordState(
      email: email ?? this.email,
      password: password ?? this.password,
      code: code ?? this.code,
      status: status ?? this.status
    );
  }

  @override
  List<Object> get props => [email, password, code, status];
}