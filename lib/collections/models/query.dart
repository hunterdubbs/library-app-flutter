import 'package:equatable/equatable.dart';

class Query extends Equatable {
  const Query({
    required this.searchTerm
  });

  final String searchTerm;

  Query copyWith({
    String? searchTerm
  }) {
    return Query(
      searchTerm: searchTerm ?? this.searchTerm
    );
  }

  @override
  List<Object> get props => [searchTerm];
}