import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:library_app/data/library_api.dart';
import 'package:library_app/delete_account/models/models.dart';

part 'delete_account_event.dart';
part 'delete_account_state.dart';

class DeleteAccountBloc extends Bloc<DeleteAccountEvent, DeleteAccountState> {
  DeleteAccountBloc({
    required LibraryApi libraryApi
  }) : _libraryApi = libraryApi,
        super(const DeleteAccountState()) {
    on<PasswordChanged>(_passwordChanged);
    on<Submitted>(_submitted);
  }

  final LibraryApi _libraryApi;

  void _passwordChanged(
      PasswordChanged event,
      Emitter<DeleteAccountState> emit
      ) {
    final password = Password.dirty(event.password);
    emit(state.copyWith(
      password: password,
      status: Formz.validate([password])
    ));
  }

  void _submitted(
      Submitted event,
      Emitter<DeleteAccountState> emit
      ) async {
    if(state.status.isValidated){
      emit(state.copyWith(status: FormzStatus.submissionInProgress));

      try{
        await _libraryApi.deleteAccount(password: state.password.value);
        emit(state.copyWith(status: FormzStatus.submissionSuccess));
      }catch(_){
        emit(state.copyWith(status: FormzStatus.submissionFailure));
      }
    }
  }
}
