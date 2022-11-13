import 'package:equatable/equatable.dart';

class Tag extends Equatable {
  const Tag({
    required this.id,
    required this.libraryId,
    required this.name
  });

  final int id;
  final int libraryId;
  final String name;

  Tag.fromJson(Map json):
      id = json['id'],
      libraryId = json['libraryID'],
      name = json['name'];

  toJson() => {
    'ID': id,
    'LibraryID': libraryId,
    'Name': name
  };

  @override
  List<Object> get props => [id, libraryId, name];
}