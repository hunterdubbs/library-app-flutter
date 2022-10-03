import 'package:formz/formz.dart';

enum DatePublishedValidationError { empty }

class DatePublished extends FormzInput<DateTime, DatePublishedValidationError>{
  DatePublished.pure() : super.pure(DateTime.fromMicrosecondsSinceEpoch(0));
  DatePublished.dirty(DateTime value) : super.dirty(value);

  @override
  DatePublishedValidationError? validator(DateTime? value) {
    if(value == null) return DatePublishedValidationError.empty;
    return null;
  }
}