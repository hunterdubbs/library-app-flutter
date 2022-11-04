part of 'permissions_bloc.dart';

abstract class PermissionsEvent extends Equatable {
  const PermissionsEvent();

  @override
  List<Object> get props => [];
}

class LoadPermissions extends PermissionsEvent {
  const LoadPermissions();
}

class DeleteInvite extends PermissionsEvent {
  const DeleteInvite(this.invite);

  final Invite invite;

  @override
  List<Object> get props => [invite];
}

class DeletePermission extends PermissionsEvent {
  const DeletePermission(this.permission);

  final LibraryPermission permission;

  @override
  List<Object> get props => [permission];
}
