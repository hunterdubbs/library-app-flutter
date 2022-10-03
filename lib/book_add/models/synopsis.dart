import 'package:formz/formz.dart';

enum SynopsisValidationError { empty, length }

class Synopsis extends FormzInput<String, SynopsisValidationError>{
  const Synopsis.pure() : super.pure('');
  const Synopsis.dirty([String value = '']) : super.dirty(value);

  @override
  SynopsisValidationError? validator(String? value) {
    if(value == null || value.isEmpty) return SynopsisValidationError.empty;
    if(value.length > 1023) return SynopsisValidationError.length;
    return null;
  }
}