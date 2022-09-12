import 'package:formz/formz.dart';

enum CollectionNameValidationError { empty, length, specialChars }

class CollectionName extends FormzInput<String, CollectionNameValidationError>{
  const CollectionName.pure() : super.pure('');
  const CollectionName.dirty([String value = '']) : super.dirty(value);

  static final regex = RegExp(r'^[a-zA-Z0-9 ]+$');

  @override
  CollectionNameValidationError? validator(String? value) {
    if(value == null || value.isEmpty) return CollectionNameValidationError.empty;
    if(value.length > 80) return CollectionNameValidationError.length;
    if(!regex.hasMatch(value)) return CollectionNameValidationError.specialChars;
    return null;
  }
}