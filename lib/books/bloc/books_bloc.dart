import 'package:darq/darq.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:library_app/books/models/models.dart';
import 'package:library_app/data/library_api.dart';
import 'package:library_app/data/models/models.dart';
import 'package:library_app/repositories/prefs_repository.dart';

part 'books_event.dart';
part 'books_state.dart';

class BooksBloc extends Bloc<BooksEvent, BooksState> {
  BooksBloc({
    required LibraryApi libraryApi,
    required Library library,
    required Collection collection,
    required PrefsRepository prefsRepository,
    List<Book> books = const <Book>[],
    Query query = const Query(searchTerm: '', queryType: QueryType.title, sortType: SortType.dateAddedNewest, editorVisible: false),
    BooksStatus status = BooksStatus.initial,
    bool isGroupable = true
  })
  : _libraryApi = libraryApi,
    _prefsRepository = prefsRepository,
  super(BooksState(library: library, collection: collection, books: books, query: query, status: status, isGroupable: isGroupable)){
    on<LoadBooksEvent>(_loadBooks);
    on<BookDeletedEvent>(_deleteBook);
    on<QueryTextChanged>(_queryTextChanged);
    on<QueryTypeChanged>(_queryTypeChanged);
    on<SortTypeChanged>(_sortTypeChanged);
    on<QueryEditorVisibilityChanged>(_queryEditorVisibilityChanged);
    on<ToggleQueryEditorVisible>(_toggleQueryEditorVisible);
    on<ToggleSeriesGroup>(_toggleSeriesGroup);
  }

  final LibraryApi _libraryApi;
  final PrefsRepository _prefsRepository;

  Future<void> _loadBooks(
      LoadBooksEvent event,
      Emitter<BooksState> emit
      ) async {
    emit(state.copyWith(status: BooksStatus.loading));

    try{
      final books = await _libraryApi.getBooksByCollection(state.collection.id);
      final prefs = await _prefsRepository.prefs;
      emit(state.copyWith(books: books, status: BooksStatus.loaded, groupSeries: prefs.groupSeries));
    }
    catch(_){
      emit(state.copyWith(status: BooksStatus.errorLoading));
    }
  }

  Future<void> _deleteBook(
      BookDeletedEvent event,
      Emitter<BooksState> emit
      ) async {
    emit(state.copyWith(status: BooksStatus.modifying));

    try{
      await _libraryApi.deleteBook(bookId: event.bookId);
      emit(state.copyWith(status: BooksStatus.modified));
    }catch(_){
      emit(state.copyWith(status: BooksStatus.loaded, errorMsg: 'Error deleting book'));
    }
  }

  void _queryTextChanged(
      QueryTextChanged event,
      Emitter<BooksState> emit
      ) {
    emit(state.copyWith(
      query: state.query.copyWith(
        searchTerm: event.queryText
      )
    ));
  }

  void _queryTypeChanged(
      QueryTypeChanged event,
      Emitter<BooksState> emit
      ) {
    emit(state.copyWith(
      query: state.query.copyWith(
        queryType: event.queryType
      )
    ));
  }

  void _sortTypeChanged(
      SortTypeChanged event,
      Emitter<BooksState> emit
      ) {
    emit(state.copyWith(
      query: state.query.copyWith(
        sortType: event.sortType
      )
    ));
  }

  void _queryEditorVisibilityChanged(
      QueryEditorVisibilityChanged event,
      Emitter<BooksState> emit
      ) {
    emit(state.copyWith(
      query: state.query.copyWith(
        editorVisible: event.editorVisible
      )
    ));
  }

  void _toggleQueryEditorVisible(
      ToggleQueryEditorVisible event,
      Emitter<BooksState> emit
      ) {
    emit(state.copyWith(
      query: state.query.copyWith(
        editorVisible: !state.query.editorVisible
      )
    ));
  }

  Future<void> _toggleSeriesGroup(
      ToggleSeriesGroup event,
      Emitter<BooksState> emit
      ) async {
    bool newState = !state.groupSeries;
    var prefs = await _prefsRepository.prefs;
    prefs.groupSeries = newState;
    _prefsRepository.prefs = prefs;

    if(newState) {
      emit(state.copyWith(
        groupSeries: newState,
        books: state.filteredBooks
      ));
    } else {
      emit(state.copyWith(
          groupSeries: newState
      ));
    }
  }
}
