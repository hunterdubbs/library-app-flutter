import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:library_app/book_add/models/models.dart';
import 'package:library_app/data/library_api.dart';
import 'package:library_app/data/models/models.dart';

part 'book_add_event.dart';
part 'book_add_state.dart';

class BookAddBloc extends Bloc<BookAddEvent, BookAddState> {
  BookAddBloc({
    required LibraryApi libraryApi,
    required int libraryId,
    required int collectionId,
    Book? book
  }) : _libraryApi = libraryApi,
    super(BookAddState.initial(libraryID: libraryId, collectionID: collectionId, book: book)) {
      on<TitleChanged>(_onTitleChanged);
      on<SynopsisChanged>(_onSynopsisChanged);
      on<DatePublishedChanged>(_onDatePublishedChanged);
      on<Submitted>(_onSubmitted);
      on<AuthorAdded>(_onAuthorAdded);
      on<AuthorRemoved>(_onAuthorRemoved);
      on<TagAdded>(_onTagAdded);
      on<TagRemoved>(_onTagRemoved);
      on<DetailsReturned>(_detailsReturned);
      on<SeriesChanged>(_onSeriesChanged);
      on<VolumeChanged>(_onVolumeChanged);
  }

  final LibraryApi _libraryApi;

  void _onTitleChanged(
      TitleChanged event,
      Emitter<BookAddState> emit
      ) {
    final title = Title.dirty(event.title);
    emit(state.copyWith(
      title: title,
      status: Formz.validate([title, state.synopsis, state.datePublished, state.series, state.volume])
    ));
  }

  void _onSynopsisChanged(
      SynopsisChanged event,
      Emitter<BookAddState> emit
      ) {
    final synopsis = Synopsis.dirty(event.synopsis);
    emit(state.copyWith(
      synopsis: synopsis,
      status: Formz.validate([synopsis, state.title, state.datePublished, state.series, state.volume])
    ));
  }

  void _onSeriesChanged(
      SeriesChanged event,
      Emitter<BookAddState> emit
      ) {
    final series = Series.dirty(event.series);
    emit(state.copyWith(
      series: series,
      status: Formz.validate([series, state.title, state.datePublished, state.synopsis, state.volume])
    ));
  }

  void _onVolumeChanged(
      VolumeChanged event,
      Emitter<BookAddState> emit
      ) {
    final volume = Volume.dirty(event.volume);
    emit(state.copyWith(
        volume: volume,
        status: Formz.validate([volume, state.title, state.datePublished, state.synopsis, state.series])
    ));
  }

  void _onDatePublishedChanged(
      DatePublishedChanged event,
      Emitter<BookAddState> emit
      ) {
    final datePublished = DatePublished.dirty(event.datePublished);
    emit(state.copyWith(
      datePublished: datePublished,
      status: Formz.validate([datePublished, state.title, state.synopsis, state.series, state.volume])
    ));
  }

  void _onSubmitted(
      Submitted event,
      Emitter<BookAddState> emit
      ) async {
    if(state.status.isValidated){
      emit(state.copyWith(status: FormzStatus.submissionInProgress));
      try{
        if(state.isEdit){
          await _libraryApi.modifyBook(libraryId: state.libraryId, bookId: state.bookId, title: state.title.value, synopsis: state.synopsis.value, datePublished: state.datePublished.value, authors: state.authors, tags: state.tags, series: state.series.value, volume: state.volume.value);
        }else{
          await _libraryApi.createBookInCollection(libraryId: state.libraryId, collectionId: state.collectionId, title: state.title.value, synopsis: state.synopsis.value, datePublished: state.datePublished.value, authors: state.authors, tags: state.tags, series: state.series.value, volume: state.volume.value);
        }
        emit(state.copyWith(status: FormzStatus.submissionSuccess));
      }
      catch(_){
        emit(state.copyWith(status: FormzStatus.submissionFailure));
      }
    }
  }

  void _onAuthorAdded(
      AuthorAdded event,
      Emitter<BookAddState> emit
      ) {
    if(!state.authors.any((a) => a.id == event.author.id)){
      state.authors.add(event.author);
      emit(state.copyWith(authors: state.authors));
    }
  }

  void _onAuthorRemoved(
      AuthorRemoved event,
      Emitter<BookAddState> emit
      ) {
    state.authors.removeWhere((a) => a.id == event.authorId);
    emit(state.copyWith(authors: state.authors));
  }

  void _onTagAdded(
      TagAdded event,
      Emitter<BookAddState> emit
      ) {
    if(!state.tags.any((t) => t.id == event.tag.id)){
      state.tags.add(event.tag);
      emit(state.copyWith(tags: state.tags));
    }
  }

  void _onTagRemoved(
      TagRemoved event,
      Emitter<BookAddState> emit
      ) {
    state.tags.removeWhere((t) => t.id == event.tagId);
    emit(state.copyWith(tags: state.tags));
  }

  void _detailsReturned(
      DetailsReturned event,
      Emitter<BookAddState> emit
      ) {
    final title = Title.dirty(event.details.title);
    final synopsis = Synopsis.dirty(event.details.description);
    final datePublished = DatePublished.dirty(event.details.publishedDate);

    emit(state.copyWith(
      title: title,
      synopsis: synopsis,
      datePublished: datePublished,
      authors: event.details.authors,
      status: Formz.validate([title, synopsis, datePublished])
    ));
  }
}
