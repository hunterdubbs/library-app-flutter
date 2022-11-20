part of 'isbn_lookup_bloc.dart';

abstract class IsbnLookupEvent extends Equatable {
  const IsbnLookupEvent();

  @override
  List<Object> get props => [];
}

class IsbnChanged extends IsbnLookupEvent {
  const IsbnChanged(this.isbn);

  final String isbn;

  @override
  List<Object> get props => [isbn];
}

class Submitted extends IsbnLookupEvent {
  const Submitted();
}
