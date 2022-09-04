part of 'library_add_bloc.dart';

abstract class LibraryAddEvent extends Equatable {
  const LibraryAddEvent();

  @override
  List<Object> get props => [];
}

class NameChanged extends LibraryAddEvent {
  const NameChanged(this.name);

  final String name;

  @override
  List<Object> get props => [name];
}

class Submitted extends LibraryAddEvent{
  const Submitted();
}
