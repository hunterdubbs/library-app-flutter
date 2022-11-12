part of 'account_bloc.dart';

enum AccountStatus{ initial, loading, loaded, errorLoading }

class AccountState extends Equatable {
  const AccountState({
    this.accountInfo = const AccountInfo.empty(),
    this.status = AccountStatus.initial,
    this.errorMsg = ''
  });

  final AccountInfo accountInfo;
  final AccountStatus status;
  final String errorMsg;

  AccountState copyWith({
    AccountInfo? accountInfo,
    AccountStatus? status,
    String? errorMsg
  }) {
    return AccountState(
      accountInfo: accountInfo ?? this.accountInfo,
      status: status ?? this.status,
      errorMsg: errorMsg ?? this.errorMsg
    );
  }

  @override
  List<Object> get props => [accountInfo, status, errorMsg];
}