import 'package:formz/formz.dart';

enum CollectionNameValidationError { empty, length }

class CollectionName extends FormzInput<String, CollectionNameValidationError>{
  const CollectionName.pure() : super.pure('');
  const CollectionName.dirty([String value = '']) : super.dirty(value);

  @override
  CollectionNameValidationError? validator(String? value) {
    if(value == null || value.isEmpty) return CollectionNameValidationError.empty;
    if(value.length > 80) return CollectionNameValidationError.length;
    return null;
  }
}