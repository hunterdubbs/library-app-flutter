part of 'permissions_bloc.dart';

enum PermissionsStatus{ initial, loading, loaded, error, modifying, modified, errorModifying }

class PermissionsState extends Equatable {
  const PermissionsState({
    this.status = PermissionsStatus.initial,
    required this.library,
    this.permissions = const <LibraryPermission>[],
    this.invites = const <Invite>[],
    this.errorMsg = ''
  });

  final PermissionsStatus status;
  final Library library;
  final List<LibraryPermission> permissions;
  final List<Invite> invites;
  final String errorMsg;

  PermissionsState copyWith({
    PermissionsStatus? status,
    Library? library,
    List<LibraryPermission>? permissions,
    List<Invite>? invites,
    String? errorMsg
  }) {
    return PermissionsState(
      status: status ?? this.status,
      library: library ?? this.library,
      permissions: permissions ?? this.permissions,
      invites: invites ?? this.invites,
      errorMsg: errorMsg ?? this.errorMsg
    );
  }

  @override
  List<Object> get props => [status, library, permissions, invites, errorMsg];
}