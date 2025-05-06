import 'dart:ui';

abstract class DocFormBaseLocalization {
  final Locale locale;

  DocFormBaseLocalization(this.locale);

  String get btnSubmit;
  String get btnUpload;
  String get btnChange;
  String get btnRemove;
  String get textOtherOption;
  String get textDate;
  String get textTime;
  String get textLatitude;
  String get textLongitude;
  String get textPhone;
  String get exceptionNoEmptyField;
  String get textSearchPhoneCountryCode;
  String get exceptionValueMustBeAPositiveIntegerNumber;
  String get exceptionValueMustBeAPositiveNumber;
  String get exceptionValueMustBeANumber;
  String get exceptionInvalidUrl;
  String get exceptionInvalidPhoneNumber;
  String exceptionValueOutOfRange(dynamic minValue, dynamic maxValue);
  String exceptionTextLength(dynamic minLength, dynamic maxLength);
  String exceptionTextMaxLength(dynamic maxLength);
}
