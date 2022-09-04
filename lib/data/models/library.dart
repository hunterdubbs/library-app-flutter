import 'package:equatable/equatable.dart';

class Library extends Equatable {
  const Library({
    required this.id,
    required this.name,
    required this.owner,
    required this.createdDate,
    required this.permissions
  });

  final int id;
  final String name;
  final String owner;
  final DateTime createdDate;
  final int permissions;

  Library.fromJson(Map json)
      : id = json['id'],
        name = json['name'],
        owner = json['owner'],
        createdDate = DateTime.parse(json['createdDate']),
        permissions = json['permissions'];

  toJson() => {
    'ID': id,
    'Name': name,
    'Owner': owner,
    'CreatedDate': createdDate,
    'Permissions': permissions
  };

  String get permissionsName {
    switch(permissions){
      case 1:
        return 'View Only';
      case 2:
        return 'Contributor';
      case 3:
        return 'Owner';
        default:
          return 'None';
    }
  }

  @override
  List<Object?> get props => [id, name, owner, createdDate, permissions];
}