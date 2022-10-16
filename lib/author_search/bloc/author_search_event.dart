part of 'author_search_bloc.dart';

abstract class AuthorSearchEvent extends Equatable {
  const AuthorSearchEvent();

  @override
  List<Object> get props => [];
}

class QuerySubmitted extends AuthorSearchEvent {
  const QuerySubmitted();
}

class QueryChanged extends AuthorSearchEvent {
  const QueryChanged(this.query);

  final String query;

  @override
  List<Object> get props => [query];
}
