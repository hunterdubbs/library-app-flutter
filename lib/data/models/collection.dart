import 'package:equatable/equatable.dart';

class Collection extends Equatable {
  const Collection({
    required this.id,
    required this.libraryId,
    required this.parentCollectionId,
    required this.name,
    required this.description
  });

  final int id;
  final int libraryId;
  final int parentCollectionId;
  final String name;
  final String description;

  Collection.fromJson(Map json)
  : id = json['id'],
  libraryId = json['libraryID'],
  parentCollectionId = json['parentCollectionID'],
  name = json['name'],
  description = json['description'];

  toJson() => {
    'id': id,
    'libraryID': libraryId,
    'parentCollectionID': parentCollectionId,
    'name': name,
    'description': description
  };

  @override
  List<Object> get props => [id, libraryId, parentCollectionId, name, description];
}