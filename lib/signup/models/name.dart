import 'package:formz/formz.dart';

/// {@template name}
/// Form input for a name field.
/// {@endtemplate}
class Name extends FormzInput<String, NameValidationError> {
  /// {@macro name}
  const Name.dirty([super.value = '']) : super.dirty();

  /// {@macro name}
  const Name.pure() : super.pure('');

  @override
  NameValidationError? validator(String value) {
    if (value.isEmpty) return NameValidationError.empty;
    if (value.length < 2) return NameValidationError.tooShort;
    return null;
  }
}

/// Validation errors for the [Name] [FormzInput].
enum NameValidationError {
  /// Name is empty
  empty,
  /// Name is too short
  tooShort
}
