part of 'book_collections_bloc.dart';

abstract class BookCollectionsEvent extends Equatable {
  const BookCollectionsEvent();

  @override
  List<Object> get props => [];
}

class LoadCollectionMemberships extends BookCollectionsEvent{
  const LoadCollectionMemberships();
}

class CheckboxToggled extends BookCollectionsEvent{
  const CheckboxToggled(this.collectionId);

  final int collectionId;

  @override
  List<Object> get props => [collectionId];
}

class SubmitCollectionMemberships extends BookCollectionsEvent{
  const SubmitCollectionMemberships();
}