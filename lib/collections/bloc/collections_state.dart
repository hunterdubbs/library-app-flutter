part of 'collections_bloc.dart';

enum CollectionsStatus { initial, loading, loaded, errorLoading }

class CollectionsState extends Equatable {
  const CollectionsState({
    this.collections = const <Collection>[],
    required this.library,
    this.status = CollectionsStatus.initial
});

  final List<Collection> collections;
  final CollectionsStatus status;
  final Library library;

  CollectionsState copyWith({
    List<Collection>? collections,
    Library? library,
    CollectionsStatus? status
}) {
    return CollectionsState(
      collections: collections ?? this.collections,
      library: library ?? this.library,
      status: status ?? this.status
    );
  }

  @override
  List<Object> get props => [collections, status];
}