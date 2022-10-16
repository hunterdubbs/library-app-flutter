import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:library_app/data/library_api.dart';
import 'package:library_app/data/models/models.dart';

part 'book_collections_event.dart';
part 'book_collections_state.dart';

class BookCollectionsBloc extends Bloc<BookCollectionsEvent, BookCollectionsState> {
  BookCollectionsBloc({
    required LibraryApi libraryApi,
    required Book book,
  })
  : _libraryApi = libraryApi,
  super(BookCollectionsState(book: book)){
    on<LoadCollectionMemberships>(_loadMemberships);
    on<SubmitCollectionMemberships>(_submit);
    on<CheckboxToggled>(_checkboxToggled);
  }

  final LibraryApi _libraryApi;

  Future<void> _loadMemberships(
      LoadCollectionMemberships event,
      Emitter<BookCollectionsState> emit
    ) async {
    emit(state.copyWith(status: BookCollectionsStatus.loading));

    try{
      final memberships = await _libraryApi.getCollectionsOfBook(state.book.id);
      emit(state.copyWith(status: BookCollectionsStatus.loaded, collections: memberships));
    }catch(_){
      emit(state.copyWith(status: BookCollectionsStatus.error, errorMsg: 'Error loading collections'));
    }
  }

  Future<void> _submit(
      SubmitCollectionMemberships event,
      Emitter<BookCollectionsState> emit
      ) async {
    emit(state.copyWith(status: BookCollectionsStatus.submitting));

    try{
      await _libraryApi.modifyCollectionsOfBook(state.book.id, state.collections.where((c) => c.isMember).map((c) => c.id).toList());
      emit(state.copyWith(status: BookCollectionsStatus.submitted));
    }catch(_){
      emit(state.copyWith(status: BookCollectionsStatus.error, errorMsg: 'Error modifying collections'));
    }
  }

  Future<void> _checkboxToggled(
      CheckboxToggled event,
      Emitter<BookCollectionsState> emit
      ) async {
    final int index = state.collections.indexWhere((c) => c.id == event.collectionId);
    final CollectionMembership changingObj = state.collections[index];
    final CollectionMembership changedObj = CollectionMembership(
      id: changingObj.id,
      libraryId: changingObj.libraryId,
      name: changingObj.name,
      description: changingObj.description,
      parentCollectionId:  changingObj.parentCollectionId,
      isMember: !changingObj.isMember
    );

    state.collections.removeAt(index);
    state.collections.insert(index, changedObj);
    emit(state.copyWith(collections: state.collections));
  }
}
