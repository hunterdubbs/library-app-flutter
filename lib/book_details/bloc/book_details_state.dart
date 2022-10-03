part of 'book_details_bloc.dart';

class BookDetailsState extends Equatable {
  const BookDetailsState({
    required this.book,
    required this.library
  });

  final Book book;
  final Library library;

  BookDetailsState copyWith({
    Book? book,
    Library? library
  }) {
    return BookDetailsState(
      book: book ?? this.book,
      library: library ?? this.library
    );
  }

  @override
  List<Object> get props => [book, library];
}