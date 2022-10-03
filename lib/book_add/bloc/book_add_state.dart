part of 'book_add_bloc.dart';

class BookAddState extends Equatable {
  const BookAddState({
    this.status = FormzStatus.pure,
    required this.libraryId,
    required this.collectionId,
    this.bookId = 0,
    this.isEdit = false,
    this.title = const Title.pure(),
    this.synopsis = const Synopsis.pure(),
    required this.datePublished,
    required this.authors
  });

  final FormzStatus status;
  final int libraryId;
  final int collectionId;
  final int bookId;
  final bool isEdit;
  final Title title;
  final Synopsis synopsis;
  final DatePublished datePublished;
  final List<Author> authors;

  static BookAddState initial({
    Book? book,
    required int libraryID,
    required int collectionID
  }){
    if(book != null){
      return BookAddState(
        status: FormzStatus.valid,
        libraryId: libraryID,
        collectionId: collectionID,
        bookId: book.id,
        isEdit: true,
        title: Title.dirty(book.title),
        synopsis: Synopsis.dirty(book.synopsis),
        datePublished: DatePublished.dirty(book.publishedDate),
        authors: book.authors
      );
    }else{
      return BookAddState(libraryId: libraryID, collectionId: collectionID, datePublished: DatePublished.pure(), authors: const <Author>[]);
    }
  }

  BookAddState copyWith({
    FormzStatus? status,
    int? libraryId,
    int? collectionId,
    int? bookId,
    bool? isEdit,
    Title? title,
    Synopsis? synopsis,
    DatePublished? datePublished,
    List<Author>? authors
  }) {
    return BookAddState(
      status: status ?? this.status,
      libraryId: libraryId ?? this.libraryId,
      collectionId: collectionId ?? this.collectionId,
      bookId: bookId ?? this.bookId,
      isEdit: isEdit ?? this.isEdit,
      title: title ?? this.title,
      synopsis: synopsis ?? this.synopsis,
      datePublished: datePublished ?? this.datePublished,
      authors: authors ?? this.authors
    );
  }

  @override
  List<Object> get props => [status, libraryId, collectionId, bookId, isEdit, title, synopsis, datePublished, authors];
}