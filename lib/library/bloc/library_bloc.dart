import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:library_app/data/library_api.dart';

import '../../data/models/models.dart';

part 'library_event.dart';
part 'library_state.dart';

class LibraryBloc extends Bloc<LibraryEvent, LibraryState> {
  LibraryBloc({
    required LibraryApi libraryApi
  })
      : _libraryApi = libraryApi,
        super(const LibraryState.initial()) {
    on<LoadLibrariesEvent>(_loadLibraries);
    on<LibraryDeletedEvent>(_deleteLibrary);
    on<LibraryModifiedEvent>(_modifyLibrary);
  }

  final LibraryApi _libraryApi;

  void _loadLibraries(LoadLibrariesEvent event,
      Emitter<LibraryState> emit) async {
    emit(const LibraryState.loading());

    try {
      final libraries = await _libraryApi.getLibraries();
      emit(LibraryState.loaded(libraries));
    }
    catch (_) {
      emit(const LibraryState.errorLoading());
    }
  }

  void _deleteLibrary(
      LibraryDeletedEvent event,
      Emitter<LibraryState> emit
      ) async {
    emit(state.copyWith(status: LibraryStatus.modifying));

    try{
      if(event.isOwner) {
        await _libraryApi.deleteLibrary(libraryId: event.libraryId);
      }else{
        await _libraryApi.leaveLibrary(libraryId: event.libraryId);
      }
      emit(state.copyWith(status: LibraryStatus.modified));
    }catch(_){
      emit(state.copyWith(status: LibraryStatus.loaded, errorMsg: 'Error deleting library'));
    }
  }

  void _modifyLibrary(
      LibraryModifiedEvent event,
      Emitter<LibraryState> emit
      ) async {
    emit(state.copyWith(status: LibraryStatus.modifying));

    try{
      await _libraryApi.modifyLibrary(libraryId: event.libraryId, name: event.name);
      emit(state.copyWith(status: LibraryStatus.modified));
    }catch(_){
      emit(state.copyWith(status: LibraryStatus.loaded, errorMsg: 'Error modifying library'));
    }
  }
}
