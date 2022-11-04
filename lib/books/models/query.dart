import 'package:equatable/equatable.dart';

enum QueryType { title, author }
enum SortType { alphabetic, dateAddedNewest, dateAddedOldest }

class Query extends Equatable {
  const Query({
    required this.searchTerm,
    required this.queryType,
    required this.sortType
  });

  final String searchTerm;
  final QueryType queryType;
  final SortType sortType;

  Query copyWith({
    String? searchTerm,
    QueryType? queryType,
    SortType? sortType
  }) {
    return Query(
      searchTerm: searchTerm ?? this.searchTerm,
      queryType: queryType ?? this.queryType,
      sortType: sortType ?? this.sortType
    );
  }

  @override
  List<Object> get props => [searchTerm, queryType, sortType];
}

class QueryMappings {
  const QueryMappings();

  static Map<String, QueryType> get queryTypeMappings => {
    'Search By Title': QueryType.title,
    'Search By Author': QueryType.author
  };

  static Map<String, SortType> get sortTypeMappings => {
    'Sort Alphabetic': SortType.alphabetic,
    'Sort Date Added Newest': SortType.dateAddedNewest,
    'Sort Date Added Oldest': SortType.dateAddedOldest
  };
}