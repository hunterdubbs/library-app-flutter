import 'package:equatable/equatable.dart';

class Invite extends Equatable {
  const Invite({
    required this.id,
    required this.libraryId,
    required this.libraryName,
    required this.inviterId,
    required this.inviterUsername,
    required this.recipientId,
    required this.recipientUsername,
    required this.permissionLevel,
    required this.sent
  });

  final int id;
  final int libraryId;
  final String libraryName;
  final String inviterId;
  final String inviterUsername;
  final String recipientId;
  final String recipientUsername;
  final int permissionLevel;
  final DateTime sent;

  String get permissionName {
    switch (permissionLevel) {
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

  Invite.fromJson(Map json)
    : id = json['id'],
      libraryId = json['libraryID'],
      libraryName = json['libraryName'],
      inviterId = json['inviterID'],
      inviterUsername = json['inviterUsername'],
      recipientId = json['recipientID'],
      recipientUsername = json['recipientUsername'],
      permissionLevel = json['permissionLevel'],
      sent = DateTime.parse(json['sent']);

  @override
  List<Object> get props => [id, libraryId, libraryName, inviterId, inviterUsername, recipientId, recipientUsername, permissionLevel, sent];
}