import 'package:equatable/equatable.dart';
import 'package:library_app/data/models/author.dart';
import 'package:library_app/data/models/tag.dart';

class Book extends Equatable {
  const Book({
    required this.id,
    required this.libraryId,
    required this.title,
    required this.synopsis,
    required this.addedDate,
    required this.publishedDate,
    required this.authors,
    required this.tags
  });

  final int id;
  final int libraryId;
  final String title;
  final String synopsis;
  final DateTime addedDate;
  final DateTime publishedDate;
  final List<Author> authors;
  final List<Tag> tags;

  Book.fromJson(Map json) :
    id = json['id'],
    libraryId = json['libraryID'],
    title = json['title'],
    synopsis = json['synopsis'],
    addedDate = DateTime.parse(json['dateAdded']),
    publishedDate = DateTime.parse(json['datePublished']),
    authors = List<Author>.from(json['authors'].map((i) => Author.fromJson(i))).toList(),
    tags = List<Tag>.from(json['tags'].map((i) => Tag.fromJson(i))).toList();

  toJson() => {
    'ID': id,
    'LibraryID': libraryId,
    'Title': title,
    'Synopsis': synopsis,
    'DateAdded': addedDate,
    'DatePublished': publishedDate,
    'Authors': authors.map((i) => i.toJson()),
    'Tags': tags.map((i) => i.toJson())
  };

  @override
  List<Object> get props => [id, libraryId, title, synopsis, addedDate, publishedDate, authors, tags];
}