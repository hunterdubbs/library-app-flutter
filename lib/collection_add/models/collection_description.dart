import 'package:formz/formz.dart';

enum CollectionDescriptionValidationError { length }

class CollectionDescription extends FormzInput<String, CollectionDescriptionValidationError>{
  const CollectionDescription.pure() : super.pure('');
  const CollectionDescription.dirty([String value = '']) : super.dirty(value);

  @override
  CollectionDescriptionValidationError? validator(String? value) {
    if(value != null && value.length > 255) return CollectionDescriptionValidationError.length;
    return null;
  }
}