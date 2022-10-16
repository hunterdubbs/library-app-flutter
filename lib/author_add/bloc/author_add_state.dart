part of 'author_add_bloc.dart';

class AuthorAddState extends Equatable {
  const AuthorAddState({
    this.status = FormzStatus.pure,
    this.firstName = const FirstName.pure(),
    this.lastName = const LastName.pure(),
    this.author
  });

  final FormzStatus status;
  final FirstName firstName;
  final LastName lastName;
  final Author? author;

  AuthorAddState copyWith({
    FormzStatus? status,
    FirstName? firstName,
    LastName? lastName,
    Author? author
  }) {
    return AuthorAddState(
      status: status ?? this.status,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      author: author ?? this.author
    );
  }

  @override
  List<Object> get props => [status, firstName, lastName];
}