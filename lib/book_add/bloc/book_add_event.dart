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

class SeriesChanged extends BookAddEvent{
  const SeriesChanged(this.series);

  final String series;

  @override
  List<Object> get props => [series];
}

class VolumeChanged extends BookAddEvent{
  const VolumeChanged(this.volume);

  final String volume;

  @override
  List<Object> get props => [volume];
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

class TagAdded extends BookAddEvent {
  const TagAdded(this.tag);

  final Tag tag;

  @override
  List<Object> get props => [tag];
}

class TagRemoved extends BookAddEvent {
  const TagRemoved(this.tagId);

  final int tagId;

  @override
  List<Object> get props => [tagId];
}

class Submitted extends BookAddEvent{
  const Submitted();
}

class DetailsReturned extends BookAddEvent {
  const DetailsReturned(this.details);

  final BookLookupDetails details;

  @override
  List<Object> get props => [details];
}