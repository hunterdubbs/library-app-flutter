import 'package:equatable/equatable.dart';
import 'package:library_app/data/models/models.dart';

class FullLibraryPermission extends Equatable {
  const FullLibraryPermission({
    required this.permissions,
    required this.invites
  });

  final List<LibraryPermission> permissions;
  final List<Invite> invites;

  @override
  List<Object> get props => [permissions, invites];
}