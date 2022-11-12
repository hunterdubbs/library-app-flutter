import 'package:equatable/equatable.dart';

class AccountInfo extends Equatable {
  const AccountInfo({
    required this.username,
    required this.email
  });

  final String username;
  final String email;

  AccountInfo.fromJson(Map json)
    : username = json['username'],
      email = json['email'];

  const AccountInfo.empty()
   : username = '',
    email = '';

  @override
  List<Object> get props => [username, email];
}