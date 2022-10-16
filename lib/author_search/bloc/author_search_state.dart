part of 'author_search_bloc.dart';

class AuthorSearchState extends Equatable {
  const AuthorSearchState({
    this.status = FormzStatus.pure,
    this.query = const Query.pure(),
    this.results = const <Author>[]
  });

  final FormzStatus status;
  final Query query;
  final List<Author> results;

  AuthorSearchState copyWith({
    FormzStatus? status,
    Query? query,
    List<Author>? results
  }) {
    return AuthorSearchState(
      status: status ?? this.status,
      query: query ?? this.query,
      results: results ?? this.results
    );
  }

  @override
  List<Object> get props => [status, query, results];
}