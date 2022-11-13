import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_app/data/library_api.dart';
import 'package:library_app/data/models/models.dart';
import 'package:library_app/collections/models/models.dart';

part 'collections_event.dart';
part 'collections_state.dart';

class CollectionsBloc extends Bloc<CollectionsEvent, CollectionsState> {
    CollectionsBloc({
      required LibraryApi libraryApi,
      required Library library
})
  : _libraryApi = libraryApi,
    super(CollectionsState(library: library)) {
      on<LoadCollectionsEvent>(_loadCollections);
      on<CollectionDeletedEvent>(_deleteCollection);
      on<QueryTextChanged>(_queryTextChanged);
  }

  final LibraryApi _libraryApi;

    Future<void> _loadCollections(
        LoadCollectionsEvent event,
        Emitter<CollectionsState> emit
        ) async {
      emit(state.copyWith(status: CollectionsStatus.loading));

      try{
        final collections = await _libraryApi.getCollections(state.library.id);
        emit(state.copyWith(collections: collections, status: CollectionsStatus.loaded));
      }
      catch(_) {
        emit(state.copyWith(status: CollectionsStatus.errorLoading));
      }
    }

    Future<void> _deleteCollection(
        CollectionDeletedEvent event,
        Emitter<CollectionsState> emit
        ) async {
      emit(state.copyWith(status: CollectionsStatus.modifying));

      try{
        await _libraryApi.deleteCollection(collectionId: event.collectionId);
        emit(state.copyWith(status: CollectionsStatus.modified));
      }catch(_){
        emit(state.copyWith(status: CollectionsStatus.loaded, errorMsg: 'Error deleting collection'));
      }
    }

    void _queryTextChanged(
        QueryTextChanged event,
        Emitter<CollectionsState> emit
        ) {
      emit(state.copyWith(
        query: state.query.copyWith(
          searchTerm: event.searchTerm
        )
      ));
    }
}
