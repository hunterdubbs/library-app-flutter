part of 'author_add_bloc.dart';

abstract class AuthorAddEvent extends Equatable {
  const AuthorAddEvent();

  @override
  List<Object> get props => [];
}

class FirstNameChanged extends AuthorAddEvent {
  const FirstNameChanged(this.firstName);

  final String firstName;

  @override
  List<Object> get props => [firstName];
}

class LastNameChanged extends AuthorAddEvent {
  const LastNameChanged(this.lastName);

  final String lastName;

  @override
  List<Object> get props => [lastName];
}

class Submitted extends AuthorAddEvent {
  const Submitted();
}
