part of 'collections_bloc.dart';

abstract class CollectionsEvent extends Equatable {
  const CollectionsEvent();

  @override
  List<Object> get props => [];
}

class LoadCollectionsEvent extends CollectionsEvent {
  const LoadCollectionsEvent();
}
