import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:library_app/data/library_api.dart';
import 'package:library_app/data/models/models.dart';
import 'package:library_app/user_search/models/models.dart';

part 'user_search_event.dart';
part 'user_search_state.dart';

class UserSearchBloc extends Bloc<UserSearchEvent, UserSearchState> {
  UserSearchBloc({
    required LibraryApi libraryApi,
    required Library library
  }) : _libraryApi = libraryApi,
  super(UserSearchState(library: library)) {
    on<QueryChanged>(_queryChanged);
    on<QuerySubmitted>(_querySubmitted);
    on<InviteUser>(_inviteUser);
  }

  final LibraryApi _libraryApi;

  void _queryChanged(
      QueryChanged event,
      Emitter<UserSearchState> emit
      ) {
    final query = Query.dirty(event.query);
    emit(state.copyWith(
      query: query,
      status: Formz.validate([query])
    ));
  }

  void _querySubmitted(
      QuerySubmitted event,
      Emitter<UserSearchState> emit
      ) async {
    if(state.status.isValidated) {
      emit(state.copyWith(status: FormzStatus.submissionInProgress));

      try{
        final users = await _libraryApi.searchUsers(searchTerm: state.query.value);
        emit(state.copyWith(
          status: FormzStatus.submissionSuccess,
          results: users
        ));
      }catch(_){
        emit(state.copyWith(status: FormzStatus.submissionFailure));
      }
    }
  }

  void _inviteUser(
      InviteUser event,
      Emitter<UserSearchState> emit
      ) async {
    emit(state.copyWith(selectionStatus: UserSearchStatus.working));

    try{
      await _libraryApi.createInvite(libraryId: state.library.id, recipientId: event.user.userId, permissionLevel: event.permissionLevel);
      emit(state.copyWith(selectionStatus: UserSearchStatus.success));
    }on CreateInviteException catch(e){
      emit(state.copyWith(selectionStatus: UserSearchStatus.error, errorMsg: e.msg));
    }catch(_){
      emit(state.copyWith(selectionStatus: UserSearchStatus.error, errorMsg: 'Error creating invite'));
    }
  }
}
