part of 'reset_password_bloc.dart';

abstract class ResetPasswordEvent extends Equatable {
  const ResetPasswordEvent();

  @override
  List<Object> get props => [];
}

class EmailChanged extends ResetPasswordEvent {
  const EmailChanged(this.email);

  final String email;

  @override
  List<Object> get props => [email];
}

class PasswordChanged extends ResetPasswordEvent {
  const PasswordChanged(this.password);

  final String password;

  @override
  List<Object> get props => [password];
}


class CodeChanged extends ResetPasswordEvent {
  const CodeChanged(this.code);

  final String code;

  @override
  List<Object> get props => [code];
}

class Submitted extends ResetPasswordEvent {
  const Submitted();
}
