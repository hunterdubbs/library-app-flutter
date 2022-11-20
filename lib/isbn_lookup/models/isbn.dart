import 'package:formz/formz.dart';

enum IsbnValidationError{ empty, format }

class Isbn extends FormzInput<String, IsbnValidationError> {
  const Isbn.pure() : super.pure('');
  const Isbn.dirty([String value = '']) : super.dirty(value);

  static final regex = RegExp(r'^(?=[A-Za-z0-9]*$)(?:.{10}|.{13})$');

  @override
  IsbnValidationError? validator(String? value) {
    if(value == null || value.isEmpty) return IsbnValidationError.empty;
    if(value.length != 10 && value.length != 13) return IsbnValidationError.format;
    if(!regex.hasMatch(value)) return IsbnValidationError.format;
    return null;
  }
}