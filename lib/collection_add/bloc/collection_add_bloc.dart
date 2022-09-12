import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:library_app/collection_add/models/models.dart';
import 'package:library_app/data/library_api.dart';

import '../../data/models/models.dart';

part 'collection_add_event.dart';
part 'collection_add_state.dart';

class CollectionAddBloc extends Bloc<CollectionAddEvent, CollectionAddState> {
  CollectionAddBloc({
    required LibraryApi libraryApi,
    required int libraryId,
    Collection? collection
  }) : _libraryApi = libraryApi,
      super(CollectionAddState.initial(libraryId: libraryId, collection: collection)) {
    on<NameChanged>(_onNameChanged);
    on<DescriptionChanged>(_onDescriptionChanged);
    on<Submitted>(_onSubmitted);
  }

  final LibraryApi _libraryApi;

  void _onNameChanged(
      NameChanged event,
      Emitter<CollectionAddState> emit
      ) {
    final name = CollectionName.dirty(event.name);
    emit(state.copyWith(
      name: name,
      status: Formz.validate([name, state.description])
    ));
  }

  void _onDescriptionChanged(
      DescriptionChanged event,
      Emitter<CollectionAddState> emit
      ) {
    final description = CollectionDescription.dirty(event.description);
    emit(state.copyWith(
      description: description,
      status: Formz.validate([state.name, description])
    ));
  }

  void _onSubmitted(
      Submitted event,
      Emitter<CollectionAddState> emit
      ) async {
    if(state.status.isValidated){
      emit(state.copyWith(status: FormzStatus.submissionInProgress));
      try{
        if(state.isEdit){
          await _libraryApi.modifyCollection(collectionId: state.collectionId, name: state.name.value, description: state.description.value);
        }else{
          await _libraryApi.createCollection(libraryId: state.libraryId, parentCollectionId: 0, name: state.name.value, description: state.description.value);
        }
        emit(state.copyWith(status: FormzStatus.submissionSuccess));
      }catch(_){
        emit(state.copyWith(status: FormzStatus.submissionFailure));
      }
    }
  }
}
