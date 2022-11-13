part of 'collections_bloc.dart';

enum CollectionsStatus { initial, loading, loaded, errorLoading, modifying, modified }

class CollectionsState extends Equatable {
  const CollectionsState({
    this.collections = const <Collection>[],
    required this.library,
    this.status = CollectionsStatus.initial,
    this.errorMsg = '',
    this.query = const Query(
      searchTerm: ''
    )
});

  final List<Collection> collections;
  final CollectionsStatus status;
  final Library library;
  final String errorMsg;
  final Query query;

  CollectionsState copyWith({
    List<Collection>? collections,
    Library? library,
    CollectionsStatus? status,
    String? errorMsg,
    Query? query
}) {
    return CollectionsState(
      collections: collections ?? this.collections,
      library: library ?? this.library,
      status: status ?? this.status,
      errorMsg: errorMsg ?? this.errorMsg,
      query: query ?? this.query
    );
  }

  List<Collection> get filteredCollections {
    var filteredCollections = collections;
    if(query.searchTerm.isNotEmpty){
      final normalizedSearchTerm = query.searchTerm.trim().toLowerCase();
      filteredCollections = filteredCollections.where((c) => (c.name.toLowerCase() + c.description.toLowerCase()).contains(normalizedSearchTerm)).toList();
    }
    return filteredCollections;
  }

  @override
  List<Object> get props => [collections, status, library, errorMsg, query];
}