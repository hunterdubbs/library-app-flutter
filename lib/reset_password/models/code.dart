import 'package:formz/formz.dart';

enum CodeValidationError { empty, length }

class Code extends FormzInput<String, CodeValidationError> {
  const Code.pure() : super.pure('');
  const Code.dirty([String value = '']) : super.dirty(value);

  @override
  CodeValidationError? validator(String? value){
    if(value == null || value.isEmpty) return CodeValidationError.empty;
    if(value.length > 10) return CodeValidationError.length;
    return null;
  }
}