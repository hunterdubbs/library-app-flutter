part of 'user_search_bloc.dart';

enum UserSearchStatus{ initial, working, success, error}

class UserSearchState extends Equatable {
  const UserSearchState({
    this.status = FormzStatus.pure,
    this.selectionStatus = UserSearchStatus.initial,
    this.query = const Query.pure(),
    this.results = const <User>[],
    this.errorMsg = '',
    required this.library
  });

  final FormzStatus status;
  final UserSearchStatus selectionStatus;
  final Query query;
  final List<User> results;
  final String errorMsg;
  final Library library;

  UserSearchState copyWith({
    FormzStatus? status,
    UserSearchStatus? selectionStatus,
    Query? query,
    List<User>? results,
    String? errorMsg,
    Library? library
  }) {
    return UserSearchState(
      status: status ?? this.status,
      selectionStatus: selectionStatus ?? this.selectionStatus,
      query: query ?? this.query,
      results: results ?? this.results,
      errorMsg: errorMsg ?? this.errorMsg,
      library: library ?? this.library
    );
  }

  @override
  List<Object> get props => [status, selectionStatus, query, results, errorMsg, library];
}