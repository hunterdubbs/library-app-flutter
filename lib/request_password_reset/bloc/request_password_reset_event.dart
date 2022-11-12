part of 'request_password_reset_bloc.dart';

abstract class RequestPasswordResetEvent extends Equatable {
  const RequestPasswordResetEvent();

  @override
  List<Object> get props => [];
}

class EmailChanged extends RequestPasswordResetEvent {
  const EmailChanged(this.email);

  final String email;

  @override
  List<Object> get props => [email];
}

class Submitted extends RequestPasswordResetEvent {
  const Submitted();
}