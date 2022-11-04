part of 'books_bloc.dart';

abstract class BooksEvent extends Equatable {
  const BooksEvent();

  @override
  List<Object> get props => [];
}

class LoadBooksEvent extends BooksEvent {
  const LoadBooksEvent();
}

class BookDeletedEvent extends BooksEvent {
  const BookDeletedEvent(this.bookId);

  final int bookId;

  @override
  List<Object> get props => [bookId];
}

class QueryTextChanged extends BooksEvent {
  const QueryTextChanged(this.queryText);

  final String queryText;

  @override
  List<Object> get props => [queryText];
}

class QueryTypeChanged extends BooksEvent {
  const QueryTypeChanged(this.queryType);

  final QueryType queryType;

  @override
  List<Object> get props => [queryType];
}

class SortTypeChanged extends BooksEvent {
  const SortTypeChanged(this.sortType);

  final SortType sortType;

  @override
  List<Object> get props => [sortType];
}
