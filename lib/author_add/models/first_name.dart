import 'package:formz/formz.dart';

enum FirstNameValidationError { empty, length }

class FirstName extends FormzInput<String, FirstNameValidationError>{
  const FirstName.pure() : super.pure('');
  const FirstName.dirty([String value = '']) : super.dirty(value);

  @override
  FirstNameValidationError? validator(String? value) {
    if(value == null || value.isEmpty) return FirstNameValidationError.empty;
    if(value.length > 40) return FirstNameValidationError.length;
    return null;
  }
}