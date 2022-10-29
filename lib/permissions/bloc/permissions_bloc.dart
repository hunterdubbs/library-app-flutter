import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:library_app/data/library_api.dart';
import 'package:library_app/data/models/models.dart';

part 'permissions_event.dart';
part 'permissions_state.dart';

class PermissionsBloc extends Bloc<PermissionsEvent, PermissionsState> {
  PermissionsBloc({
    required LibraryApi libraryApi,
    required Library library
  }) : _libraryApi = libraryApi,
  super(PermissionsState(library : library)){
    on<LoadPermissions>(_loadPermissions);
  }

  final LibraryApi _libraryApi;

  void _loadPermissions(
      LoadPermissions event,
      Emitter<PermissionsState> emit
      ) async {
    emit(state.copyWith(status: PermissionsStatus.loading));
    try{
      final permissions = await _libraryApi.getLibraryPermissions(libraryId: state.library.id);
      emit(state.copyWith(
          status: PermissionsStatus.loaded,
          permissions: permissions.permissions,
          invites: permissions.invites
      ));
    }catch(_){
      emit(state.copyWith(status: PermissionsStatus.error, errorMsg: 'Error loading library permissions'));
    }
  }
}
