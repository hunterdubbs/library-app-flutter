import 'package:equatable/equatable.dart';

class Author extends Equatable {
  const Author({
    required this.id,
    required this.firstName,
    required this.lastName
  });

  final int id;
  final String firstName;
  final String lastName;

  Author.fromJson(Map json) :
    id = json['id'],
    firstName = json['firstName'],
    lastName = json['lastName'];

  toJson() => {
    'ID': id,
    'FirstName': firstName,
    'LastName': lastName
  };

  @override
  String toString() {
    return '$firstName $lastName';
  }

  String get displayName => '$firstName $lastName';

  @override
  List<Object> get props => [id, firstName, lastName];
}