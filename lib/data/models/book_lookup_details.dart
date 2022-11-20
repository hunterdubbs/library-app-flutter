import 'package:equatable/equatable.dart';
import 'package:library_app/data/models/author.dart';

class BookLookupDetails extends Equatable {
  const BookLookupDetails({
    required this.title,
    required this.description,
    required this.publishedDate,
    required this.authors
  });

  final String title;
  final String description;
  final DateTime publishedDate;
  final List<Author> authors;

  BookLookupDetails.fromJson(Map json) :
      title = json['title'],
      description = json['description'],
      publishedDate = DateTime.parse(json['published']),
      authors = List<Author>.from(json['authors'].map((i) => Author.fromJson(i))).toList();

  @override
  List<Object> get props => [title, description, publishedDate, authors];
}