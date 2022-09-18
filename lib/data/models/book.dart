import 'package:equatable/equatable.dart';
import 'package:library_app/data/models/author.dart';

class Book extends Equatable {
  const Book({
    required this.id,
    required this.libraryId,
    required this.title,
    required this.synopsis,
    required this.addedDate,
    required this.publishedDate,
    required this.authors
  });

  final int id;
  final int libraryId;
  final String title;
  final String synopsis;
  final DateTime addedDate;
  final DateTime publishedDate;
  final List<Author> authors;

  Book.fromJson(Map json) :
    id = json['id'],
    libraryId = json['libraryID'],
    title = json['title'],
    synopsis = json['synopsis'],
    addedDate = DateTime.parse(json['dateAdded']),
    publishedDate = DateTime.parse(json['datePublished']),
    authors = List<Author>.from(json['authors'].map((i) => Author.fromJson(i))).toList();

  toJson() => {
    'ID': id,
    'LibraryID': libraryId,
    'Title': title,
    'Synopsis': synopsis,
    'DateAdded': addedDate,
    'DatePublished': publishedDate,
    'Authors': authors.map((i) => i.toJson())
  };

  @override
  List<Object> get props => [id, libraryId, title, synopsis, addedDate, publishedDate, authors];
}