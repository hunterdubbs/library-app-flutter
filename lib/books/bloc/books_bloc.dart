import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:library_app/data/library_api.dart';
import 'package:library_app/data/models/models.dart';

part 'books_event.dart';
part 'books_state.dart';

class BooksBloc extends Bloc<BooksEvent, BooksState> {
  BooksBloc({
    required LibraryApi libraryApi,
    required Library library,
    required Collection collection
  })
  : _libraryApi = libraryApi,
  super(BooksState(library: library, collection: collection)){
    on<LoadBooksEvent>(_loadBooks);
  }

  final LibraryApi _libraryApi;

  Future<void> _loadBooks(
      LoadBooksEvent event,
      Emitter<BooksState> emit
      ) async {
    emit(state.copyWith(status: BooksStatus.loading));

    try{
      final books = await _libraryApi.getBooksByCollection(state.collection.id);
      emit(state.copyWith(books: books, status: BooksStatus.loaded));
    }
    catch(_){
      emit(state.copyWith(status: BooksStatus.errorLoading));
    }
  }
}
