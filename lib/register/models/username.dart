import 'package:formz/formz.dart';

enum UsernameValidationError { empty, length, specialChars }

class Username extends FormzInput<String, UsernameValidationError> {
  const Username.pure() : super.pure('');
  const Username.dirty([String value = '']) : super.dirty(value);

  static final regex = RegExp(r'^[a-zA-Z0-9 ]+$');

  @override
  UsernameValidationError? validator(String? value) {
    if(value == null || value.isEmpty) return UsernameValidationError.empty;
    if(value.length > 255) return UsernameValidationError.length;
    if(!regex.hasMatch(value)) return UsernameValidationError.specialChars;
    return null;
  }
}