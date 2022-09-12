part of 'collections_bloc.dart';

abstract class CollectionsEvent extends Equatable {
  const CollectionsEvent();

  @override
  List<Object> get props => [];
}

class LoadCollectionsEvent extends CollectionsEvent {
  const LoadCollectionsEvent();
}

class CollectionDeletedEvent extends CollectionsEvent {
  const CollectionDeletedEvent(this.collectionId);

  final int collectionId;

  @override
  List<Object> get props => [collectionId];
}