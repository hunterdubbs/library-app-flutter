part of 'collection_add_bloc.dart';

abstract class CollectionAddEvent extends Equatable {
  const CollectionAddEvent();

  @override
  List<Object> get props => [];
}

class NameChanged extends CollectionAddEvent{
  const NameChanged(this.name);

  final String name;

  @override
  List<Object> get props => [name];
}

class DescriptionChanged extends CollectionAddEvent{
  const DescriptionChanged(this.description);

  final String description;

  @override
  List<Object> get props => [description];
}

class Submitted extends CollectionAddEvent{
  const Submitted();
}
