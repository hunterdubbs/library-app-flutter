part of 'isbn_lookup_bloc.dart';

class IsbnLookupState extends Equatable {
  const IsbnLookupState({
    this.status = FormzStatus.pure,
    this.isbn = const Isbn.pure(),
    this.details
  });

  final FormzStatus status;
  final Isbn isbn;
  final BookLookupDetails? details;

  IsbnLookupState copyWith({
    FormzStatus? status,
    Isbn? isbn,
    BookLookupDetails? details
  }) {
    return IsbnLookupState(
      status: status ?? this.status,
      isbn: isbn ?? this.isbn,
      details : details ?? this.details
    );
  }

  @override
  List<Object> get props => [status, isbn];
}