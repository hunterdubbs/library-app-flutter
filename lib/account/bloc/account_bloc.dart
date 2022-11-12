import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:library_app/data/library_api.dart';
import 'package:library_app/data/models/models.dart';

part 'account_event.dart';
part 'account_state.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  AccountBloc({
    required LibraryApi libraryApi
  }) : _libraryApi = libraryApi,
        super(const AccountState()) {
    on<LoadAccount>(_loadAccount);
  }

  final LibraryApi _libraryApi;

  void _loadAccount(
      LoadAccount event,
      Emitter<AccountState> emit
      ) async {
    emit(state.copyWith(status: AccountStatus.loading));

    try{
      final info = await _libraryApi.loadAccountInfo();
      emit(state.copyWith(
        status: AccountStatus.loaded,
        accountInfo: info
      ));
    }catch(_){
      emit(state.copyWith(
        status: AccountStatus.errorLoading,
        errorMsg: 'Error loading account'
      ));
    }
  }
}
