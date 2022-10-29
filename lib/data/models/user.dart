import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User({
    required this.userId,
    required this.username
  });

  final String userId;
  final String username;

  User.fromJson(Map json)
    : userId = json['userId'],
      username = json['username'];

  @override
  List<Object> get props => [userId, username];
}