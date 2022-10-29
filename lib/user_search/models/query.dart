import 'package:formz/formz.dart';

enum QueryValidationError { empty, length }

class Query extends FormzInput<String, QueryValidationError>{
  const Query.pure() : super.pure('');
  const Query.dirty([String value = '']) : super.dirty(value);

  @override
  QueryValidationError? validator(String? value) {
    if(value == null || value.isEmpty) return QueryValidationError.empty;
    if(value.length > 100) return QueryValidationError.length;
    return null;
  }
}