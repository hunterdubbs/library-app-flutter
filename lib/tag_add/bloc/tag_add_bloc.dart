import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:library_app/data/library_api.dart';
import 'package:library_app/data/models/models.dart';
import 'package:library_app/tag_add/models/models.dart';

part 'tag_add_event.dart';
part 'tag_add_state.dart';

class TagAddBloc extends Bloc<TagAddEvent, TagAddState> {
  TagAddBloc({
    required LibraryApi libraryApi,
    required int libraryId
  }) : _libraryApi = libraryApi,
    super(TagAddState(libraryId: libraryId)) {
    on<NameChanged>(_nameChanged);
    on<Submitted>(_submitted);
  }

  final LibraryApi _libraryApi;

  void _nameChanged(
      NameChanged event,
      Emitter<TagAddState> emit
      ) {
    final name = Name.dirty(event.name);
    emit(state.copyWith(
      name: name,
      status: Formz.validate([name])
    ));
  }

  void _submitted(
      Submitted event,
      Emitter<TagAddState> emit
      ) async {
    if(state.status.isValidated){
      emit(state.copyWith(status: FormzStatus.submissionInProgress));

      try{
        final tag = await _libraryApi.createTag(libraryId: state.libraryId, name: state.name.value);
        emit(state.copyWith(
          status: FormzStatus.submissionSuccess,
          tag: tag
        ));
      }catch(_){
        emit(state.copyWith(status: FormzStatus.submissionFailure));
      }
    }
  }
}
