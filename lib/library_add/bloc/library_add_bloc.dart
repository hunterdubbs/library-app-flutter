import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:library_app/data/library_api.dart';
import 'package:library_app/library_add/models/models.dart';

part 'library_add_event.dart';
part 'library_add_state.dart';

class LibraryAddBloc extends Bloc<LibraryAddEvent, LibraryAddState> {
  LibraryAddBloc({
    required LibraryApi libraryApi
  }) : _libraryApi = libraryApi,
        super(const LibraryAddState()) {
    on<NameChanged>(_onNameChanged);
    on<Submitted>(_onSubmitted);
  }

  final LibraryApi _libraryApi;

  void _onNameChanged(
      NameChanged event,
      Emitter<LibraryAddState> emit
      ) {
    final name = LibraryName.dirty(event.name);
    emit(state.copyWith(
      name: name,
      status: Formz.validate([name])
    ));
  }

  void _onSubmitted(
      Submitted event,
      Emitter<LibraryAddState> emit
      ) async {
    if(state.status.isValidated){
      emit(state.copyWith(status: FormzStatus.submissionInProgress));
      try{
        await _libraryApi.createLibrary(name: state.name.value);
        emit(state.copyWith(status: FormzStatus.submissionSuccess));
      }
      catch (_){
        emit(state.copyWith(status: FormzStatus.submissionFailure));
      }
    }
  }
}
