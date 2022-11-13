import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:library_app/data/library_api.dart';
import 'package:library_app/data/models/models.dart';

part 'tags_event.dart';
part 'tags_state.dart';

class TagsBloc extends Bloc<TagsEvent, TagsState> {
  TagsBloc({
    required LibraryApi libraryApi,
    required int libraryId
  }) : _libraryApi = libraryApi,
        super(TagsState(libraryId: libraryId)) {
    on<LoadTags>(_loadTags);
  }

  final LibraryApi _libraryApi;

  void _loadTags(
      LoadTags event,
      Emitter<TagsState> emit
      ) async {
    emit(state.copyWith(status: TagsStatus.loading));

    try{
      final tags = await _libraryApi.getTags(libraryId: state.libraryId);
      emit(state.copyWith(
        tags: tags,
        status: TagsStatus.loaded
      ));
    }catch(_){
      emit(state.copyWith(status: TagsStatus.errorLoading));
    }
  }
}
