import 'package:formz/formz.dart';

enum VolumeValidationError { length }

class Volume extends FormzInput<String, VolumeValidationError>{
  const Volume.pure() : super.pure('');
  const Volume.dirty([String value = '']) : super.dirty(value);

  @override
  VolumeValidationError? validator(String? value) {
    if(value != null && value.length > 3) return VolumeValidationError.length;
    return null;
  }
}