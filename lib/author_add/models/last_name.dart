import 'package:formz/formz.dart';

enum LastNameValidationError { empty, length }

class LastName extends FormzInput<String, LastNameValidationError>{
  const LastName.pure() : super.pure('');
  const LastName.dirty([String value = '']) : super.dirty(value);

  @override
  LastNameValidationError? validator(String? value) {
    if(value == null || value.isEmpty) return LastNameValidationError.empty;
    if(value.length > 40) return LastNameValidationError.length;
    return null;
  }
}