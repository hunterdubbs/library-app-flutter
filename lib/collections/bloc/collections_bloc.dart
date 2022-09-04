import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_app/data/library_api.dart';
import 'package:library_app/data/models/models.dart';

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
  }

  final LibraryApi _libraryApi;

    void _loadCollections(
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
}
