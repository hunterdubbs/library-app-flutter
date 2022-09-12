part of 'library_bloc.dart';

abstract class LibraryEvent extends Equatable {
  const LibraryEvent();

  @override
  List<Object> get props => [];
}

class LoadLibrariesEvent extends LibraryEvent {
  const LoadLibrariesEvent();
}

class LibraryDeletedEvent extends LibraryEvent {
  const LibraryDeletedEvent(this.libraryId);

  final int libraryId;

  @override
  List<Object> get props => [libraryId];
}

class LibraryModifiedEvent extends LibraryEvent {
  const LibraryModifiedEvent(this.libraryId, this.name);

  final int libraryId;
  final String name;

  @override
  List<Object> get props => [libraryId, name];
}