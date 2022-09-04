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
}
