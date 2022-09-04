import 'package:formz/formz.dart';

enum LibraryNameValidationError { empty, length, specialChars }

class LibraryName extends FormzInput<String, LibraryNameValidationError>{
  const LibraryName.pure() : super.pure('');
  const LibraryName.dirty([String value = '']) : super.dirty(value);

  static final regex = RegExp(r'^[a-zA-Z0-9 ]+$');

  @override
  LibraryNameValidationError? validator(String? value) {
    if(value == null || value.isEmpty) return LibraryNameValidationError.empty;
    if(value.length > 80) return LibraryNameValidationError.length;
    if(!regex.hasMatch(value)) return LibraryNameValidationError.specialChars;
    return null;
  }
}