import 'package:formz/formz.dart';

enum CollectionDescriptionValidationError { empty, length, specialChars }

class CollectionDescription extends FormzInput<String, CollectionDescriptionValidationError>{
  const CollectionDescription.pure() : super.pure('');
  const CollectionDescription.dirty([String value = '']) : super.dirty(value);

  static final regex = RegExp(r'^[a-zA-Z0-9 ]+$');

  @override
  CollectionDescriptionValidationError? validator(String? value) {
    if(value == null || value.isEmpty) return CollectionDescriptionValidationError.empty;
    if(value.length > 255) return CollectionDescriptionValidationError.length;
    if(!regex.hasMatch(value)) return CollectionDescriptionValidationError.specialChars;
    return null;
  }
}