import 'package:formz/formz.dart';

enum SeriesValidationError { length }

class Series extends FormzInput<String, SeriesValidationError>{
  const Series.pure() : super.pure('');
  const Series.dirty([String value = '']) : super.dirty(value);

  @override
  SeriesValidationError? validator(String? value) {
    if(value != null && value.length > 80) return SeriesValidationError.length;
    return null;
  }
}