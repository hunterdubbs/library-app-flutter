import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:library_app/data/library_api.dart';
import 'package:library_app/data/models/models.dart';

part 'invite_event.dart';
part 'invite_state.dart';

class InviteBloc extends Bloc<InviteEvent, InviteState> {
  InviteBloc({
      required LibraryApi libraryApi
  }) : _libraryApi = libraryApi,
        super(const InviteState()) {
    on<LoadInvites>(_loadInvites);
    on<AcceptInvite>(_acceptInvite);
    on<RejectInvite>(_rejectInvite);
  }

  final LibraryApi _libraryApi;

  void _loadInvites(
      LoadInvites event,
      Emitter<InviteState> emit
      ) async {
    emit(state.copyWith(status: InviteStatus.loading));
    try{
      final invites = await _libraryApi.getInvites();
      emit(state.copyWith(
        status: InviteStatus.loaded,
        invites: invites
      ));
    }catch(_){
      emit(state.copyWith(status: InviteStatus.error, errorMsg: 'Error loading invites'));
    }
  }

  void _acceptInvite(
      AcceptInvite event,
      Emitter<InviteState> emit
      ) async {
    emit(state.copyWith(status: InviteStatus.modifying));
    try{
       await _libraryApi.acceptInvite(inviteId: event.invite.id);
       emit(state.copyWith(status: InviteStatus.modified));
    }on InviteActionException catch(e){
      emit(state.copyWith(status: InviteStatus.errorModifying, errorMsg: e.msg));
    }catch(_){
      emit(state.copyWith(status: InviteStatus.errorModifying, errorMsg: 'Error accepting invite'));
    }
  }

  void _rejectInvite(
      RejectInvite event,
      Emitter<InviteState> emit
      ) async {
    emit(state.copyWith(status: InviteStatus.modifying));
    try{
      await _libraryApi.rejectInvite(inviteId: event.invite.id);
      emit(state.copyWith(status: InviteStatus.modified));
    }on InviteActionException catch(e){
      emit(state.copyWith(status: InviteStatus.errorModifying, errorMsg: e.msg));
    }catch(_){
      emit(state.copyWith(status: InviteStatus.errorModifying, errorMsg: 'Error rejecting invite'));
    }
  }
}
