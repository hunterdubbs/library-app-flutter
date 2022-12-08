import 'package:formz/formz.dart';

enum LibraryNameValidationError { empty, length }

class LibraryName extends FormzInput<String, LibraryNameValidationError>{
  const LibraryName.pure() : super.pure('');
  const LibraryName.dirty([String value = '']) : super.dirty(value);

  @override
  LibraryNameValidationError? validator(String? value) {
    if(value == null || value.isEmpty) return LibraryNameValidationError.empty;
    if(value.length > 80) return LibraryNameValidationError.length;
    return null;
  }
}