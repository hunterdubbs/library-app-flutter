import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:library_app/data/library_api.dart';
import 'package:library_app/data/models/book_lookup_details.dart';
import 'package:library_app/isbn_lookup/models/models.dart';

part 'isbn_lookup_event.dart';
part 'isbn_lookup_state.dart';

class IsbnLookupBloc extends Bloc<IsbnLookupEvent, IsbnLookupState> {
  IsbnLookupBloc({
    required LibraryApi libraryApi
  }) : _libraryApi = libraryApi,
    super(const IsbnLookupState()) {
    on<IsbnChanged>(_isbnChanged);
    on<Submitted>(_submitted);
  }

  final LibraryApi _libraryApi;

  void _isbnChanged(
      IsbnChanged event,
      Emitter<IsbnLookupState> emit
      ) {
    final isbn = Isbn.dirty(event.isbn);
    emit(state.copyWith(
      isbn: isbn,
      status: Formz.validate([isbn])
    ));
  }

  void _submitted(
      Submitted event,
      Emitter<IsbnLookupState> emit
      ) async {
    if(state.status.isValidated) {
      emit(state.copyWith(status: FormzStatus.submissionInProgress));
      try{
        final details = await _libraryApi.lookupByISBN(isbn: state.isbn.value);
        emit(state.copyWith(
          details: details,
          status: FormzStatus.submissionSuccess
        ));
      }catch(_){
        emit(state.copyWith(status: FormzStatus.submissionFailure));
      }
    }
  }
}
