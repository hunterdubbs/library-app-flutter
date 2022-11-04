part of 'books_bloc.dart';

enum BooksStatus{ initial, loading, loaded, errorLoading, modifying, modified }

class BooksState extends Equatable {
  const BooksState({
    this.books = const <Book>[],
    this.status = BooksStatus.initial,
    required this.library,
    required this.collection,
    this.errorMsg = '',
    this.query = const Query(
      searchTerm: '',
      queryType: QueryType.title,
      sortType: SortType.dateAddedNewest
    )
  });

  final List<Book> books;
  final BooksStatus status;
  final Library library;
  final Collection collection;
  final String errorMsg;
  final Query query;

  BooksState copyWith({
    List<Book>? books,
    BooksStatus? status,
    Library? library,
    Collection? collection,
    String? errorMsg,
    Query? query
  }) {
    return BooksState(
      books: books ?? this.books,
      status: status ?? this.status,
      library: library ?? this.library,
      collection: collection ?? this.collection,
      errorMsg: errorMsg ?? this.errorMsg,
      query: query ?? this.query
    );
  }

  List<Book> get filteredBooks {
    var filteredBooks = books;
    if(query.searchTerm.isNotEmpty){
      final normalizedSearchTerm = query.searchTerm.toLowerCase().trim();
      switch(query.queryType){
        case QueryType.title:
          filteredBooks = filteredBooks.where((b) => b.title.toLowerCase().trim().contains(normalizedSearchTerm)).toList();
          break;
        case QueryType.author:
          filteredBooks = filteredBooks.where((b) => b.authors.any((a) => a.displayName.toLowerCase().contains(normalizedSearchTerm))).toList();
          break;
      }
    }
    switch(query.sortType){
      case SortType.alphabetic:
        filteredBooks.sort((a, b) => a.title.compareTo(b.title));
        break;
      case SortType.dateAddedNewest:
        filteredBooks.sort((a, b) => b.addedDate.compareTo(a.addedDate));
        break;
      case SortType.dateAddedOldest:
        filteredBooks.sort((a, b) => a.addedDate.compareTo(b.addedDate));
    }
    return filteredBooks;
  }

  @override
  List<Object> get props => [books, status, library, collection, errorMsg, query];
}