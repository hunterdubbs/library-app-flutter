import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:library_app/author_add/models/models.dart';
import 'package:library_app/data/library_api.dart';
import 'package:library_app/data/models/models.dart';

part 'author_add_event.dart';
part 'author_add_state.dart';

class AuthorAddBloc extends Bloc<AuthorAddEvent, AuthorAddState> {
  AuthorAddBloc({
    required LibraryApi libraryApi
  }) : _libraryApi = libraryApi,
    super(const AuthorAddState()){
    on<FirstNameChanged>(_onFirstNameChanged);
    on<LastNameChanged>(_onLastNameChanged);
    on<Submitted>(_onSubmitted);
  }

  final LibraryApi _libraryApi;

  void _onFirstNameChanged(
      FirstNameChanged event,
      Emitter<AuthorAddState> emit
      ) {
    final firstName = FirstName.dirty(event.firstName);
    emit(state.copyWith(
      firstName: firstName,
      status: Formz.validate([firstName, state.lastName])
    ));
  }

  void _onLastNameChanged(
      LastNameChanged event,
      Emitter<AuthorAddState> emit
      ) {
    final lastName = LastName.dirty(event.lastName);
    emit(state.copyWith(
        lastName: lastName,
        status: Formz.validate([lastName, state.firstName])
    ));
  }

  void _onSubmitted(
    Submitted event,
    Emitter<AuthorAddState> emit
  ) async {
    if(state.status.isValidated){
      emit(state.copyWith(status: FormzStatus.submissionInProgress));

      try{
        final author = await _libraryApi.createAuthor(firstName: state.firstName.value, lastName: state.lastName.value);
        emit(state.copyWith(
          status: FormzStatus.submissionSuccess,
          author: author
        ));
      }catch(_){
        emit(state.copyWith(status: FormzStatus.submissionFailure));
      }
    }
  }
}
