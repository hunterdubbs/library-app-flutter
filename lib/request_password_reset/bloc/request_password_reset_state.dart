part of 'request_password_reset_bloc.dart';


class RequestPasswordResetState extends Equatable {
  const RequestPasswordResetState({
    this.email = const Email.pure(),
    this.status = FormzStatus.pure
  });

  final Email email;
  final FormzStatus status;

  RequestPasswordResetState copyWith({
    Email? email,
    FormzStatus? status
  }) {
    return RequestPasswordResetState(
      email: email ?? this.email,
      status: status ?? this.status
    );
  }

  @override
  List<Object> get props => [email, status];
}