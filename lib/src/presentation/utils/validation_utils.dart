import 'package:frappe_form/src/presentation/localization/doc_form_localization.dart';
import 'package:flutter/material.dart';
import 'package:frappe_form/src/logic/utils/num_utils.dart';
import 'package:frappe_form/src/logic/utils/text_utils.dart';
import 'package:intl_phone_field/countries.dart';

class ValidationUtils {
  static ValidationController get requiredFieldValidation =>
      EnhancedEmptyValidationController(
          message:
              DocFormLocalization.instance.localization.exceptionNoEmptyField);

  static ValidationController get positiveIntegerNumberValidation =>
      PositiveIntegerValidationController(
          message: DocFormLocalization.instance.localization
              .exceptionValueMustBeAPositiveIntegerNumber);

  static ValidationController positiveNumberValidation({
    String? message,
    bool required = false,
  }) =>
      ValidationController(
          message: message ??
              DocFormLocalization
                  .instance.localization.exceptionValueMustBeAPositiveNumber,
          isValid: ({controller}) {
            String? textValue = controller?.rawValue?.toString();
            if (!required && textValue.isEmpty) return true;
            num? value = NumUtils.tryParse(textValue!);
            return (value ?? -1) >= 0;
          });

  static ValidationController numberValidation({
    String? message,
    bool required = false,
  }) =>
      ValidationController(
          message: message ??
              DocFormLocalization
                  .instance.localization.exceptionValueMustBeANumber,
          isValid: ({controller}) {
            String? textValue = controller?.rawValue?.toString();
            if (!required && textValue.isEmpty) return true;
            num? value = NumUtils.tryParse(textValue!);
            return value != null;
          });

  static ValidationController integerRangeValidationController(
          {required int minValue, required int maxValue}) =>
      IntegerRangeValidationController(
        message: DocFormLocalization.instance.localization
            .exceptionValueOutOfRange(minValue, maxValue),
        minValue: minValue,
        maxValue: maxValue,
      );

  static List<ValidationController>
      get requiredPositiveIntegerNumberValidations => [
            requiredFieldValidation,
            positiveIntegerNumberValidation,
          ];

  static List<ValidationController> get requiredPositiveNumberValidations => [
        requiredFieldValidation,
        positiveNumberValidation(),
      ];

  static ValidationController lengthValidation({
    int minLength = 0,
    int? maxLength,
    String? message,
    bool required = false,
    bool considerExtendedCharacters = true,
  }) =>
      ValidationController(
          message: message ??
              DocFormLocalization.instance.localization
                  .exceptionTextLength(minLength, maxLength ?? (minLength * 2)),
          isValid: ({controller}) {
            String textValue = controller?.rawValue?.toString().trim() ?? '';
            int length = considerExtendedCharacters
                ? textValue.characters.length
                : textValue.length;
            if (!required && length == 0) return true;
            return length >= minLength &&
                (maxLength == null || length <= maxLength);
          });

  static ValidationController maxLengthValidation({
    required int maxLength,
    String? message,
    bool required = false,
    bool considerExtendedCharacters = true,
  }) =>
      ValidationController(
          message: message ??
              DocFormLocalization.instance.localization
                  .exceptionTextMaxLength(maxLength),
          isValid: ({controller}) {
            String textValue = controller?.rawValue?.toString().trim() ?? '';
            int length = considerExtendedCharacters
                ? textValue.characters.length
                : textValue.length;
            if (!required && length == 0) return true;
            return length <= maxLength;
          });

  static ValidationController urlValidation({
    String? message,
    bool required = false,
  }) =>
      UrlValidationController(
        message: message ??
            DocFormLocalization.instance.localization.exceptionInvalidUrl,
        required: required,
      );

  static bool isPhoneNumberValid({String? number, Country? country}) {
    return number != null &&
        country != null &&
        number.length >= country.minLength &&
        number.length <= country.maxLength;
  }
}

class EnhancedEmptyValidationController extends ValidationController {
  EnhancedEmptyValidationController({String? message})
      : super(
          message: message ??
              DocFormLocalization.instance.localization.exceptionNoEmptyField,
          isValid: ({controller}) {
            final rawValue = controller?.rawValue;
            if (rawValue is List) {
              return rawValue.isNotEmpty;
            } else {
              return TextUtils.isNotEmpty(rawValue?.toString().trim());
            }
          },
        );
}
