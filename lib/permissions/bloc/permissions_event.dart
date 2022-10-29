part of 'permissions_bloc.dart';

abstract class PermissionsEvent extends Equatable {
  const PermissionsEvent();

  @override
  List<Object> get props => [];
}

class LoadPermissions extends PermissionsEvent {
  const LoadPermissions();
}
