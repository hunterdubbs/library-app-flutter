import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:library_app/data/library_api.dart';
import 'package:library_app/data/models/models.dart';

part 'book_details_event.dart';
part 'book_details_state.dart';

class BookDetailsBloc extends Bloc<BookDetailsEvent, BookDetailsState> {
  BookDetailsBloc({
    required LibraryApi libraryApi,
    required Book book,
    required Library library
  }) : _libraryApi = libraryApi,
        super(BookDetailsState(book: book, library: library));

  final LibraryApi _libraryApi;
}
