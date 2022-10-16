import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:library_app/author_search/models/models.dart';
import 'package:library_app/data/library_api.dart';
import 'package:library_app/data/models/models.dart';

part 'author_search_event.dart';
part 'author_search_state.dart';

class AuthorSearchBloc extends Bloc<AuthorSearchEvent, AuthorSearchState> {
  AuthorSearchBloc({
    required LibraryApi libraryApi,
  }) : _libraryApi = libraryApi,
   super(const AuthorSearchState()){
    on<QueryChanged>(_queryChanged);
    on<QuerySubmitted>(_submitted);
  }

  final LibraryApi _libraryApi;

  void _queryChanged(
      QueryChanged event,
      Emitter<AuthorSearchState> emit
      ) {
    final query = Query.dirty(event.query);
    emit(state.copyWith(
      query: query,
      status: Formz.validate([query])
    ));
  }

  void _submitted(
      QuerySubmitted event,
      Emitter<AuthorSearchState> emit
      ) async {
    if(state.status.isValidated){
      emit(state.copyWith(status: FormzStatus.submissionInProgress));

      try{
        final authors = await _libraryApi.searchAuthors(searchTerm: state.query.value);
        emit(state.copyWith(
          status: FormzStatus.submissionSuccess,
          results: authors
        ));
      }catch(_){
        emit(state.copyWith(status: FormzStatus.submissionFailure));
      }
    }
  }
}
