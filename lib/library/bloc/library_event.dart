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
  const LibraryDeletedEvent(this.libraryId, this.isOwner);

  final int libraryId;
  final bool isOwner;

  @override
  List<Object> get props => [libraryId, isOwner];
}

class LibraryModifiedEvent extends LibraryEvent {
  const LibraryModifiedEvent(this.libraryId, this.name);

  final int libraryId;
  final String name;

  @override
  List<Object> get props => [libraryId, name];
}