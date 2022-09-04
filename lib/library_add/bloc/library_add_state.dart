part of 'library_add_bloc.dart';

class LibraryAddState extends Equatable {
  const LibraryAddState({
    this.status = FormzStatus.pure,
    this.name = const LibraryName.pure()
});

  final FormzStatus status;
  final LibraryName name;

  LibraryAddState copyWith({
    FormzStatus? status,
    LibraryName? name
  }) {
    return LibraryAddState(
      status: status ?? this.status,
      name : name ?? this.name
    );
  }

  @override
  List<Object> get props => [status, name];
}