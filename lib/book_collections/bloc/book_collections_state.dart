part of 'book_collections_bloc.dart';

enum BookCollectionsStatus{ initial, loading, loaded, submitting, submitted, error }

class BookCollectionsState extends Equatable {
  const BookCollectionsState({
    this.status = BookCollectionsStatus.initial,
    required this.book,
    this.collections = const <CollectionMembership>[],
    this.errorMsg = '',
    this.rev = 0
  });

  final BookCollectionsStatus status;
  final Book book;
  final List<CollectionMembership> collections;
  final String errorMsg;
  final int rev; // dirty hack here to trigger a bloc update when changes occur to the list, since the original list is being modified by reference

  BookCollectionsState copyWith({
    BookCollectionsStatus? status,
    Book? book,
    List<CollectionMembership>? collections,
    String? errorMsg,
  }) {
    return BookCollectionsState(
      status: status ?? this.status,
      book: book ?? this.book,
      collections: collections ?? this.collections,
      errorMsg: errorMsg ?? this.errorMsg,
      rev: rev + 1
    );
  }

  @override
  List<Object> get props => [status, book, collections, errorMsg, rev];
}