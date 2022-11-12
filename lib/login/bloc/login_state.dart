part of 'login_bloc.dart';

class LoginState extends Equatable {
  const LoginState({
    this.status = FormzStatus.pure,
    this.username = const Username.pure(),
    this.password = const Password.pure(),
    this.errorMsg = ''
  });

  final FormzStatus status;
  final Username username;
  final Password password;
  final String errorMsg;

  LoginState copyWith({
    FormzStatus? status,
    Username? username,
    Password? password,
    String? errorMsg
  }) {
    return LoginState(
        status: status ?? this.status,
        username: username ?? this.username,
        password: password ?? this.password,
        errorMsg: errorMsg ?? this.errorMsg
    );
  }

  @override
  List<Object> get props => [status, username, password, errorMsg];
}