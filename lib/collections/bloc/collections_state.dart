part of 'collections_bloc.dart';

enum CollectionsStatus { initial, loading, loaded, errorLoading, modifying, modified }

class CollectionsState extends Equatable {
  const CollectionsState({
    this.collections = const <Collection>[],
    required this.library,
    this.status = CollectionsStatus.initial,
    this.errorMsg = ''
});

  final List<Collection> collections;
  final CollectionsStatus status;
  final Library library;
  final String errorMsg;

  CollectionsState copyWith({
    List<Collection>? collections,
    Library? library,
    CollectionsStatus? status,
    String? errorMsg
}) {
    return CollectionsState(
      collections: collections ?? this.collections,
      library: library ?? this.library,
      status: status ?? this.status,
      errorMsg: errorMsg ?? this.errorMsg
    );
  }

  @override
  List<Object> get props => [collections, status, library, errorMsg];
}