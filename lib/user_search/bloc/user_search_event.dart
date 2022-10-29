part of 'user_search_bloc.dart';

abstract class UserSearchEvent extends Equatable {
  const UserSearchEvent();

  @override
  List<Object> get props => [];
}

class QuerySubmitted extends UserSearchEvent {
  const QuerySubmitted();
}

class QueryChanged extends UserSearchEvent {
  const QueryChanged(this.query);

  final String query;

  @override
  List<Object> get props => [query];
}

class InviteUser extends UserSearchEvent {
  const InviteUser(this.user, this.permissionLevel);

  final User user;
  final int permissionLevel;

  @override
  List<Object> get props => [user, permissionLevel];
}
