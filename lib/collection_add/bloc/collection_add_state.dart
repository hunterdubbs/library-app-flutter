part of 'collection_add_bloc.dart';

class CollectionAddState extends Equatable {
  const CollectionAddState({
    this.status = FormzStatus.pure,
    this.name = const CollectionName.pure(),
    this.description = const CollectionDescription.pure(),
    this.isEdit = false,
    this.libraryId = 0,
    this.collectionId = 0
  });

  static CollectionAddState initial({
    required int libraryId,
    Collection? collection
  }) {
    if(collection != null){
      return CollectionAddState(
        status: FormzStatus.valid,
        name : CollectionName.dirty(collection.name),
        description: CollectionDescription.dirty(collection.description),
        isEdit: true,
        collectionId: collection.id,
        libraryId: libraryId
      );
    }else{
      return CollectionAddState(libraryId: libraryId);
    }
  }

  final FormzStatus status;
  final CollectionName name;
  final CollectionDescription description;
  final bool isEdit;
  final int libraryId;
  final int collectionId;

  CollectionAddState copyWith({
    FormzStatus? status,
    CollectionName? name,
    CollectionDescription? description,
    bool? isEdit,
    int? libraryId,
    int? collectionId
  }) {
    return CollectionAddState(
      status: status ?? this.status,
      name : name ?? this.name,
      description: description ?? this.description,
      isEdit : isEdit ?? this.isEdit,
      libraryId: libraryId ?? this.libraryId,
      collectionId: collectionId ?? this.collectionId
    );
  }

  @override
  List<Object> get props => [status, name, description, isEdit, libraryId, collectionId];
}