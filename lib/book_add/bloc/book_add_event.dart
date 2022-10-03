part of 'book_add_bloc.dart';

abstract class BookAddEvent extends Equatable {
  const BookAddEvent();

  @override
  List<Object> get props => [];
}

class TitleChanged extends BookAddEvent{
  const TitleChanged(this.title);

  final String title;

  @override
  List<Object> get props => [title];
}

class SynopsisChanged extends BookAddEvent{
  const SynopsisChanged(this.synopsis);

  final String synopsis;

  @override
  List<Object> get props => [synopsis];
}

class DatePublishedChanged extends BookAddEvent{
  const DatePublishedChanged(this.datePublished);

  final DateTime datePublished;

  @override
  List<Object> get props => [datePublished];
}

class AuthorAdded extends BookAddEvent{
  const AuthorAdded(this.author);

  final Author author;

  @override
  List<Object> get props => [author];
}

class AuthorRemoved extends BookAddEvent{
  const AuthorRemoved(this.authorId);

  final int authorId;

  @override
  List<Object> get props => [authorId];
}

class Submitted extends BookAddEvent{
  const Submitted();
}