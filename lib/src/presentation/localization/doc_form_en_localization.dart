import 'dart:ui';

import 'package:frappe_form/src/presentation/localization/doc_form_base_localization.dart';

/// English localizations
class DocFormEnLocalization extends DocFormBaseLocalization {
  DocFormEnLocalization() : super(Locale('en', 'US'));

  @override
  String get btnSubmit => 'Submit';
  @override
  String get btnUpload => 'Upload';
  @override
  String get btnChange => 'Change';
  @override
  String get btnRemove => 'Remove';
  @override
  String get textOtherOption => 'Other option';
  @override
  String get textDate => 'Date';
  @override
  String get textTime => 'Time';
  @override
  String get textLatitude => 'Latitude';
  @override
  String get textLongitude => 'Longitude';
  @override
  String get textPhone => 'Phone';
  @override
  String get textSearchPhoneCountryCode => 'Country name or dial code';
  @override
  String get exceptionNoEmptyField => 'This field is required.';
  @override
  String get exceptionValueMustBeAPositiveIntegerNumber =>
      'Value must be a positive integer number.';
  @override
  String get exceptionValueMustBeAPositiveNumber =>
      'Value must be a positive number.';
  @override
  String get exceptionValueMustBeANumber => 'Value must be a number.';
  @override
  String get exceptionInvalidUrl => 'Invalid url.';
  @override
  String get exceptionInvalidPhoneNumber => 'Invalid phone number.';
  @override
  String exceptionValueOutOfRange(dynamic minValue, dynamic maxValue) =>
      'The value must be in a range of $minValue to $maxValue.';
  @override
  String exceptionTextLength(dynamic minLength, dynamic maxLength) =>
      'Text must be at least $minLength characters and $maxLength at most.';
  @override
  String exceptionTextMaxLength(dynamic maxLength) =>
      'Text must be $maxLength characters at most.';
}
