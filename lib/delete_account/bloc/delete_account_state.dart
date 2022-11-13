part of 'delete_account_bloc.dart';

class DeleteAccountState extends Equatable {
  const DeleteAccountState({
    this.password = const Password.pure(),
    this.status = FormzStatus.pure
  });

  final Password password;
  final FormzStatus status;

  DeleteAccountState copyWith({
    Password? password,
    FormzStatus? status
  }) {
    return DeleteAccountState(
      password: password ?? this.password,
      status: status ?? this.status
    );
  }

  @override
  List<Object> get props => [password, status];
}