part of 'tags_bloc.dart';

enum TagsStatus{ initial, loading, loaded, errorLoading }

class TagsState extends Equatable {
  const TagsState({
    this.status = TagsStatus.initial,
    this.tags = const <Tag>[],
    required this.libraryId
  });

  final TagsStatus status;
  final List<Tag> tags;
  final int libraryId;

  TagsState copyWith({
    TagsStatus? status,
    List<Tag>? tags
  }) {
    return TagsState(
      status: status ?? this.status,
      tags: tags ?? this.tags,
      libraryId: libraryId
    );
  }

  @override
  List<Object> get props => [status, tags, libraryId];
}