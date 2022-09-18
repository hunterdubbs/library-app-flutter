part of 'books_bloc.dart';

enum BooksStatus{ initial, loading, loaded, errorLoading, modifying, modified }

class BooksState extends Equatable {
  const BooksState({
    this.books = const <Book>[],
    this.status = BooksStatus.initial,
    required this.library,
    required this.collection,
    this.errorMsg = ''
  });

  final List<Book> books;
  final BooksStatus status;
  final Library library;
  final Collection collection;
  final String errorMsg;

  BooksState copyWith({
    List<Book>? books,
    BooksStatus? status,
    Library? library,
    Collection? collection,
    String? errorMsg
  }) {
    return BooksState(
      books: books ?? this.books,
      status: status ?? this.status,
      library: library ?? this.library,
      collection: collection ?? this.collection,
      errorMsg: errorMsg ?? this.errorMsg
    );
  }

  @override
  List<Object> get props => [books, status, library, collection, errorMsg];
}