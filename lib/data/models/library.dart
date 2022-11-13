import 'package:equatable/equatable.dart';

class Library extends Equatable {
  const Library({
    required this.id,
    required this.name,
    required this.owner,
    required this.createdDate,
    required this.permissions,
    required this.bookCount
  });

  final int id;
  final String name;
  final String owner;
  final DateTime createdDate;
  final int permissions;
  final int bookCount;

  Library.fromJson(Map json)
      : id = json['library']['id'],
        name = json['library']['name'],
        owner = json['library']['owner'],
        createdDate = DateTime.parse(json['library']['createdDate']),
        permissions = json['library']['permissions'],
        bookCount = json['bookCount'];

  toJson() => {
    'ID': id,
    'Name': name,
    'Owner': owner,
    'CreatedDate': createdDate,
    'Permissions': permissions,
    'BookCount': bookCount
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
  List<Object?> get props => [id, name, owner, createdDate, permissions, bookCount];
}