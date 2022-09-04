part of 'library_bloc.dart';

enum LibraryStatus { initial, loading, loaded, errorLoading }

class LibraryState extends Equatable {
  const LibraryState._({
    this.libraries = const <Library>[],
    this.status = LibraryStatus.initial
  });

  final List<Library> libraries;
  final LibraryStatus status;

  const LibraryState.initial() : this._();

  const LibraryState.loading() : this._(status: LibraryStatus.loading);

  const LibraryState.loaded(List<Library> libraries) : this._(libraries: libraries, status: LibraryStatus.loaded);

  const LibraryState.errorLoading() : this._(status: LibraryStatus.errorLoading);

  LibraryState copyWith({
  List<Library>? libraries,
    LibraryStatus? status
}) {
    return LibraryState._(
      libraries: libraries ?? this.libraries,
      status: status ?? this.status
    );
  }

  @override
  List<Object> get props => [libraries, status];
}

