part of 'books_bloc.dart';

abstract class BooksEvent extends Equatable {
  const BooksEvent();

  @override
  List<Object> get props => [];
}

class LoadBooksEvent extends BooksEvent {
  const LoadBooksEvent();
}
