import 'package:equatable/equatable.dart';

enum QueryType { title, author, tag }
enum SortType { alphabetic, dateAddedNewest, dateAddedOldest }

class Query extends Equatable {
  const Query({
    required this.searchTerm,
    required this.queryType,
    required this.sortType,
    required this.editorVisible
  });

  final String searchTerm;
  final QueryType queryType;
  final SortType sortType;
  final bool editorVisible;

  Query copyWith({
    String? searchTerm,
    QueryType? queryType,
    SortType? sortType,
    bool? editorVisible
  }) {
    return Query(
      searchTerm: searchTerm ?? this.searchTerm,
      queryType: queryType ?? this.queryType,
      sortType: sortType ?? this.sortType,
      editorVisible: editorVisible ?? this.editorVisible
    );
  }

  @override
  List<Object> get props => [searchTerm, queryType, sortType, editorVisible];
}

class QueryMappings {
  const QueryMappings();

  static Map<String, QueryType> get queryTypeMappings => {
    'Search By Title': QueryType.title,
    'Search By Author': QueryType.author,
    'Search By Tag': QueryType.tag
  };

  static Map<String, SortType> get sortTypeMappings => {
    'Sort Alphabetic': SortType.alphabetic,
    'Sort Date Added Newest': SortType.dateAddedNewest,
    'Sort Date Added Oldest': SortType.dateAddedOldest
  };
}