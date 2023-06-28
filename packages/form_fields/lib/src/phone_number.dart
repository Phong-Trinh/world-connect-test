import 'package:formz/formz.dart';

enum PhoneNumberValidationError { invalid }

class PhoneNumber extends FormzInput<String, PhoneNumberValidationError>
    with FormzInputErrorCacheMixin {
  PhoneNumber.pure([super.value = '']) : super.pure();

  PhoneNumber.dirty([super.value = '']) : super.dirty();

  static final _phoneNumberRegExp = RegExp(
    r'^(?:[+0][1-9])?[0-9]{10}$',
  );

  @override
  PhoneNumberValidationError? validator(String value) {
    return _phoneNumberRegExp.hasMatch(value)
        ? null
        : PhoneNumberValidationError.invalid;
  }
}
