import 'package:email_validator/email_validator.dart';
import 'package:formz/formz.dart';

enum EmailValidationError { empty, length, format }

class Email extends FormzInput<String, EmailValidationError> {
  const Email.pure() : super.pure('');
  const Email.dirty([String value = '']) : super.dirty(value);

  @override
  EmailValidationError? validator(String? value) {
    if(value == null || value.isEmpty) return EmailValidationError.empty;
    if(value.length > 255) return EmailValidationError.length;
    if(!EmailValidator.validate(value)) return EmailValidationError.format;
    return null;
  }
}