import 'package:equatable/equatable.dart';

class Collection extends Equatable {
  const Collection({
    required this.id,
    required this.libraryId,
    required this.parentCollectionId,
    required this.name,
    required this.description,
    required this.isUserModifiable,
    required this.bookCount
  });

  final int id;
  final int libraryId;
  final int parentCollectionId;
  final String name;
  final String description;
  final bool isUserModifiable;
  final int bookCount;

  Collection.fromJson(Map json)
  : id = json['collection']['id'],
  libraryId = json['collection']['libraryID'],
  parentCollectionId = json['collection']['parentCollectionID'],
  name = json['collection']['name'],
  description = json['collection']['description'],
  isUserModifiable = json['collection']['isUserModifiable'],
  bookCount = json['bookCount'];

  toJson() => {
    'id': id,
    'libraryID': libraryId,
    'parentCollectionID': parentCollectionId,
    'name': name,
    'description': description,
    'isUserModifiable': isUserModifiable,
    'bookCount': bookCount
  };

  @override
  List<Object> get props => [id, libraryId, parentCollectionId, name, description, isUserModifiable, bookCount];
}