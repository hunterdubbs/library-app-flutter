import 'package:formz/formz.dart';

enum TitleValidationError { empty, length }

class Title extends FormzInput<String, TitleValidationError>{
  const Title.pure() : super.pure('');
  const Title.dirty([String value = '']) : super.dirty(value);

  @override
  TitleValidationError? validator(String? value) {
    if(value == null || value.isEmpty) return TitleValidationError.empty;
    if(value.length > 255) return TitleValidationError.length;
    return null;
  }
}