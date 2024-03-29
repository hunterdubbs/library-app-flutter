import 'package:equatable/equatable.dart';

class CollectionMembership extends Equatable {
  const CollectionMembership({
    required this.id,
    required this.libraryId,
    required this.parentCollectionId,
    required this.name,
    required this.description,
    required this.isMember,
    required this.isUserModifiable
  });

  final int id;
  final int libraryId;
  final int parentCollectionId;
  final String name;
  final String description;
  final bool isMember;
  final bool isUserModifiable;

  CollectionMembership.fromJson(Map json)
      : id = json['id'],
        libraryId = json['libraryID'],
        parentCollectionId = json['parentCollectionID'],
        name = json['name'],
        description = json['description'],
        isMember = json['isMember'],
        isUserModifiable = json['isUserModifiable'];

  toJson() => {
    'id': id,
    'libraryID': libraryId,
    'parentCollectionID': parentCollectionId,
    'name': name,
    'description': description,
    'isMember': isMember,
    'isUserModifiable': isUserModifiable
  };

  @override
  List<Object> get props => [id, libraryId, parentCollectionId, name, description, isMember, isUserModifiable];
}