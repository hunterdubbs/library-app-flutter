part of 'tag_add_bloc.dart';

class TagAddState extends Equatable {
  const TagAddState({
    this.status = FormzStatus.pure,
    this.name = const Name.pure(),
    required this.libraryId,
    this.tag
  });

  final FormzStatus status;
  final Name name;
  final int libraryId;
  final Tag? tag;

  TagAddState copyWith({
    FormzStatus? status,
    Name? name,
    Tag? tag
  }) {
    return TagAddState(
      status: status ?? this.status,
      name: name ?? this.name,
      libraryId: libraryId,
      tag: tag ?? this.tag
    );
  }

  @override
  List<Object> get props => [status, name, libraryId];
}