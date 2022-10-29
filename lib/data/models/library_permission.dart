import 'package:equatable/equatable.dart';

class LibraryPermission extends Equatable {
  const LibraryPermission({
    required this.userId,
    required this.username,
    required this.permission,
    required this.isInvite
  });

  final String userId;
  final String username;
  final int permission;
  final bool isInvite;

  String get permissionName {
    switch(permission){
      case 3:
        return 'Owner';
      case 2:
        return 'Editor';
      case 1:
        return 'Viewer';
      case -1:
        return 'Invite';
      default:
        return 'Unknown';
    }
  }


  LibraryPermission.fromJson(Map json)
    : userId = json['userID'],
      username = json['username'],
      permission = json['permissionLevel'],
      isInvite = json['isInvite'];

  @override
  List<Object> get props => [userId, username, permission, isInvite];
}